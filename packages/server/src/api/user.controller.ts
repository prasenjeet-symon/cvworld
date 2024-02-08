import { Request, Response } from "express";
import { PrismaClientSingleton } from "../utils";

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
      console.log("Delete validation failed");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: { email: email },
      data: {
        isDeleted: true,
      },
    });

    this.res.status(200).json({ message: "Success" });
    console.log("User deleted");
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
