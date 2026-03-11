import {
  executeQuery,
  executeStoredProcedure,
  apiHandler,
  uploadToCloudinary,
} from "../utils/index.js";
import path from "path";

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
