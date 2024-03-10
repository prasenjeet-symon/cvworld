import { Request, Response } from "express";
import { Logger, isDefined } from "../utils";
import fs from "fs";
import multer, { diskStorage } from "multer";

export class UserMediaController {
  private req: Request;
  private res: Response;
  public static profilePictureFolder = "public/profilePictures";

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Update user's profile picture
   */
  public async updateProfilePicture() {
    const validator = new UserMediaControllerValidators(this.req, this.res);
    if (!validator.validateUpdateProfilePicture()) {
      Logger.getInstance().logError("updateProfilePicture:: Error validating method updateProfilePicture");
      return;
    }

    const filePath = this.req.file?.destination.replace("public", "") + "/" + this.req.file?.filename;
    this.res.status(200).json({ message: filePath });
    Logger.getInstance().logSuccess("Profile picture updated");
    return;
  }

  /**
   *
   * Storage profile picture
   */
  public static profilePictureStorage() {
    const profilePictureUpload = diskStorage({
      destination: (req, file, cb) => {
        if (!fs.existsSync(UserMediaController.profilePictureFolder)) {
          fs.mkdirSync(UserMediaController.profilePictureFolder);
        }

        cb(null, UserMediaController.profilePictureFolder);
      },
      filename: (req, file, cb) => {
        cb(null, file.originalname);
      },
    });

    const profilePicture = multer({
      storage: profilePictureUpload,
      limits: { fileSize: 1048576 }, // No more than 1MB
      fileFilter: (req, file, cb) => {
        if (file.mimetype === "image/jpeg" || file.mimetype === "image/webp" || file.mimetype === "image/png" || file.mimetype === "application/octet-stream") {
          cb(null, true);
        }
      },
    });

    return profilePicture.single("profilePicture");
  }
}
/**
 *
 *
 * Validators
 */
class UserMediaControllerValidators {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate update profile picture
   */
  public validateUpdateProfilePicture() {
    const { file } = this.req;

    if (file === undefined) {
      this.res.status(400).json({ error: "file is required" });
      Logger.getInstance().logError("file is required");
      return false;
    }

    if (!isDefined(file)) {
      this.res.status(400).json({ error: "file is required" });
      Logger.getInstance().logError("file is required");
      return false;
    }

    return true;
  }
}
