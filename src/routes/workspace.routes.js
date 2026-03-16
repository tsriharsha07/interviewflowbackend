import { Router } from "express";
import {
  createWorkSpace,
  getWorkSpaces,
  validateWorkspaceInvite,
  acceptWorkspaceInvitation,
  inviteMembersToWorkSpace,
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

router.post("/invite-member", validateAccessToken, inviteMembersToWorkSpace);
router.post("/validate-invite", validateAccessToken, validateWorkspaceInvite);
router.post("/accept-invite", validateAccessToken, acceptWorkspaceInvitation);

export default router;
