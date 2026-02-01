
import fs from "fs";
import cloudinary from "../config/cloudinaryConfig.js";
export const uploadToCloudinary = async (filePath, folder = "uploads") => {
    try {
        const result = await cloudinary.uploader.upload(filePath, {
            folder,
            use_filename: true,
            unique_filename: false,
            timeout: 120000,
        });


        return result.secure_url;
    } catch (error) {
        console.error("❌ Cloudinary Upload Error:", error);
        throw new Error("Image upload failed");
    }
};
