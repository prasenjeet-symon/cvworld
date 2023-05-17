import express from "express";
import { resumeUploadStorage, uploadResume } from "../utils";
const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

/** Upload the resume */
router.post("/upload", resumeUploadStorage().single("image"), async (req, res) => {
  await uploadResume(req, res);
});

export default router;
