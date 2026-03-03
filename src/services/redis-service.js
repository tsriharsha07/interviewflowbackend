import redisClient from "../config/redisConfig.js";

/* ===========================
   BASIC OPERATIONS
=========================== */

export async function setCache(key, value, ttl = 60) {
  await redisClient.set(key, JSON.stringify(value), {
    EX: ttl,
  });
}

export async function getCache(key) {
  const data = await redisClient.get(key);
  return data ? JSON.parse(data) : null;
}

export async function deleteCache(key) {
  await redisClient.del(key);
}

/* ===========================
   RBAC / PERMISSIONS
=========================== */

export async function cacheRolePermissions(role, permissions, ttl = 3600) {
  await setCache(`permissions:${role}`, permissions, ttl);
}

export async function getRolePermissions(role) {
  return await getCache(`permissions:${role}`);
}

export async function storeRefreshToken(jti, token, ttl = 1 * 24 * 60 * 60) {
  await redisClient.set(`refresh:${jti}`, token, { EX: ttl });
}

export async function getRefreshToken(jti) {
  return await redisClient.get(`refresh:${jti}`);
}

export async function revokeRefreshToken(jti) {
  await redisClient.del(`refresh:${jti}`);
}
