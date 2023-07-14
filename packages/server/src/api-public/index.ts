import { createHmac } from "crypto";
import express from "express";
import moment from "moment";
import {
  OrderPayloadCard,
  OrderPayloadNetBanking,
  OrderPayloadUPI,
  OrderPayloadWallet,
  PrismaClientSingleton,
  SubscriptionActivatedEvent,
  SubscriptionAuthenticatedEvent,
  SubscriptionCancelledEvent,
  SubscriptionChargedEvent,
  SubscriptionHaltedEvent,
} from "../utils";

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

/**
 *
 *
 * Razorpay webhook
 */
router.post("/razorpay_webhook", async (req, res) => {
  // listen for the order paid event
  const payload = req.body;
  const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET || "";

  // Verify the request signature
  const signature = req.headers["x-razorpay-signature"];
  const expectedSignature = createHmac("sha256", webhookSecret).update(JSON.stringify(payload)).digest("hex");

  if (signature !== expectedSignature) {
    res.status(400).json({ message: "Invalid signature" });
    return;
  }

  if (payload.event === "order.paid") {
    // template bought success
    const templateName = (payload as OrderPayloadNetBanking).payload.order.entity.notes.templateName;
    const emailOfUser = (payload as OrderPayloadNetBanking).payload.order.entity.notes.email;

    if (!templateName || !emailOfUser) {
      res.status(400).json({ message: "Template name is required" });
      return;
    }

    // This template is bought buy the logged in user
    const prisma = PrismaClientSingleton.prisma;
    switch ((payload as OrderPayloadNetBanking).payload.payment.entity.method) {
      case "card":
        const cardTransaction = payload as OrderPayloadCard;
        await prisma.user.update({
          where: {
            email: emailOfUser,
          },
          data: {
            boughtTemplate: {
              create: {
                name: templateName,
                price: cardTransaction.payload.order.entity.amount,
                transaction: {
                  create: {
                    amount: cardTransaction.payload.order.entity.amount,
                    amountDue: cardTransaction.payload.order.entity.amount_due,
                    amountPaid: cardTransaction.payload.order.entity.amount_paid,
                    currency: cardTransaction.payload.order.entity.currency,
                    isInternational: cardTransaction.payload.payment.entity.international,
                    method: "NET_BANKING",
                    orderId: cardTransaction.payload.order.entity.id,
                    status: "SUCCESS",
                    card: {
                      create: {
                        isInternational: cardTransaction.payload.payment.entity.card.international,
                        last4: cardTransaction.payload.payment.entity.card.last4,
                        name: cardTransaction.payload.payment.entity.card.name,
                        network: cardTransaction.payload.payment.entity.card.network,
                        type: cardTransaction.payload.payment.entity.card.type === "debit" ? "DEBIT" : "CREDIT",
                      },
                    },
                  },
                },
              },
            },
          },
        });
        break;

      case "netbanking":
        const netbankingTransaction = payload as OrderPayloadNetBanking;
        await prisma.user.update({
          where: {
            email: emailOfUser,
          },
          data: {
            boughtTemplate: {
              create: {
                name: templateName,
                price: netbankingTransaction.payload.order.entity.amount,
                transaction: {
                  create: {
                    amount: netbankingTransaction.payload.order.entity.amount,
                    amountDue: netbankingTransaction.payload.order.entity.amount_due,
                    amountPaid: netbankingTransaction.payload.order.entity.amount_paid,
                    currency: netbankingTransaction.payload.order.entity.currency,
                    isInternational: netbankingTransaction.payload.payment.entity.international,
                    method: "NET_BANKING",
                    orderId: netbankingTransaction.payload.order.entity.id,
                    status: "SUCCESS",
                    netBanking: {
                      create: {
                        email: netbankingTransaction.payload.payment.entity.email,
                        mobile: netbankingTransaction.payload.payment.entity.contact,
                        name: netbankingTransaction.payload.payment.entity.bank,
                      },
                    },
                  },
                },
              },
            },
          },
        });
        break;

      case "upi":
        const upiTransaction = payload as OrderPayloadUPI;
        await prisma.user.update({
          where: {
            email: emailOfUser,
          },
          data: {
            boughtTemplate: {
              create: {
                name: templateName,
                price: upiTransaction.payload.order.entity.amount,
                transaction: {
                  create: {
                    amount: upiTransaction.payload.order.entity.amount,
                    amountDue: upiTransaction.payload.order.entity.amount_due,
                    amountPaid: upiTransaction.payload.order.entity.amount_paid,
                    currency: upiTransaction.payload.order.entity.currency,
                    isInternational: upiTransaction.payload.payment.entity.international,
                    method: "UPI",
                    orderId: upiTransaction.payload.order.entity.id,
                    status: "SUCCESS",
                    UPI: {
                      create: {
                        email: upiTransaction.payload.payment.entity.email,
                        mobile: upiTransaction.payload.payment.entity.contact,
                        vpa: upiTransaction.payload.payment.entity.vpa || "",
                      },
                    },
                  },
                },
              },
            },
          },
        });
        break;

      case "wallet":
        const walletTransaction = payload as OrderPayloadWallet;
        await prisma.user.update({
          where: {
            email: emailOfUser,
          },
          data: {
            boughtTemplate: {
              create: {
                name: templateName,
                price: walletTransaction.payload.order.entity.amount,
                transaction: {
                  create: {
                    amount: walletTransaction.payload.order.entity.amount,
                    amountDue: walletTransaction.payload.order.entity.amount_due,
                    amountPaid: walletTransaction.payload.order.entity.amount_paid,
                    currency: walletTransaction.payload.order.entity.currency,
                    isInternational: walletTransaction.payload.payment.entity.international,
                    method: "WALLET",
                    orderId: walletTransaction.payload.order.entity.id,
                    status: "SUCCESS",
                    wallet: {
                      create: {
                        email: walletTransaction.payload.payment.entity.email,
                        mobile: walletTransaction.payload.payment.entity.contact,
                        name: walletTransaction.payload.payment.entity.wallet,
                      },
                    },
                  },
                },
              },
            },
          },
        });
        break;
    }

    res.status(200).json({ message: "Success" });
  }

  if (payload.event === "subscription.authenticated") {
    // create new subscription if not exit
    const prisma = PrismaClientSingleton.prisma;
    const emailOfUser = (payload as SubscriptionAuthenticatedEvent).payload.subscription.entity.notes.email;
    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          update: {
            expireOn: moment().add(1, "month").toDate(),
            isActive: true,
          },
        },
      },
    });

    res.status(200).json({ message: "Success" });
  }

  if (payload.event === "subscription.activated") {
    // update the subscription to active
    const emailOfUser = (payload as SubscriptionActivatedEvent).payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;
    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          update: {
            isActive: true,
            expireOn: moment().add(1, "month").toDate(),
          },
        },
      },
    });

    res.status(200).json({ message: "Success" });
  }

  if (payload.event === "subscription.charged") {
    // only credit card is supported
    const subscriptionPayload = (payload as SubscriptionChargedEvent).payload;
    const emailOfUser = subscriptionPayload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          update: {
            isActive: true,
            expireOn: moment().add(1, "month").toDate(),
            transaction: {
              create: {
                amount: +subscriptionPayload.payment.entity.amount,
                method: "CARD",
                card: {
                  create: {
                    isInternational: subscriptionPayload.payment.entity.card.international,
                    last4: subscriptionPayload.payment.entity.card.last4,
                    name: subscriptionPayload.payment.entity.card.name,
                    network: subscriptionPayload.payment.entity.card.network,
                    type: subscriptionPayload.payment.entity.card.type === "debit" ? "DEBIT" : "CREDIT",
                  },
                },
              },
            },
          },
        },
      },
    });

    res.status(200).json({ message: "Success" });
  }

  if (payload.event === "subscription.cancelled") {
    const emailOfUser = (payload as SubscriptionCancelledEvent).payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;
    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          delete: true,
        },
      },
    });

    res.status(200).json({ message: "Success" });
  }

  if (payload.event === "subscription.halted") {
    const emailOfUser = (payload as SubscriptionHaltedEvent).payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;
    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          update: {
            isActive: false,
          },
        },
      },
    });

    res.status(200).json({ message: "Success" });
  }
});

export default router;
