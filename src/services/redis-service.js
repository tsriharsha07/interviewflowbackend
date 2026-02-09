import redisClient from "../config/redis.js";

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

export async function cacheUserPermissions(userId, permissions, ttl = 3600) {
  await setCache(`permissions:${userId}`, permissions, ttl);
}

export async function getUserPermissions(userId) {
  return await getCache(`permissions:${userId}`);
}

/* ===========================
   JWT / SESSION
=========================== */

export async function storeRefreshToken(userId, token, ttl = 7 * 24 * 60 * 60) {
  await redisClient.set(`refresh:${userId}`, token, { EX: ttl });
}

export async function getRefreshToken(userId) {
  return await redisClient.get(`refresh:${userId}`);
}

export async function revokeRefreshToken(userId) {
  await redisClient.del(`refresh:${userId}`);
}
