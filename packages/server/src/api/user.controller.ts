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
   * Get user's all favorite templates
   */
  public async getFavoriteTemplates() {
    if (!this.validateGetFavoriteTemplates()) {
      Logger.getInstance().logError("getFavoriteTemplates:: Error validating method getFavoriteTemplates");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const userWithFavoriteTemplates = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        favouriteTemplates: true,
      },
    });

    if (!userWithFavoriteTemplates) {
      this.res.status(404).json({ error: "user not found" });
      Logger.getInstance().logError("getFavoriteTemplates:: user not found");
      return;
    }

    if (userWithFavoriteTemplates.favouriteTemplates.length === 0) {
      this.res.status(404).json({ error: "favourite templates not found" });
      Logger.getInstance().logError("getFavoriteTemplates:: favourite templates not found");
      return;
    }

    const favouriteTemplates = userWithFavoriteTemplates.favouriteTemplates;

    this.res.status(200).json(favouriteTemplates);
    Logger.getInstance().logSuccess("getFavoriteTemplates:: getFavoriteTemplates success");
    return;
  }

  /**
   *
   * Get user's subscription
   */
  public async getSubscription() {
    if (!this.validateGetSubscription()) {
      Logger.getInstance().logError("getSubscription:: Error validating method getSubscription");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const userWithSubscription = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        subscription: true,
      },
    });

    if (!userWithSubscription) {
      this.res.status(404).json({ message: "user not found" });
      Logger.getInstance().logError("getSubscription:: user not found");
      return;
    }

    if (!userWithSubscription.subscription) {
      this.res.status(404).json({ message: "Subscription not found" });
      Logger.getInstance().logError("getSubscription:: Subscription not found");
      return;
    }

    const subscription = userWithSubscription.subscription;

    this.res.json(subscription);
    Logger.getInstance().logSuccess("getSubscription:: getSubscription success");
    return;
  }

  /**
   *
   * Get all user's transaction ( of bought templates )
   */
  public async getTransactions() {
    if (!this.validateGetTransactions()) {
      Logger.getInstance().logError("getTransactions:: Error validating method getTransactions");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const userWithTemplateBoughtWithTransaction = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        boughtTemplate: {
          include: {
            transaction: true,
          },
        },
      },
    });

    if (!userWithTemplateBoughtWithTransaction) {
      this.res.status(404).json({ message: "user not found" });
      Logger.getInstance().logError("getTransactions:: user not found");
      return;
    }

    if (!userWithTemplateBoughtWithTransaction.boughtTemplate) {
      this.res.status(404).json({ message: "user not found" });
      Logger.getInstance().logError("getTransactions:: user not found");
      return;
    }

    if (userWithTemplateBoughtWithTransaction.boughtTemplate.length === 0) {
      this.res.status(404).json({ message: "Empty transactions" });
      Logger.getInstance().logError("getTransactions:: Empty transactions");
      return;
    }

    const transactions = userWithTemplateBoughtWithTransaction.boughtTemplate.map((val) => {
      return {
        ...val.transaction,
        templateName: val.name,
        templatePrice: val.price,
      };
    });

    this.res.status(200).json(transactions);
    Logger.getInstance().logSuccess("getTransactions:: Get transactions successfully");
    return;
  }

  /**
   *
   * Get user
   */
  public async getUser() {
    if (!this.validateGetUser()) {
      Logger.getInstance().logError("getUser:: Error validating method getUser");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const user = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        email: true,
        fullName: true,
        profilePicture: true,
        timeZone: true,
        reference: true,
        userName: true,
        isEmailVerified: true,
        isDeleted: true,
      },
    });

    this.res.status(200).json(user);
    Logger.getInstance().logSuccess("getUser:: Get user successfully");
    return;
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

  /**
   *
   * Validate get user
   */
  public validateGetUser() {
    return true;
  }

  /**
   *
   * Validate get transactions
   */
  public validateGetTransactions() {
    return true;
  }

  /**
   *
   * Validate get subscription
   */
  public validateGetSubscription() {
    return true;
  }

  /**
   *
   * Validate get favorite templates
   */
  public validateGetFavoriteTemplates() {
    return true;
  }
}
