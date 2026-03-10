import jwt from "jsonwebtoken";
import { apiHandler, executeStoredProcedure } from "../utils/index.js";
import {
  cacheRolePermissions,
  getRolePermissions,
} from "../services/redis-service.js";
import { v4 as uuidv4 } from "uuid";

// ── 1. Validate Access Token ─────────────────────────────
export const validateAccessToken = async (req, res, next) => {
  const authorizationHeader = req.headers.authorization;

  if (!authorizationHeader) {
    return apiHandler.sendUnauthorizedError(res, null, "Token is missing");
  }

  const token = authorizationHeader.split(" ")[1];

  try {
    const data = jwt.verify(token, process.env.JWT_ACCESS_TOKEN_SECRET);
    req.user = data; // { sub, email, fullName, isSuperAdmin }
    next();
  } catch (error) {
    const message =
      error.name === "TokenExpiredError"
        ? "Token expired"
        : error.name === "JsonWebTokenError"
          ? "Invalid token"
          : "Authentication error";
    return apiHandler.sendUnauthorizedError(res, null, message);
  }
};
// middleware/authorize.js

export const populatePermissions = async (req, res, next) => {
  try {
    if (req.user.isSuperAdmin) {
      req.user.permissions = { "*": ["*"] };
      return next();
    }

    const userId = req.user.sub;
    const workspaceId = parseInt(req.params.workspaceId) || null;
    const projectId = parseInt(req.params.projectId) || null;

    const result = await executeStoredProcedure("uspGetUserPermissions", {
      iUserId: userId,
      iWorkspaceId: workspaceId,
      iProjectId: projectId,
    });

    const memberInfo = result.recordsets[0]?.[0]; // membership + role info
    const permissions = result.recordsets[1]; // permission rows

    // ✅ Not a member of THIS workspace/project → block immediately
    if (!memberInfo) {
      return res.status(403).json({ message: "Access denied" });
    }

    // ✅ Attach role info for controllers to use if needed
    req.user.roleId = memberInfo.iRoleId;
    req.user.roleName = memberInfo.sRoleName;

    // ✅ Attach permissions
    req.user.permissions = transformPermissions(permissions);

    next();
  } catch (error) {
    console.error("populatePermissions error:", error);
    return res.status(500).json({ message: "Failed to load permissions" });
  }
};

// ── 3. Fixed transformPermissions ────────────────────────
// Builds: { "Tasks": ["create","edit"], "Board": ["view"] }

export const transformPermissions = (permissionRows) => {
  const permissions = {};

  permissionRows.forEach((row) => {
    // ✅ 'row' matches parameter
    const module = row.ModuleName;
    const permission = row.PermissionName;

    if (!permissions[module]) {
      permissions[module] = [];
    }
    permissions[module].push(permission);
  });

  return permissions;
};

// ── 4. Authorize by Permission ───────────────────────────
export const authorizePermission = (resource, action) => {
  return (req, res, next) => {
    const permissions = req.user?.permissions;

    // Super admin wildcard
    if (permissions?.["*"]?.includes("*")) {
      return next();
    }

    if (!permissions || !permissions[resource]) {
      return res.status(403).json({ message: "Access denied" });
    }

    if (!permissions[resource].includes(action)) {
      return res.status(403).json({ message: "Access denied" });
    }

    next();
  };
};

// ── 5. Token Creators ────────────────────────────────────
export const createAccessToken = (payload) => {
  return jwt.sign(payload, process.env.JWT_ACCESS_TOKEN_SECRET, {
    expiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN || "15m",
    issuer: "SriHarsha",
  });
};

export const createRefreshToken = async (userId) => {
  const jti = uuidv4();
  const token = jwt.sign(
    { sub: userId, jti },
    process.env.JWT_REFRESH_TOKEN_SECRET,
    {
      expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || "7d",
      issuer: "SriHarsha",
    },
  );
  return token;
};
