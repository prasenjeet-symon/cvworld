import express from "express";
import { PrismaClientSingleton } from "../utils";
import { paymentSuccess } from "../views/payment-success";
import { FeedbackFormController } from "./feedback-form.controller";
import { WebhookController } from "./webhook.controller";

const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

/** Add new feedback */
router.post("/feedback", (req, res) => new FeedbackFormController(req, res).addFeedback());

/** Upload feedback attachment */
router.post("/upload_feedback_file", FeedbackFormController.attachmentStorage(), (req, res) => new FeedbackFormController(req, res).uploadFeedbackAttachment());

/** Delete feedback */
router.delete("/feedback", (req, res) => new FeedbackFormController(req, res).deleteFeedback());

/** Get all feedback */
router.get("/feedback", (req, res) => new FeedbackFormController(req, res).getAllFeedback());  

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

/**
 *
 *
 * Razorpay webhook
 */
router.post("/razorpay_webhook", (req, res) => new WebhookController(req, res).onWebhookEvent());

// Get | Payment successful
router.get("/payment_success", async (req, res) => {
  const razorpay_payment_id = req.query.razorpay_payment_id as string;
  const razorpay_order_id = req.query.razorpay_order_id as string;
  const priceInPaisa = req.query.price as string;
  const priceInRupees = (+priceInPaisa / 100).toFixed(2);

  // set HTML
  res.set("Content-Type", "text/html");
  res.send(paymentSuccess(+priceInRupees, razorpay_order_id, razorpay_payment_id));
});

export default router;
