import jwt from "jsonwebtoken";
import { apiHandler, executeStoredProcedure } from "../utils/index.js";
import {
  cacheRolePermissions,
  getRolePermissions,
  storeRefreshToken,
} from "../services/redis-service.js";
import { v4 as uuidv4 } from "uuid";

export const validateAccessToken = async (req, res, next) => {
  const authorizationHeader = req.headers.authorization;
  if (authorizationHeader) {
    const token = authorizationHeader.split(" ")[1];
    let data;
    try {
      data = jwt.verify(token, process.env.JWT_ACCESS_TOKEN_SECRET);
    } catch (error) {
      if (error.type === "expired" || error.type === "invalid") {
        return apiHandler.sendUnauthorizedError(
          res,
          null,
          error.type === "expired" ? "Token expired" : "Invalid Token",
        );
      } else {
        return apiHandler.sendUnauthorizedError(
          res,
          null,
          "Authentication Error",
        );
      }
    }

    req.auth = data;
    next();
  } else {
    return apiHandler.sendUnauthorizedError(res, null, "Token is missing");
  }
};

export const authorizePermission = (resource, action) => {
  return (req, res, next) => {
    const permissions = req.user.permissions;

    // Resource not present
    if (!permissions || !permissions[resource]) {
      return res.status(403).json({ message: "Access denied" });
    }

    // Action not allowed
    if (!permissions[resource].includes(action)) {
      return res.status(403).json({ message: "Access denied" });
    }

    next();
  };
};

export const createAccessToken = (payload) => {
  return jwt.sign(payload, process.env.JWT_ACCESS_TOKEN_SECRET, {
    expiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN || "15m",
    issuer: "SriHarsha",
  });
};

export const createRefreshToken = async (userId) => {
  const jti = uuidv4();

  const token = jwt.sign(
    {
      sub: userId,
      jti,
    },
    process.env.JWT_REFRESH_TOKEN_SECRET,
    {
      expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || "1d",
      issuer: "SriHarsha",
    },
  );
  await storeRefreshToken(jti, token);

  return token;
};

export const populatePermissions = async (req, res, next) => {
  try {
    const roleId = req.user.iRoleId;
    if (!roleId) {
      return res.status(401).json({ message: "Role not found" });
    }

    // 1️⃣ Check Redis (ROLE-WISE)
    const cachedPermissions = await getRolePermissions(roleId);
    if (cachedPermissions) {
      req.user.permissions = cachedPermissions;
      return next();
    }

    // 2️⃣ Fetch from DB
    const permissionRes = await executeStoredProcedure(
      "uspGetModulesByRoleId",
      { iRoleId: roleId },
    );

    const permissionMap = permissionRes.recordsets[0];
    const permissions = transformPermissions(permissionMap);

    // 3️⃣ Attach + cache
    req.user.permissions = permissions;
    await cacheRolePermissions(roleId, permissions);

    next();
  } catch (error) {
    console.error("populatePermissions error:", error);
    return res.status(500).json({ message: "Failed to load permissions" });
  }
};

export const transformPermissions = (permissionMap) => {
  let permissions = {};
  permissionMap.forEach((t) => {
    let module = row.ModuleName;
    let permission = row.PermissionName;
    if (!permissions[module]) {
      permissions[module] = [];
    }
    permissions[module].push(permission);
  });
  return permissions;
};
