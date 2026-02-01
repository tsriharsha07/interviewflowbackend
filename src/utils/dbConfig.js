import sql from "mssql";
import dotenv from "dotenv";
dotenv.config();

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: false,
    trustServerCertificate: true,
    port: 1433,
  },
};

const poolPromise = new sql.ConnectionPool(dbConfig)
  .connect()
  .then((pool) => {
    console.log("✅ Database connected successfully");
    return pool;
  })
  .catch((err) => {
    console.error("❌ Database connection failed: ", err);
    process.exit(1);
  });

export async function executeQuery(query, params = {}) {
  const pool = await poolPromise;
  const request = pool.request();
  for (const key in params) {
    request.input(key, params[key]);
  }
  const result = await request.query(query);
  return result.recordset;
}

export async function executeStoredProcedure(procName, params = {}) {
  const pool = await poolPromise;
  const request = pool.request();
  for (const key in params) {
    request.input(key, params[key]);
  }
  return request.execute(procName);
}

const dbMiddleware = async (req, res, next) => {
  try {
    req.db = { poolPromise, sql, executeQuery, executeStoredProcedure };
    next();
  } catch (err) {
    next(err);
  }
};

export default dbMiddleware;
