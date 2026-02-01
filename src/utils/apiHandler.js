export const apiHandler = {
    // ✅ Use this when your request is successful 
    // Example: data fetched, record inserted, etc.
    sendSucess: (res, data, message) => {
        res.status(200).json({
            status: 200,
            success: true,
            data: data,
            message: message
        });
    },

    // ⚠️ Use this when the client sent a bad request
    // Example: validation failed, required field missing, invalid input format
    // 👉 If data is missing (e.g., required params not sent), use this
    sendError: (res, data, message) => {
        res.status(400).json({
            status: 400,
            success: false,
            data: data,
            message: message || 'Bad Request'
        });
    },

    // ❌ Use this when something unexpected failed on the server
    // Example: DB connection error, unhandled exception, runtime crash
    sendServerError: (res, data, error) => {
        res.status(500).json({
            status: 500,
            success: false,
            data: data,
            message: error.message || 'Internal Server Error'
        });
    },

    // 🔍 Use this when resource is not found
    // Example: No user found with given ID, no event found, empty DB record
    sendNotFound: (res, data, message) => {
        res.status(404).json({
            status: 404,
            success: false,
            data: data,
            message: message || 'Not Found'
        });
    },

    // 🔒 Use this when authentication or authorization fails
    // Example: Invalid token, user not logged in, no permission for action
    sendUnauthorizedError: (res, data, message) => {
        res.status(401).json({
            status: 401,
            success: false,
            data: data,
            message: message || 'Unauthorized'
        });
    }
};
