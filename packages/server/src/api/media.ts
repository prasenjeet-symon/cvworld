import express from "express";
import multer, { diskStorage } from "multer";
import { PrismaClientSingleton } from "../utils";

const profilePictureUpload = diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/profilePictures");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const profileUpload = multer({
  storage: profilePictureUpload,
  limits: { fileSize: 10000000 },
  fileFilter: (req, file, cb) => {
    if (file.mimetype === "image/jpeg" || file.mimetype === "image/png") {
      cb(null, true);
    }
  },
});

const router = express.Router();

/**
 * Handles the HTTP POST request to update the user profile picture.
 *
 * @param {Object} req - The request object.
 * @param {Object} res - The response object.
 * @return {Promise<void>} - A promise that resolves when the request is handled.
 */
router.post("/update_user_profile_picture", profileUpload.single("profilePicture"), async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("file" in req && req.file) {
    const filePath = req.file.destination.replace("public", "") + req.file.filename;
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        profilePicture: filePath,
      },
    });

    res.json(req.body);
    return;
  } else {
    res.status(500).json({ message: "file field is missing" });
    return;
  }
});

export default router;
