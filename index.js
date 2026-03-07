import dotenv from "dotenv";

const environment = process.env.NODE_ENV || "development";
console.log(`Environment: ${environment}`);

const result = dotenv.config({ path: `.env.${environment}` });
if (result.error) {
  console.log(`Error Starting the Server: ${result.error}`);
  process.exit(1);
}

import express from "express";
import cors from "cors";
import http from "http";
import cookieParser from "cookie-parser";
import authRouter from "./src/routes/auth.routes.js";
import { connectRedis } from "./src/config/redisConfig.js";

const port = process.env.PORT;
const app = express();

const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(",") || [
  "http://localhost:5173",
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, Postman, etc.)
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error(`CORS policy: Origin ${origin} not allowed`));
      }
    },
    credentials: true,
  }),
);

app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));

// Response interceptor BEFORE routes
await connectRedis();
app.use((req, res, next) => {
  const oldJson = res.json;
  res.json = (body) => {
    res.locals.body = body;
    return oldJson.call(res, body);
  };
  next();
});

app.use("/api/v1/auth", authRouter);

// 404 handler AFTER routes
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: "Bad Request",
    status: 404,
  });
});

const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server Started ON Port ${port} AS ${environment} Environment`);
});
