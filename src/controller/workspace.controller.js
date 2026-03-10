import {
  executeQuery,
  executeStoredProcedure,
  apiHandler,
} from "../utils/index.js";

export const getWorkSpaces = (req, res, next) => {
  try {
    const { iUserId } = req.user;
  } catch (error) {
    console.log("Error fetching workspcaes", error);
    apiHandler.sendServerError(res, {}, error.message);
  }
};
