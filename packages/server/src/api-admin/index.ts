import express from "express";
import { PremiumTemplatePlan, PrismaClientSingleton, addTemplate, hashPassword } from "../utils";

const router = express.Router();

/**
 *
 * Add new template to the market place
 */
router.post("/add_template", async (req, res) => {
  if (!("name" in req.body)) {
    res.status(400).json({ message: "name field is missing" });
    return;
  }

  if (!("price" in req.body)) {
    res.status(400).json({ message: "price field is missing" });
    return;
  }

  const email = res.locals.email;
  const name = req.body.name;
  const price = +req.body.price; // in paisa

  const imageUrl = await addTemplate(name, price);

  res.json({ imageUrl: imageUrl, price: price });
});

/**
 * Get all the registered users
 */
router.get("/users", async (req, res) => {
  const users = await PrismaClientSingleton.prisma.user.findMany({
    include: {
      subscription: true,
      boughtTemplate: true,
    },
    where: {
      isDeleted: false,
    },
  });

  res.json(users);
});

// reset the password of the user
router.post("/reset_password", async (req, res) => {
  // should have email and password of the user
  if (!("email" in req.body && "password" in req.body)) {
    res.status(400).json({ message: "All fields are required" });
    return;
  }

  const email = req.body.email;
  const password = req.body.password;

  const user = await PrismaClientSingleton.prisma.admin.findUnique({
    where: {
      email: email,
    },
  });

  if (!user) {
    res.status(404).json({ message: "User not found" });
    return;
  }

  await PrismaClientSingleton.prisma.admin.update({
    where: {
      email: email,
    },
    data: {
      password: hashPassword(password),
    },
  });

  res.json({ message: "Password updated successfully" });
});

/**
 * Get all the contact us messages that is not resolved
 */
router.get("/contact_us", async (req, res) => {
  const messages = await PrismaClientSingleton.prisma.contactUs.findMany({
    where: {
      isResolved: false,
    },
  });

  res.json(messages);
});

/**
 * Mark the contact us message as resolved
 * */
router.post("/contact_us_resolved", async (req, res) => {
  // should have message id
  if (!("id" in req.body)) {
    res.status(400).json({ message: "id field is missing" });
    return;
  }

  const id = req.body.id;
  const message = await PrismaClientSingleton.prisma.contactUs.update({
    where: {
      id: id,
    },
    data: {
      isResolved: true,
    },
    select: {
      isResolved: true,
      id: true,
    },
  });

  res.json(message);
});

/**
 *
 * Update the subscription of the plan
 *
 */
router.post("/update_template_plan", async (req, res) => {
  if (!("planID" in req.body && "name" in req.body && "description" in req.body && "price" in req.body)) {
    res.status(400).json({ message: "All fields are required" });
    return;
  }

  const Razorpay = require("razorpay");
  const razorpayKeyID = process.env.RAZORPAY_KEY_ID;
  const razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET;
  const instance = new Razorpay({ key_id: razorpayKeyID, key_secret: razorpayKeySecret });

  const email = res.locals.email; // admin email
  const planID = req.body.planID;
  const name = req.body.name;
  const description = req.body.description;
  const price = +req.body.price; // in paisa

  // we need to create new razorpay plan
  const createdPlan = (await instance.plans.create({
    period: "monthly",
    interval: 1,
    item: {
      name: name,
      amount: price,
      currency: "INR",
      description: description,
    },
  })) as PremiumTemplatePlan;

  // update the plan
  await PrismaClientSingleton.prisma.premiumTemplatePlans.update({
    where: {
      planID,
    },
    data: {
      price: price,
      description: description,
      name: name,
      planID: createdPlan.id,
      updatedAt: new Date(),
    },
  });

  // fetch all the user having the subscriptions and update the subscription
  const usersWithSubscription = await PrismaClientSingleton.prisma.user.findMany({
    where: {
      subscription: {
        isActive: true,
      },
    },
    select: {
      subscription: true,
      email: true,
      reference: true,
    },
  });

  // update every user razorpay plan
  await Promise.all(
    usersWithSubscription.map(async (user) => {
      await instance.subscriptions.update(user.subscription?.subscriptionID, {
        plan_id: createdPlan.id,
        customer_notify: 1,
      });
    })
  );

  await Promise.all(
    usersWithSubscription.map(async (user) => {
      await PrismaClientSingleton.prisma.user.update({
        where: {
          reference: user.reference,
        },
        data: {
          subscription: {
            update: {
              basePrice: price,
              planName: name,
              updatedAt: new Date(),
            },
          },
        },
      });
    })
  );

  res.json({ message: "Plan updated successfully" });
});

/**
 *
 * Get all the premium template plans
 *
 */
router.get("/premium_template_plans", async (req, res) => {
  const plans = await PrismaClientSingleton.prisma.premiumTemplatePlans.findMany();
  res.json(plans);
});

/**
 * Get all the bought premium template of the user
 *
 */
