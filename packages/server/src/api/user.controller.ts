import { Request, Response } from "express";
import { PrismaClientSingleton } from "../utils";
import { v4 } from "uuid";

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
    const userId = this.res.locals.userId;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: { email: email },
      data: {
        email: `deleted__${v4()}`,
        reference: `deleted__${userId}`,
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
