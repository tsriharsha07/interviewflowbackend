
import express from 'express'
import multer from 'multer';
import path from 'path';


// Storage config (store locally for demo)
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/"); // make sure uploads/ exists
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage });

export { upload }
