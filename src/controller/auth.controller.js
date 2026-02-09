import { comparePassword, executeQuery } from "../utils";
import { apiHandler } from "../utils/apiHandler";

const login = async (req, res, next) => {
  try {
    const { sEmail, sPassword } = req.body;
    if (!sEmail || !sPassword) {
      return apiHandler.sendError(res, null, "Missing Feilds!");
    }
    const checkEmailExists = await executeQuery(
      "SELECT sEmail,sPasswordHash FROM tblUsers where sEmail=@sEmail",
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
  } catch (error) {
    console.log("Error logging in", error);
    return apiHandler.sendError(res, null, "Erro occured during login!");
  }
};
