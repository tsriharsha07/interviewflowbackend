import jwt from 'jsonwebtoken'
import { apiHandler } from '../utils/index.js';

export const validateAccessToken = async (req, res, next) => {
    const authorizationHeader = req.headers.authorization;
    if (authorizationHeader) {
        const token = authorizationHeader.split(" ")[1]
        let data;
        try {
            data = jwt.verify(token, process.env.JWT_ACCESS_TOKEN_SECRET)


        } catch (error) {
            if (error.type === "expired" || error.type === "invalid") {
                return apiHandler.sendUnauthorizedError(
                    res,
                    null,
                    error.type === "expired" ? "Token expired" : "Invalid Token"
                );
            } else {
                return apiHandler.sendUnauthorizedError(res, null, "Authentication Error");
            }
        }


        req.auth = data
        next()
    }
    else {
        return apiHandler.sendUnauthorizedError(res, null, "Token is missing");
    }
}
// ES6 module syntax
export const authorizeRoles = (...allowedRoles) => {


    return (req, res, next) => {
        console.log(allowedRoles);

        if (!req.auth || !allowedRoles.includes(req.auth.role)) {
            return res.status(403).json({ message: 'Access denied: insufficient permissions.' });
        }
        next();
    };
};
