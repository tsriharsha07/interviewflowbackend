import { apiHandler } from "../utils/apiHandler";

const login = async (req, res, next) => {
  try {
    const { sEmail, sPassword } = req.body;
    if (!sEmail || !sPassword) {
      return apiHandler.sendError(res, null, "Missing Feilds!");
    }
  } catch (error) {
    console.log("Error logging in", error);
    return apiHandler.sendError(res, null, "Erro occured during login!");
  }
};
