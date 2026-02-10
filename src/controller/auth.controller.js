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

const register = async (req, res, next) => {
  try {
    const { sName, sEmail, sPassword, sPhone, iRoleId } = req.body;
    const existingUser = await executeQuery(
      "SELECT 1 FROM tblUsers WHERE sEmail=@sEmail",
      { sEmail },
    );

    if (existingUser.length) {
      return apiHandler.sendError(res, null, "Email already registered");
    }

    if (!sName || !sEmail || !sPassword || !sPhone || !iRoleId) {
      return apiHandler.sendServerError(res, null, "Missing Fields!");
    }
    const password = await hashPassword(sPassword);
    const registerUser = await executeStoredProcedure("uspRegisterUser", {
      sName,
      sEmail,
      sPasswordHash: password,
      sPhone,
      iRoleId,
    });

    return apiHandler.sendSucess(res, null, "User Registered successfully!");
  } catch (error) {
    console.log("Error logging in", error);
    return apiHandler.sendError(res, null, "Error occured during login!");
  }
};

export { login, register };
