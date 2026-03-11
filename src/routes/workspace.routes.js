import { Router } from "express";
import {
  createWorkSpace,
  getWorkSpaces,
} from "../controller/workspace.controller.js";
import {
  authorizePermission,
  populatePermissions,
  validateAccessToken,
} from "../middlewares/auth.js";

const router = Router();
import { upload } from "../middlewares/multer.js";

router.get("/get", validateAccessToken, getWorkSpaces);

router.post(
  "/create",
  validateAccessToken,
  upload.single("Image"),
  createWorkSpace,
);

export default router;
