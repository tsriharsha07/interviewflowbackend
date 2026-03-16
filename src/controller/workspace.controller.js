import {
  executeQuery,
  executeStoredProcedure,
  apiHandler,
  uploadToCloudinary,
} from "../utils/index.js";
import path from "path";
import crypto from "crypto";

export const getWorkSpaces = async (req, res, next) => {
  try {
    const { iUserId } = req.user;
    const limit = req.query.limit || 10;
    const page = req.query.page || 1;
    const search = req.query.search || "";

    const getUserWorkSpaces = await executeStoredProcedure(
      "uspGetWorkSpacesByUserId",
      {
        iUserId: iUserId,
        limit,
        page,
        search,
      },
    );

    const userWorkspaces = getUserWorkSpaces.recordsets[0];
    const totalCount = getUserWorkSpaces.recordsets[1][0].totalCount;

    apiHandler.sendSucess(
      res,
      { userWorkspaces, totalCount },
      "WorkSpaces fetched successfully!",
    );
  } catch (error) {
    console.log("Error fetching workspcaes", error);
    apiHandler.sendServerError(res, {}, error.message);
  }
};

export const createWorkSpace = async (req, res, next) => {
  try {
    const { iUserId } = req.user;
    const { sName, sSlug, sDescription, nMaxNumbers } = req.body;
    let logoUrl;
    if (!sName || !sSlug || !sDescription || !nMaxNumbers) {
      return apiHandler.sendBadRequest(res, {}, "All fields are required");
    }

    if (!sName || !sSlug || !sDescription || !nMaxNumbers) {
      return apiHandler.sendBadRequest(res, {}, "Missing required fields");
    }

    const maxMembers = Number(nMaxNumbers);

    if (isNaN(maxMembers) || maxMembers <= 0) {
      return apiHandler.sendBadRequest(res, {}, "Invalid member count");
    }

    if (maxMembers > 15) {
      return apiHandler.sendBadRequest(res, {}, "Workspace member limit is 15");
    }
    if (req.file) {
      const absolutePath = path.resolve(req.file.path); // converts to absolute path
      logoUrl = await uploadToCloudinary(absolutePath);
    }

    const result = await executeStoredProcedure("uspCreateWorkspace", {
      iCreatedBy: iUserId,
      sDescription,
      sName,
      sSlug,
      nMaxNumbers,
      sLogoUrl: logoUrl,
    });

    const response = result.recordsets[0][0];
    if (!response.Status) {
      return apiHandler.sendError(res, {}, response.Message);
    }

    apiHandler.sendSucess(res, {}, "Workspace created Successfully!");
  } catch (error) {
    console.log("Errpr", error);
    console.error("Error occured while creaeting workspace", error);
    apiHandler.sendServerError(res, {}, error);
  }
};

export const inviteMembersToWorkSpace = async (req, res) => {
  try {
    const { iUserId } = req.user;
    const { email, roleName, iWorkSpaceId } = req.body;

    if (!email || !roleName) {
      return apiHandler.sendError(res, {}, "Email and roleName are required");
    }

    const checkEmailExists = await executeQuery(
      "SELECT 1 FROM tblUsers WHERE sEmail = @email",
      { email },
    );

    if (!checkEmailExists.length) {
      return apiHandler.sendError(res, {}, "Email doesn't exist in the system");
    }
    // Generate token
    const token = crypto.randomBytes(32).toString("hex");

    // Hash token
    const tokenHash = crypto.createHash("sha256").update(token).digest("hex");

    const result = await executeStoredProcedure("uspInviteWorkspaceMember", {
      WorkspaceId: iWorkSpaceId,
      InvitedBy: iUserId,
      Email: email,
      TokenHash: tokenHash,
      RoleName: `WORKSPACE_${roleName.toUpperCase()}`,
      ExpiryHours: 48,
    });

    const invitation = result?.recordset?.[0] || {};

    return apiHandler.sendSucess(
      res,
      {
        ...invitation,
        token, // send token to build invite link
      },
      "Invitation sent successfully",
    );
  } catch (error) {
    console.log("Error inviting member:", error);

    return apiHandler.sendServerError(res, {}, "Failed to send invitation");
  }
};

export const validateWorkspaceInvite = async (req, res) => {
  try {
    const { token } = req.query;

    if (!token) {
      return apiHandler.sendError(res, {}, "Token is required");
    }

    // Hash the token (same way as during invite)
    const tokenHash = crypto.createHash("sha256").update(token).digest("hex");

    const result = await executeStoredProcedure(
      "uspValidateWorkspaceInvitation",
      {
        TokenHash: tokenHash,
      },
    );

    const invite = result?.recordset?.[0];

    if (!invite) {
      return apiHandler.sendError(res, {}, "Invalid invitation link");
    }

    return apiHandler.sendSucess(res, invite, "Invitation is valid");
  } catch (error) {
    console.log("Error validating invite", error);
    apiHandler.sendServerError(res, {}, "Internal Server Error");
  }
};

export const acceptWorkspaceInvitation = async (req, res) => {
  try {
    const { token } = req.body;
    const { iUserId } = req.user;

    if (!token) {
      return apiHandler.sendError(res, {}, "Token is required");
    }

    // hash token
    const tokenHash = crypto.createHash("sha256").update(token).digest("hex");

    const result = await executeStoredProcedure(
      "uspAcceptWorkspaceInvitation",
      {
        TokenHash: tokenHash,
        UserId: iUserId,
      },
    );

    const data = result?.recordset?.[0];

    return apiHandler.sendSucess(res, data, "Successfully joined workspace");
  } catch (error) {
    console.log("Accept invite error:", error);

    return apiHandler.sendServerError(
      res,
      {},
      error.message || "Failed to accept invitation",
    );
  }
};
