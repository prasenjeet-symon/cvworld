import { Request, Response } from "express";
import fs from "fs";
import multer, { diskStorage } from "multer";
import { Logger, PrismaClientSingleton, isBoolean, isDefined, isValidEmail, isValidStringLength, isValidUUID } from "../utils";

export class FeedbackFormController {
  private req: Request;
  private res: Response;
  public static attachmentFolder = "public/feedback";

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }
  /**
   *
   * Upload feedback attachment
   */
  public async uploadFeedbackAttachment() {
    const validator = new FeedbackFormValidator(this.req, this.res);
    if (!validator.validateUploadFeedbackAttachment()) {
      Logger.getInstance().logError("Feedback form validation failed");
      return;
    }

    const filePath = this.req.file?.destination.replace("public", "") + "/" + this.req.file?.filename;
    this.res.status(200).json({ message: filePath });
    Logger.getInstance().logSuccess("Feedback form attachment uploaded");
    return;
  }

  /**
   *
   * Attachment storage
   */
  public static attachmentStorage() {
    const feedbackAttachmentUpload = diskStorage({
      destination: (req, file, cb) => {
        if (!fs.existsSync(FeedbackFormController.attachmentFolder)) {
          fs.mkdirSync(FeedbackFormController.attachmentFolder);
        }

        cb(null, FeedbackFormController.attachmentFolder);
      },
      filename: (req, file, cb) => {
        cb(null, file.originalname);
      },
    });

    const feedbackUpload = multer({
      storage: feedbackAttachmentUpload,
      limits: { fileSize: 1048576 }, // No more than 1MB
      fileFilter: (req, file, cb) => {
        if (file.mimetype === "image/jpeg" || file.mimetype === "image/webp" || file.mimetype === "image/png" || file.mimetype === "application/octet-stream") {
          cb(null, true);
        }
      },
    });

    return feedbackUpload.single("feedbackFile");
  }
  /**
   *
   * Add new feedback to the application
   */
  public async addFeedback() {
    const validator = new FeedbackFormValidator(this.req, this.res);
    if (!validator.validateAddFeedback()) {
      Logger.getInstance().logError("Feedback form validation failed");
      return;
    }

    const prisma = PrismaClientSingleton.prisma;

    await prisma.feedback.upsert({
      where: { identifier: this.req.body.identifier },
      create: {
        department: this.req.body.department,
        description: this.req.body.description,
        email: this.req.body.email,
        identifier: this.req.body.identifier,
        isRegistered: this.req.body.isRegistered,
        name: this.req.body.name,
        title: this.req.body.title,
        attachment: this.req.body.attachment || null,
      },
      update: {
        department: this.req.body.department,
        description: this.req.body.description,
        email: this.req.body.email,
        isRegistered: this.req.body.isRegistered,
        name: this.req.body.name,
        title: this.req.body.title,
        attachment: this.req.body.attachment || null,
      },
    });

    // TODO: Send email to admin about new feedback

    this.res.status(200).json({ message: "Feedback submitted" });
    Logger.getInstance().logSuccess("Feedback submitted");
    return;
  }

  /**
   *
   * Get all feedback of the application
   */
  public async getAllFeedback() {
    const controller = new FeedbackFormValidator(this.req, this.res);
    if (!controller.validateGetAllFeedback()) {
      Logger.getInstance().logError("Feedback form's getAllFeedback validation failed");
      return;
    }

    const prisma = PrismaClientSingleton.prisma;
    const adminEmail = this.res.locals.email;

    const allFeedbacks = await prisma.feedback.findMany();

    this.res.status(200).json({ allFeedbacks });
    Logger.getInstance().logSuccess("Feedback's getAllFeedback completed");
    return;
  }

  /**
   *
   * Delete a feedback
   */
  public async deleteFeedback() {
    const controller = new FeedbackFormValidator(this.req, this.res);
    if (!controller.validateDeleteFeedback()) {
      Logger.getInstance().logError("Feedback form's deleteFeedback validation failed");
      return;
    }

    const prisma = PrismaClientSingleton.prisma;

    await prisma.feedback.delete({
      where: { identifier: this.req.body.identifier },
    });

    this.res.status(200).json({ message: "Feedback deleted" });
    Logger.getInstance().logSuccess("Feedback deleted");
    return;
  }
}
/**
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 * Feedback form validator
 */
class FeedbackFormValidator {
  constructor(private req: Request, private res: Response) {}
  /**
   *
   * Validate addFeedback
   */
  public validateAddFeedback() {
    const { department, description, email, identifier, isRegistered, name, title, attachment } = this.req.body;

    if (department === undefined || description === undefined || email === undefined || identifier === undefined || isRegistered === undefined || name === undefined || title === undefined) {
      this.res.status(400).json({ error: "department, description, email, identifier, isRegistered, name, title are required" });
      Logger.getInstance().logError("department, description, email, identifier, isRegistered, name, title are required");
      return false;
    }

    if (!isDefined(department) || !isDefined(description) || !isDefined(email) || !isDefined(identifier) || !isDefined(isRegistered) || !isDefined(name) || !isDefined(title)) {
      this.res.status(400).json({ error: "department, description, email, identifier, isRegistered, name, title are required" });
      Logger.getInstance().logError("department, description, email, identifier, isRegistered, name, title are required");
      return false;
    }

    if (!isValidEmail(email)) {
      this.res.status(400).json({ error: "Invalid email" });
      Logger.getInstance().logError("Invalid email");
      return false;
    }

    if (!isValidUUID(identifier)) {
      this.res.status(400).json({ error: "Invalid identifier" });
      Logger.getInstance().logError("Invalid identifier");
      return false;
    }

    if (!isValidStringLength(department, 1, 500)) {
      this.res.status(400).json({ error: "department characters length must be between 1 and 500" });
      Logger.getInstance().logError("department characters length must be between 1 and 500");
      return false;
    }

    if (!isValidStringLength(description, 1, 5000)) {
      this.res.status(400).json({ error: "description characters length must be between 1 and 5000" });
      Logger.getInstance().logError("description characters length must be between 1 and 5000");
      return false;
    }

    if (!isValidStringLength(name, 1, 500)) {
      this.res.status(400).json({ error: "name characters length must be between 1 and 500" });
      Logger.getInstance().logError("name characters length must be between 1 and 500");
      return false;
    }

    if (!isValidStringLength(title, 1, 1500)) {
      this.res.status(400).json({ error: "title characters length must be between 1 and 1500" });
      Logger.getInstance().logError("title characters length must be between 1 and 1500");
      return false;
    }

    if (!isBoolean(isRegistered)) {
      this.res.status(400).json({ error: "isRegistered must be boolean" });
      Logger.getInstance().logError("isRegistered must be boolean");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate getAllFeedback
   */
  public validateGetAllFeedback() {
    return true;
  }

  /**
   *
   * Validate deleteFeedback
   */
  public validateDeleteFeedback() {
    const { identifier } = this.req.body;

    if (identifier === undefined) {
      this.res.status(400).json({ error: "identifier is required" });
      Logger.getInstance().logError("identifier is required");
      return false;
    }

    if (!isDefined(identifier)) {
      this.res.status(400).json({ error: "identifier is required" });
      Logger.getInstance().logError("identifier is required");
      return false;
    }

    if (!isValidUUID(identifier)) {
      this.res.status(400).json({ error: "Invalid identifier" });
      Logger.getInstance().logError("Invalid identifier");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate attachFile
   */
  public validateAttachmentStorage() {
    return true;
  }

  /**
   *
   * validateUploadFeedbackAttachment
   */
  public validateUploadFeedbackAttachment() {
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
