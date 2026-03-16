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
    console.log(error);
    const message =
      error.name === "TokenExpiredError"
        ? "Token expired"
        : error.name === "JsonWebTokenError"
          ? "Invalid token"
          : "Authentication error";
    return apiHandler.sendUnauthorizedError(res, null, message);
  }
};

function buildPermissionCacheKey(userId, workspaceId, projectId) {
  let key = `permissions:user:${userId}`;

  if (workspaceId) {
    key += `:workspace:${workspaceId}`;
  }

  if (projectId) {
    key += `:project:${projectId}`;
  }

  return key;
}

export const populatePermissions = async (req, res, next) => {
  try {
    // Guard: ensure req.user exists
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    if (req.user.isSuperAdmin) {
      req.user.permissions = { "*": ["*"] };
      return next();
    }

    const userId = req.user.iUserId;

    if (!userId) {
      return res.status(401).json({ message: "User ID missing from token" });
    }

    // ✅ Fix: use explicit undefined/NaN check instead of || null
    const rawWorkspaceId = parseInt(req.params.workspaceId, 10);
    const rawProjectId = parseInt(req.params.projectId, 10);
    const workspaceId = !isNaN(rawWorkspaceId) ? rawWorkspaceId : null;
    const projectId = !isNaN(rawProjectId) ? rawProjectId : null;

    // 🔑 Build cache key
    const cacheKey = buildPermissionCacheKey(userId, workspaceId, projectId);

    // 🔹 1️⃣ Check cache FIRST
    let cachedData = null;
    try {
      cachedData = await getRolePermissions(cacheKey);
    } catch (cacheReadError) {
      // Non-fatal: log and fall through to DB
      console.warn(
        "Cache read failed, falling back to DB:",
        cacheReadError.message,
      );
    }

    // ✅ Restore permissions AND roleId/roleName from cache
    if (cachedData) {
      req.user.permissions = cachedData.permissions;
      req.user.roleId = cachedData.roleId;
      req.user.roleName = cachedData.roleName;
      return next();
    }

    // 🔹 2️⃣ Cache miss → call DB
    const result = await executeStoredProcedure("uspGetUserPermissions", {
      iUserId: userId,
      iWorkspaceId: workspaceId,
      iProjectId: projectId,
    });

    const memberInfo = result.recordsets?.[0]?.[0];
    const rawPermissions = result.recordsets?.[1] ?? [];

    if (!memberInfo) {
      return res.status(403).json({ message: "Access denied" });
    }

    req.user.roleId = memberInfo.iRoleId;
    req.user.roleName = memberInfo.sRoleName;

    const transformedPermissions = transformPermissions(rawPermissions);

    // ✅ Cache permissions AND role info together
    const cachePayload = {
      permissions: transformedPermissions,
      roleId: memberInfo.iRoleId,
      roleName: memberInfo.sRoleName,
    };

    // 🔹 3️⃣ Store in cache (non-fatal if it fails)
    try {
      await cacheRolePermissions(cacheKey, cachePayload);
    } catch (cacheWriteError) {
      console.warn("Cache write failed:", cacheWriteError.message);
    }

    req.user.permissions = transformedPermissions;
    next();
  } catch (error) {
    console.error("populatePermissions error:", error);
    return res
      .status(500)
      .json({ status: "fail", message: "Failed to load permissions" });
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
  const token = jwt.sign(payload, process.env.JWT_ACCESS_TOKEN_SECRET, {
    expiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN || "15m",
    issuer: "SriHarsha",
  });
  return token;
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
