import express from "express";
import { PrismaClientSingleton } from "../utils";

const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

// add contact us message
router.post("/contact_us", async (req, res) => {
  if (!("message" in req.body && "phone" in req.body && "email" in req.body && "name" in req.body)) {
    res.status(400).json({ message: "All fields are required" });
    return;
  }

  const message = req.body.message;
  const phone = req.body.phone;
  const email = req.body.email;
  const name = req.body.name;

  // add to the database
  const prisma = PrismaClientSingleton.prisma;
  const contactUs = await prisma.contactUs.create({
    data: {
      message: message,
      phone: phone,
      email: email,
      name: name,
      isResolved: false,
    },
    select: {
      id: true,
      createdAt: true,
      email: true,
      isResolved: true,
      message: true,
      name: true,
      phone: true,
      updatedAt: true,
    },
  });

  res.json({ ...contactUs });
});

export default router;
