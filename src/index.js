import dotenv from "dotenv";
const environment = process.env.NODE_ENV || "development";
console.log(`Environment: ${environment}`);
const result = dotenv.config({ path: `.env.${environment}` });
import cookieParser from "cookie-parser";

if (result.error) {
  console.log(`Error Starting the Server: ${result.error}`);
  process.exit(1);
}
import express from "express";
import cors from "cors";
import http from "http";
import authRouter from "./routes/auth.routes.js";

import { connectRedis } from "./config/redisConfig.js";

if (result.error) {
  console.log(`Error Starting the Server: ${result.error}`);
  process.exit(1);
}

const port = process.env.PORT;

const app = express();
await connectRedis();

app.use(
  cors({
    origin: "*",
    credentials: true,
  }),
);
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded());
app.use(express.static("public"));
app.use(
  cors({
    origin: "*",
  }),
);

app.use("/api/v1", authRouter);

app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: "Bad Request",
    status: 404,
  });
});

app.use((req, res, next) => {
  const oldJson = res.json;
  res.json = (body) => {
    res.locals.body = body;
    return oldJson.call(res, body);
  };
  next();
});

const server = http.createServer(app);

server.listen(port, () => {
  console.log(`Server Started ON Port ${port} AS ${environment} Environment`);
});
