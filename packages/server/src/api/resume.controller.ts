import { Request, Response } from "express";
import { Logger, PrismaClientSingleton } from "../utils";

export class ResumeController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Get all the resume of user
   */
  public async getAllResume() {
    const validator = new ResumeControllerValidators(this.req, this.res);
    if (!validator.validateGetAllResume()) {
      Logger.getInstance().logError("getAllResume:: Error validating method getAllResume");
      return;
    }

    const prisma = PrismaClientSingleton.prisma;
    
    
  }
}

/**
 *
 * Validators
 */
class ResumeControllerValidators {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate getAllResume
   */
  public validateGetAllResume() {
    return true;
  }
}
