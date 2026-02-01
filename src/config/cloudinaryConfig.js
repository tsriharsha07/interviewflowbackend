// config/cloudinaryConfig.mjs
import { v2 as cloudinary } from 'cloudinary';
import dotenv from 'dotenv';

dotenv.config();
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME || "dpcbza6dm",
    api_key: process.env.CLOUDINARY_API_KEY || "733767349834179",
    api_secret: process.env.CLOUDINARY_API_SECRET || "t2X-5lO4E59ToD33CujqQxxoEWQ",
    secure: true,
});


export default cloudinary;
