import { Request, Response } from "express";
import { v4 } from "uuid";
import { Logger, PrismaClientSingleton } from "../utils";

export class UserController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Delete a user
   */
  public async delete() {
    if (!this.validateDelete()) {
      Logger.getInstance().logError("delete:: Error validating method delete");
      return;
    }

    const { email, userId } = this.res.locals;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: { email: email },
      data: {
        email: `deleted__${v4()}`,
        reference: `deleted__${userId}`,
        isDeleted: true,
      },
    });

    this.res.status(200).json({ message: "Deleted user successfully" });
    Logger.getInstance().logSuccess("delete:: Deleted user successfully");
    return;
  }

  /**
   *
   * Validate delete method
   */
  private validateDelete() {
    return true;
  }
}
