import {
  createAccessToken,
  createRefreshToken,
  transformPermissions,
} from "../middlewares/auth.js";
import {
  comparePassword,
  executeQuery,
  executeStoredProcedure,
  hashPassword,
  apiHandler,
} from "../utils/index.js";

const login = async (req, res, next) => {
  try {
    const { sEmail, sPassword } = req.body;
    if (!sEmail || !sPassword) {
      return apiHandler.sendError(res, null, "Missing Feilds!");
    }
    const checkEmailExists = await executeQuery(
      "SELECT iId,sEmail,sPasswordHash FROM tblUsers where sEmail=@sEmail",
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

    const accessToken = createAccessToken({
      iUserId: userData[0].iUserId,
    });

    const refreshToken = await createRefreshToken({
      iUserId: userData[0].iUserId,
    });
    return apiHandler.sendSucess(
      res,
      {
        userData,
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
      sEmail,
      sPassword,
      sFullName,
    } = req.body;

    if (!sEmail || !sPassword || !sFullName) {
      return apiHandler.sendError(res, null, "Missing required fields");
    }

    const passwordHash = await hashPassword(sPassword);

    const result = await executeStoredProcedure("uspRegisterUser", {
      sEmail,
      sPasswordHash: passwordHash,
      sFullName,
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