router.post("/bought_templates", async (req, res) => {
  // should have user reference
  if (!("reference" in req.body)) {
    res.status(400).json({ message: "reference field is missing" });
    return;
  }

  const reference = req.body.reference;

  const user = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      reference: reference,
    },
    select: {
      boughtTemplate: true,
    },
  });

  // only get the bought template
  res.json(user?.boughtTemplate ? user?.boughtTemplate : []);
});

/**
 *
 * Generated resumes by user
 *
 */
router.post("/generated_resumes", async (req, res) => {
  // user reference
  if (!("reference" in req.body)) {
    res.status(400).json({ message: "reference field is missing" });
    return;
  }

  const reference = req.body.reference;

  const user = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      reference: reference,
    },
    select: {
      resumes: true,
    },
  });

  // only get the resumes
  res.json(user?.resumes ? user?.resumes : []);
});

/**
 *
 * Bought templates transactions
 *
 */
router.post("/bought_templates_transactions", async (req, res) => {
  // should have user reference
  if (!("reference" in req.body)) {
    res.status(400).json({ message: "reference field is missing" });
    return;
  }

  const reference = req.body.reference;
  const boughtTemplatesTransactions = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      reference: reference,
    },
    select: {
      boughtTemplate: {
        select: {
          transaction: true,
        },
      },
    },
  });

  const onlyTransactions = boughtTemplatesTransactions ? boughtTemplatesTransactions.boughtTemplate.map((item) => item.transaction).filter((item) => item) : [];
  res.json(onlyTransactions);
});

/**
 *
 * Subscription transactions of the user
 *
 */
router.post("/subscription_transactions", async (req, res) => {
  // should have user reference
  if (!("reference" in req.body)) {
    res.status(400).json({ message: "reference field is missing" });
    return;
  }

  const reference = req.body.reference;

  const user = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      reference: reference,
    },
    select: {
      subscription: {
        select: {
          transaction: true,
        },
      },
    },
  });

  const onlyTransactions = user ? user.subscription?.transaction.map((item) => item) : [];
  res.json(onlyTransactions);
});

/**
 *
 * Get the single user given the reference
 *
 */
router.post("/single_user", async (req, res) => {
  // reference is required
  if (!("reference" in req.body)) {
    res.status(400).json({ message: "reference field is missing" });
    return;
  }

  const reference = req.body.reference;

  const user = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      reference: reference,
    },
    include: {
      subscription: true,
      boughtTemplate: true,
    },
  });

  // return the sigle user
  res.json(user);
});

/**
 *
 * Get all the marketplace templates
 *
 */
router.get("/marketplace_templates", async (req, res) => {
  const templates = await PrismaClientSingleton.prisma.resumeTemplateMarketplace.findMany();
  res.json(templates);
});

/**
 *
 * Update the marketplace template
 *
 */
router.post("/update_marketplace_template", async (req, res) => {
  // should have template id
  if (!("id" in req.body)) {
    res.status(400).json({ message: "id field is missing" });
    return;
  }

  // price
  if (!("price" in req.body)) {
    res.status(400).json({ message: "price field is missing" });
    return;
  }

  // name
  if (!("name" in req.body)) {
    res.status(400).json({ message: "name field is missing" });
    return;
  }

  const id = +req.body.id;
  const price = +req.body.price; // in paisa
  const name = req.body.name;

  await PrismaClientSingleton.prisma.resumeTemplateMarketplace.update({
    where: {
      id: id,
    },
    data: {
      price: price,
      displayName: name,
      updatedAt: new Date(),
    },
  });

  res.json({ message: "Template updated successfully" });
});

/**
 *
 * Delete the marketplace template
 *
 */
router.post("/delete_marketplace_template", async (req, res) => {
  // should have template id
  if (!("id" in req.body)) {
    res.status(400).json({ message: "id field is missing" });
    return;
  }

  const id = +req.body.id;

  await PrismaClientSingleton.prisma.resumeTemplateMarketplace.delete({
    where: {
      id: id,
    },
  });

  res.json({ message: "Template deleted successfully" });
});

/**
 *
 * Get single marketplace template
 *
 */
router.post("/single_marketplace_template", async (req, res) => {
  // should have template id
  if (!("id" in req.body)) {
    res.status(400).json({ message: "id field is missing" });
    return;
  }

  const id = +req.body.id;

  const template = await PrismaClientSingleton.prisma.resumeTemplateMarketplace.findUnique({
    where: {
      id: id,
    },
  });

  res.json(template);
});

/**
 *
 * Get single contact us message
 *
 */
router.post("/single_contact_us_message", async (req, res) => {
  // should have template id
  if (!("id" in req.body)) {
    res.status(400).json({ message: "id field is missing" });
    return;
  }

  const id = +req.body.id;

  const message = await PrismaClientSingleton.prisma.contactUs.findUnique({
    where: {
      id: id,
    },
  });

  res.json(message);
});

/**
 *
 * Get the admin details
 *
 */
router.post("/admin_details", async (req, res) => {
  const adminDetails = await PrismaClientSingleton.prisma.admin.findUnique({
    where: {
      email: res.locals.email,
    },
  });

  res.json(adminDetails);
});

export default router;
