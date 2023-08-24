import express from "express";
import { PrismaClientSingleton, addTemplate, hashPassword, isWeakPassword } from "../utils";

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

  const user = await PrismaClientSingleton.prisma.user.findUnique({
    where: {
      email: email,
    },
  });

  if (!user) {
    res.status(404).json({ message: "User not found" });
    return;
  }

  if (isWeakPassword(password)) {
    res.status(400).json({ message: "Password is too weak" });
    return;
  }

  await PrismaClientSingleton.prisma.user.update({
    where: {
      email: email,
    },
    data: {
      password: hashPassword(password),
    },
  });
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

export default router;
