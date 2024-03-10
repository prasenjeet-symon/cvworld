import { Request, Response } from "express";
import { Logger, PremiumTemplatePlan, PrismaClientSingleton, isDefined, isValidEmail, razorpayPrice, templatePlans } from "../utils";

export class SubscriptionPlanController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Create premium subscription plan
   */
  public static async createSubscriptionPlan() {
    if (!SubscriptionPlanControllerValidators.validateCreateSubscriptionPlan()) {
      Logger.getInstance().logError("createSubscriptionPlan:: Error validating method createSubscriptionPlan");
      return;
    }

    const { PLAN_NAME, PLAN_PRICE, PLAN_DESCRIPTION, PLAN_CURRENCY, RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL } = process.env;
    const price = razorpayPrice(+PLAN_PRICE!);
    const name = PLAN_NAME!.trim();
    const description = PLAN_DESCRIPTION!.trim();
    const currency = PLAN_CURRENCY!.trim();
    const adminEmail = ADMIN_EMAIL!.trim();

    const prisma = PrismaClientSingleton.prisma;
    const Razorpay = require("razorpay");
    const instance = new Razorpay({ key_id: RAZORPAY_KEY_ID, key_secret: RAZORPAY_KEY_SECRET });

    const fetchAllPlans = () => {
      return new Promise<templatePlans>((resolve, reject) => {
        instance.plans.all({}, function (error: any, plans: any) {
          if (error) {
            console.error(error);
          } else {
            resolve(plans);
          }
        });
      });
    };

    const createPlan = async () => {
      try {
        const plan = await instance.plans.create({
          period: "monthly",
          interval: 1,
          item: {
            name: name,
            amount: price,
            currency: currency,
            description: description,
          },
        });

        Logger.getInstance().logSuccess("createPlan:: Plan created successfully " + plan.id);
        return plan as PremiumTemplatePlan;
      } catch (error) {
        console.log(error);
        Logger.getInstance().logError("createPlan:: Error creating plan");
        return null;
      }
    };

    const allPlans = await fetchAllPlans();
    const activePlan = allPlans.items.find((p) => p.item.name.toLowerCase().trim() === name.toLowerCase().trim());

    let planId = null;
    if (!activePlan) {
      Logger.getInstance().logError("createSubscriptionPlan:: Subscription plan not found");
      const newPlan = await createPlan();
      planId = newPlan?.id;
    } else {
      Logger.getInstance().logSuccess("createSubscriptionPlan:: Subscription plan found with id: " + activePlan.id);
      planId = activePlan.id;
    }

    await prisma.admin.update({
      where: { email: adminEmail },
      data: {
        premiumTemplatePlans: {
          upsert: {
            create: {
              currency: currency,
              description: description,
              interval: 1,
              name: name,
              period: "MONTHLY",
              price: price,
              planID: planId || "",
            },
            update: {
              currency: currency,
              description: description,
              interval: 1,
              name: name,
              period: "MONTHLY",
              price: price,
              planID: planId || "",
            },
          },
        },
      },
    });

    Logger.getInstance().logSuccess("createSubscriptionPlan:: createSubscriptionPlan success");
    return;
  }

  /**
   *
   * Get subscription plan of application
   */
  public async getSubscriptionPlan() {
    const validator = new SubscriptionPlanControllerValidators(this.req, this.res);
    if (!validator.validateGetSubscriptionPlan()) {
      Logger.getInstance().logError("getSubscriptionPlan:: Error validating method getSubscriptionPlan");
      return;
    }

    const prisma = PrismaClientSingleton.prisma;

    const subscriptionPlan = await prisma.premiumTemplatePlans.findFirst();

    if (!subscriptionPlan) {
      this.res.status(404).json({ error: "Subscription plan not found" });
      Logger.getInstance().logError("getSubscriptionPlan:: Subscription plan not found");
      return;
    }

    this.res.status(200).json(subscriptionPlan);
    Logger.getInstance().logSuccess("getSubscriptionPlan:: getSubscriptionPlan success");
    return;
  }
}

/**
 *
 * Validator
 */
class SubscriptionPlanControllerValidators {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate create subscription plan
   */
  public static validateCreateSubscriptionPlan() {
    const { PLAN_NAME, PLAN_PRICE, PLAN_DESCRIPTION, PLAN_CURRENCY, RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL } = process.env;

    if (
      PLAN_NAME === undefined ||
      PLAN_PRICE === undefined ||
      PLAN_DESCRIPTION === undefined ||
      PLAN_CURRENCY === undefined ||
      RAZORPAY_KEY_ID === undefined ||
      RAZORPAY_KEY_SECRET === undefined ||
      ADMIN_EMAIL === undefined
    ) {
      Logger.getInstance().logError("PLAN_NAME, PLAN_PRICE, PLAN_DESCRIPTION, PLAN_CURRENCY, RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are not defined. Please set them in .env file");
      return false;
    }

    if (
      !isDefined(PLAN_NAME) ||
      !isDefined(PLAN_PRICE) ||
      !isDefined(PLAN_DESCRIPTION) ||
      !isDefined(PLAN_CURRENCY) ||
      !isDefined(RAZORPAY_KEY_ID) ||
      !isDefined(RAZORPAY_KEY_SECRET) ||
      !isDefined(ADMIN_EMAIL)
    ) {
      Logger.getInstance().logError("PLAN_NAME, PLAN_PRICE, PLAN_DESCRIPTION, PLAN_CURRENCY, RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, ADMIN_EMAIL are not defined. Please set them in .env file");
      return false;
    }

    if (!isValidEmail(ADMIN_EMAIL)) {
      Logger.getInstance().logError("ADMIN_EMAIL is not a valid email");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate get subscription plan
   */
  public validateGetSubscriptionPlan() {
    return true;
  }
}
