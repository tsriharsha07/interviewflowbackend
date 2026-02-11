import {
  createAccessToken,
  createRefreshToken,
  transformPermissions,
} from "../middlewares/auth";
import {
  comparePassword,
  executeQuery,
  executeStoredProcedure,
  hashPassword,
} from "../utils";
import { apiHandler } from "../utils/apiHandler";

const login = async (req, res, next) => {
  try {
    const { sEmail, sPassword } = req.body;
    if (!sEmail || !sPassword) {
      return apiHandler.sendError(res, null, "Missing Feilds!");
    }
    const checkEmailExists = await executeQuery(
      "SELECT iUserId,sEmail,sPasswordHash FROM tblUsers where sEmail=@sEmail",
      {
        sEmail,
      },
    );
    if (!checkEmailExists.length) {
      return apiHandler.sendError(res, null, "Invalid credentials");
    }
    const checkPassword = comparePassword(
      sPassword,
      checkEmailExists[0].sPasswordHash,
    );

    if (!checkPassword) {
      return apiHandler.sendError(res, null, "Invalid credentials");
    }
    const getUserData = await executeStoredProcedure("uspGetUserData", {
      sEmail,
    });

    const userData = getUserData.recordsets[0];

    const permissionRes = await executeStoredProcedure(
      "uspGetModulesByRoleId",
      { iRoleId: userData[0]?.iRoleId },
    );

    const permissionMap = permissionRes.recordsets[0];
    const permissions = transformPermissions(permissionMap);

    const accessToken = createAccessToken({
      iUserId: userData[0].iUserId,
      iRoleId: userData[0].iRoleId,
    });

    const refreshToken = createRefreshToken({
      iUserId: userData[0].iUserId,
      iRoleId: userData[0].iRoleId,
    });

    return apiHandler.sendSucess(
      res,
      {
        userData,
        permissions,
        accessToken,
        refreshToken,
      },
      "User Logged In Successfully!",
    );
  } catch (error) {
    console.log("Error logging in", error);
    return apiHandler.sendError(res, null, "Erro occured during login!");
  }
};

const register = async (req, res) => {
  try {
    const {
      // USER
      sName,
      sEmail,
      sPassword,
      sPhone,
      iRoleId,

      // COMPANY (optional)
      sCompanyName,
      sIndustry,
      sWebsite,

      // INTERVIEWER
      sTitle,
      sDepartment,
      iCompanyId,
      sExpertiseAreas,
      iMaxInterviewsPerDay,
      iInterviewDuration,
      // RECRUITER
      sSpecialization,

      // CANDIDATE
      sLinkedInUrl,
      sGithubUrl,
      sSkills,
      iYearsOfExperience,
      sExpectedSalary,
      sNoticePeriod,
      bIsOpenToRelocation,
      bIsOpenToRemote,
      sCurrentCompany,
      sCurrentTitle,
    } = req.body;

    if (!sName || !sEmail || !sPassword || !sPhone || !iRoleId) {
      return apiHandler.sendError(res, null, "Missing required fields");
    }

    const passwordHash = await hashPassword(sPassword);

    const result = await executeStoredProcedure("uspRegisterUser", {
      sName,
      sEmail,
      sPasswordHash: passwordHash,
      sPhone,
      iRoleId,

      // Company
      sCompanyName,
      sIndustry,
      sWebsite,

      // Interviewer
      sTitle,
      sDepartment,
      sExpertiseAreas,
      iMaxInterviewsPerDay,

      // Recruiter
      sSpecialization,

      // Candidate
      sLinkedInUrl,
      sGithubUrl,
      sSkills,
      iYearsOfExperience,
      iInterviewDuration,
      sExpectedSalary,
      sNoticePeriod,
      bIsOpenToRelocation,
      bIsOpenToRemote,
      sCurrentCompany,
      sCurrentTitle,
      iCompanyId,
    });

    return apiHandler.sendSucess(res, result, "User registered successfully");
  } catch (err) {
    console.error(err);
    return apiHandler.sendError(
      res,
      null,
      err.message || "Registration failed",
    );
  }
};

export { login, register };
