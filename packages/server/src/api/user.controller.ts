import { addMonths } from "date-fns";
import { Request, Response } from "express";
import { v4 } from "uuid";
import { Logger, PrismaClientSingleton, isDefined, isValidEmail } from "../utils";

export class UserController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }
  /**
   *
   * Cancel subscription
   */
  public async cancelSubscription() {
    if (!this.validateCancelSubscription()) {
      Logger.getInstance().logError("cancelSubscription:: Error validating method cancelSubscription");
      return;
    }

    const email = this.res.locals.email;
    const { RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET } = process.env;
    const prisma = PrismaClientSingleton.prisma;
    const Razorpay = require("razorpay");
    const instance = new Razorpay({ key_id: RAZORPAY_KEY_ID, key_secret: RAZORPAY_KEY_SECRET });

    const userWithSubscription = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        subscription: true,
      },
    });

    if(!userWithSubscription) {
      this.res.status(404).json({ error: "user not found" });
      Logger.getInstance().logError("cancelSubscription:: user not found");
      return;
    }

    if(!userWithSubscription.subscription) {
      this.res.status(404).json({ error: "subscription not found" });
      Logger.getInstance().logError("cancelSubscription:: subscription not found");
      return;
    }

    const subscriptionID = userWithSubscription.subscription.subscriptionID;
    try {
      await instance.subscriptions.cancel(subscriptionID);
    } catch (error) {
       console.error(error);
    }

    Logger.getInstance().logSuccess("cancelSubscription:: subscription cancelled");
    return;
  }

  /**
   *
   * Update user
   */
  public async updateUser() {
    if (!this.validateUpdateUser()) {
      Logger.getInstance().logError("updateUser:: Error validating method updateUser");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;
    const { profilePicture, fullName, userName } = this.req.body;

    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        profilePicture: profilePicture,
        fullName: fullName,
        userName: userName,
      },
    });

    this.res.status(200).json({ message: "user updated successfully" });
    Logger.getInstance().logSuccess("updateUser:: user updated successfully");
    return;
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

    // create subscription
    await this.createSubscription();

    const userWithSubscription = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        subscription: true,
      },
    });

    if (!userWithSubscription) {
      this.res.status(404).json({ error: "user not found" });
      Logger.getInstance().logError("getSubscription:: user not found");
      return;
    }

    if (!userWithSubscription.subscription) {
      this.res.status(404).json({ error: "Subscription not found" });
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
   * Create user's subscription
   */
  private async createSubscription() {
    if (!this.validateCreateSubscription()) {
      Logger.getInstance().logError("createSubscription:: Error validating method createSubscription");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;
    const { RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL } = process.env;
    const adminEmail = ADMIN_EMAIL!.trim();
    const Razorpay = require("razorpay");
    const instance = new Razorpay({ key_id: RAZORPAY_KEY_ID, key_secret: RAZORPAY_KEY_SECRET });

    const adminWithSubscriptionPlan = await prisma.admin.findUnique({
      where: { email: adminEmail },
      include: {
        premiumTemplatePlans: true,
      },
    });

    if (!adminWithSubscriptionPlan) {
      this.res.status(404).json({ error: "admin not found" });
      Logger.getInstance().logError("createSubscription:: admin not found");
      return;
    }

    if (!adminWithSubscriptionPlan.premiumTemplatePlans) {
      this.res.status(404).json({ error: "subscription plan not found" });
      Logger.getInstance().logError("createSubscription:: subscription plan not found");
      return;
    }

    const subscriptionPlan = adminWithSubscriptionPlan.premiumTemplatePlans;

    // If subscription plan of user already exit then return that url
    const userWithSubscription = await prisma.user.findUnique({
      where: {
        email: email,
      },
      include: {
        subscription: true,
      },
    });

    if (userWithSubscription && userWithSubscription.subscription) {
      Logger.getInstance().logSuccess("createSubscription:: createSubscription success");
      return userWithSubscription.subscription.subscriptionLink;
    }

    const createSubscription = async () => {
      const subscription = await instance.subscriptions.create({
        plan_id: subscriptionPlan.planID,
        customer_notify: 1,
        quantity: 1,
        total_count: 12,
        notes: {
          email: email,
          planId: subscriptionPlan.planID,
          planName: subscriptionPlan.name,
        },
      });

      return subscription;
    };

    const subscription = await createSubscription();
    const { id, short_url } = subscription as { id: string; short_url: string };

    await prisma.user.update({
      where: { email: email },
      data: {
        subscription: {
          upsert: {
            create: {
              activatedOn: new Date(),
              basePrice: subscriptionPlan.price,
              cycle: subscriptionPlan.period,
              discount: 0,
              expireOn: addMonths(new Date(), 1),
              isActive: false,
              planName: subscriptionPlan.name,
              subscriptionID: id,
              subscriptionLink: short_url,
            },
            update: {
              activatedOn: new Date(),
              basePrice: subscriptionPlan.price,
              cycle: subscriptionPlan.period,
              discount: 0,
              expireOn: addMonths(new Date(), 1),
              isActive: false,
              planName: subscriptionPlan.name,
              subscriptionID: id,
              subscriptionLink: short_url,
            },
          },
        },
      },
    });

    Logger.getInstance().logSuccess("createSubscription:: createSubscription success");
    return short_url;
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
      this.res.status(404).json({ error: "user not found" });
      Logger.getInstance().logError("getTransactions:: user not found");
      return;
    }

    if (!userWithTemplateBoughtWithTransaction.boughtTemplate) {
      this.res.status(404).json({ error: "user not found" });
      Logger.getInstance().logError("getTransactions:: user not found");
      return;
    }

    if (userWithTemplateBoughtWithTransaction.boughtTemplate.length === 0) {
      this.res.status(404).json({ error: "Empty transactions" });
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

  /**
   *
   * Validate update user
   */
  public validateUpdateUser() {
    const { profilePicture, fullName, userName } = this.req.body;

    if (profilePicture === undefined || fullName === undefined || userName === undefined) {
      this.res.status(400).json({ error: "profilePicture, fullName, userName are required fields" });
      Logger.getInstance().logError("validateUpdateUser:: profilePicture, fullName, userName are required fields");
      return false;
    }

    if (!isDefined(profilePicture) || !isDefined(fullName) || !isDefined(userName)) {
      this.res.status(400).json({ error: "profilePicture, fullName, userName are required fields" });
      Logger.getInstance().logError("validateUpdateUser:: profilePicture, fullName, userName are required fields");
      return false;
    }

    return true;
  }

  /**
   *
   * validateCreateSubscription
   */
  public validateCreateSubscription() {
    const { RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL } = process.env;

    if (RAZORPAY_KEY_ID === undefined || RAZORPAY_KEY_SECRET === undefined || ADMIN_EMAIL === undefined) {
      this.res.status(400).json({ error: "RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are required" });
      Logger.getInstance().logError("validateCreateSubscription:: RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are not defined. Please set them in .env file");
      return false;
    }

    if (!isDefined(RAZORPAY_KEY_ID) || !isDefined(RAZORPAY_KEY_SECRET) || !isDefined(ADMIN_EMAIL)) {
      this.res.status(400).json({ error: "RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are required" });
      Logger.getInstance().logError("validateCreateSubscription:: RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are not defined. Please set them in .env file");
      return false;
    }

    if (!isValidEmail(ADMIN_EMAIL)) {
      this.res.status(400).json({ error: "ADMIN_EMAIL is not a valid email" });
      Logger.getInstance().logError("validateCreateSubscription:: ADMIN_EMAIL is not a valid email");
      return false;
    }

    return true;
  }

  /** 
   * 
   * validateCancelSubscription
   */
  public validateCancelSubscription() {
    const { RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET } = process.env;

    if (RAZORPAY_KEY_ID === undefined || RAZORPAY_KEY_SECRET === undefined) {
      this.res.status(400).json({ error: "RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET are required" });
      Logger.getInstance().logError("validateCancelSubscription:: RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET are not defined. Please set them in .env file");
      return false;
    }

    if (!isDefined(RAZORPAY_KEY_ID) || !isDefined(RAZORPAY_KEY_SECRET)) {
      this.res.status(400).json({ error: "RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET are required" });
      Logger.getInstance().logError("validateCancelSubscription:: RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET are not defined. Please set them in .env file");
      return false;
    }

    return true;
  }
}
