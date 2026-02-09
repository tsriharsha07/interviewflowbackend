import jwt from "jsonwebtoken";
import { apiHandler, executeStoredProcedure } from "../utils/index.js";

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

export const createRefreshToken = (payload) => {
  return jwt.sign(payload, process.env.JWT_REFRESH_TOKEN_SECRET, {
    expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || "7d",
    issuer: "SriHarsha",
  });
};

export const populatePermissions = async (iRoleId) => {
  try {
    const permissionRes = await executeStoredProcedure(
      "uspGetModulesByRoleId",
      {
        iRoleId,
      },
    );
    let permissionMap = permissionRes.recordsets[0];
    let permissions = transformPermissions(permissionMap);

    req.user.permissions = permissions;
  } catch (error) {
    console.log("Error occured", error);
  }
};

const transformPermissions = (permissionMap) => {
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
