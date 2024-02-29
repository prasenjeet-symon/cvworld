import { createHmac } from "crypto";
import { Request, Response } from "express";
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

export class WebhookController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * On webhook event
   */
  public async onWebhookEvent() {
    if (!this.validateWebhook()) {
      console.error("Webhook validation failed");
      return;
    }

    if (!this.isValidSignature()) {
      console.error("Invalid signature");
      return;
    }

    const { event } = this.req.body;

    console.log("-----------------------------");
    console.log("Webhook event received");
    console.log(`Event: ${event}`);
    console.log("-----------------------------");

    switch (event) {
      case "order.paid":
        await this.onPaidEvent();
        break;

      case "subscription.authenticated":
        await this.onSubscriptionAuthorized();
        break;

      case "subscription.activated":
        await this.onSubscriptionActivated();
        break;

      case "subscription.charged":
        await this.onSubscriptionCharged();
        break;

      case "subscription.cancelled":
        await this.onSubscriptionCancelled();
        break;

      case "subscription.halted":
        await this.onSubscriptionHalted();
        break;

      default:
        this.res.status(204).json({ error: "Unknown event" });
        console.error("Unknown event");
        break;
    }
  }

  /**
   *
   * Paid event
   */
  public async onPaidEvent() {
    const { body: payload }: { body: OrderPayloadNetBanking } = this.req;
    const templateName = payload.payload.order.entity.notes.templateName;
    const emailOfUser = payload.payload.order.entity.notes.email;
    const method = payload.payload.payment.entity.method;
    const planName = payload.payload.order.entity.notes.planName;
    const planId = payload.payload.order.entity.notes.planId;

    console.log("-----------------------------");
    console.log(`Template name: ${templateName}`);
    console.log(`Email: ${emailOfUser}`);
    console.log(`Method: ${method}`);
    console.log("planName: " + planName);
    console.log("planId: " + planId);
    console.log(`Event: ${payload.event}`);
    console.log("-----------------------------");

    // There may be subscription payment
    // If yes then instantly activate the subscription
    if (planId) {
      // This is related to the subscription
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
    }

    if (!templateName || !emailOfUser) {
      this.res.status(204).json({ error: "Template name and email is required" });
      return;
    }

    const prisma = PrismaClientSingleton.prisma;

    const doEventExit = await prisma.user.findUnique({
      where: {
        email: emailOfUser,
      },
      select: {
        boughtTemplate: {
          where: {
            eventID: payload.payload.payment.entity.id,
          },
        },
      },
    });

    if (doEventExit && doEventExit.boughtTemplate.length !== 0) {
      this.res.status(204).json({ error: "Template already bought" });
      return;
    }

    switch (method) {
      case "card":
        await this.onCardPayment(emailOfUser, templateName);
        break;

      case "netbanking":
        await this.onNetBankingPayment(emailOfUser, templateName);
        break;

      case "upi":
        await this.onUpiPayment(emailOfUser, templateName);
        break;

      case "wallet":
        await this.onWalletPayment(emailOfUser, templateName);
        break;

      default:
        this.res.status(204).json({ error: "Unknown payment method" });
        console.error("Unknown payment method");
        break;
    }
  }

  /**
   *
   * Card payment
   */
  public async onCardPayment(email: string, templateName: string) {
    const { body: cardTransaction }: { body: OrderPayloadCard } = this.req;

    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        boughtTemplate: {
          create: {
            eventID: cardTransaction.payload.payment.entity.id,
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

    this.res.status(200).json({ success: true });
    return;
  }

  /**
   *
   * Netbanking payment
   */
  public async onNetBankingPayment(email: string, templateName: string) {
    const { body: netbankingTransaction }: { body: OrderPayloadNetBanking } = this.req;

    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        boughtTemplate: {
          create: {
            eventID: netbankingTransaction.payload.payment.entity.id,
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

    this.res.status(200).json({ success: true });
    return;
  }

  /**
   *
   * Upi payment
   */
  public async onUpiPayment(email: string, templateName: string) {
    const { body: upiTransaction }: { body: OrderPayloadUPI } = this.req;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: { email: email },
      data: {
        boughtTemplate: {
          create: {
            eventID: upiTransaction.payload.payment.entity.id,
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

    this.res.status(200).json({ success: true });
    return;
  }

  /**
   *
   * Wallet payment
   */
  public async onWalletPayment(email: string, templateName: string) {
    const { body: walletTransaction }: { body: OrderPayloadWallet } = this.req;
    const prisma = PrismaClientSingleton.prisma;

    await prisma.user.update({
      where: { email: email },
      data: {
        boughtTemplate: {
          create: {
            eventID: walletTransaction.payload.payment.entity.id,
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

    this.res.status(200).json({ success: true });
    return;
  }

  /**
   *
   * on subscription authorized
   */
  public async onSubscriptionAuthorized() {
    const { body: subscription }: { body: SubscriptionAuthenticatedEvent } = this.req;
    const prisma = PrismaClientSingleton.prisma;
    const emailOfUser = subscription.payload.subscription.entity.notes.email;

    console.log("-----------------------------");
    console.log("Type: " + subscription.event);
    console.log(emailOfUser);
    console.log("-----------------------------");

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

    this.res.status(200).json({ message: "Success" });
    return;
  }

  /**
   *
   * On subscription activated
   */
  public async onSubscriptionActivated() {
    const { body: subscription }: { body: SubscriptionActivatedEvent } = this.req;
    const emailOfUser = subscription.payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;

    console.log("-----------------------------");
    console.log("Type: " + subscription.event);
    console.log(emailOfUser);
    console.log("-----------------------------");

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

    this.res.status(200).json({ message: "Success" });
    return;
  }

  /**
   *
   * On subscription charged
   */
  public async onSubscriptionCharged() {
    const { body: subscription }: { body: SubscriptionChargedEvent } = this.req;
    const emailOfUser = subscription.payload.subscription.entity.notes.email;
    const method = subscription.payload.payment.entity.method;
    const prisma = PrismaClientSingleton.prisma;

    console.log("-----------------------------");
    console.log("Type: " + subscription.event);
    console.log("Email: " + emailOfUser);
    console.log("Method: " + method);
    console.log("-----------------------------");

    // if already charged return
    const alreadyCharged = await prisma.user.findUnique({
      where: {
        email: emailOfUser,
      },
      select: {
        subscription: {
          select: {
            transaction: {
              where: {
                eventID: subscription.payload.payment.entity.id,
              },
            },
          },
        },
      },
    });

    if (alreadyCharged && alreadyCharged.subscription && alreadyCharged.subscription.transaction.length !== 0) {
      this.res.status(204).json({ message: "Already charged" });
      return;
    }

    switch (method) {
      case "card":
        await this.onCardSubscriptionPayment(emailOfUser);
        break;

      case "upi":
        await this.onUpiSubscriptionPayment(emailOfUser);
        break;

      default:
        this.res.status(204).json({ message: "Not supported" });
        break;
    }
  }

  /**
   *
   * On upi subscription payment
   */
  public async onUpiSubscriptionPayment(emailOfUser: string) {
    const prisma = PrismaClientSingleton.prisma;
    const { body: subscriptionPayload }: { body: SubscriptionChargedEvent } = this.req;

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
                eventID: subscriptionPayload.payload.payment.entity.id,
                amount: +subscriptionPayload.payload.payment.entity.amount,
                method: "UPI",
                upi: {
                  create: {
                    email: subscriptionPayload.payload.payment.entity.email,
                    mobile: subscriptionPayload.payload.payment.entity.contact,
                    vpa: subscriptionPayload.payload.payment.entity.vpa || "",
                  },
                },
              },
            },
          },
        },
      },
    });

    this.res.status(200).json({ success: true });
    return;
  }

  /**
   *
   * On card subscription payment
   */
  public async onCardSubscriptionPayment(emailOfUser: string) {
    const prisma = PrismaClientSingleton.prisma;
    const { body: subscriptionPayload }: { body: SubscriptionChargedEvent } = this.req;

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
                eventID: subscriptionPayload.payload.payment.entity.id,
                amount: +subscriptionPayload.payload.payment.entity.amount,
                method: "CARD",
                card: {
                  create: {
                    isInternational: subscriptionPayload.payload.payment.entity.card.international,
                    last4: subscriptionPayload.payload.payment.entity.card.last4,
                    name: subscriptionPayload.payload.payment.entity.card.name,
                    network: subscriptionPayload.payload.payment.entity.card.network,
                    type: subscriptionPayload.payload.payment.entity.card.type === "debit" ? "DEBIT" : "CREDIT",
                  },
                },
              },
            },
          },
        },
      },
    });

    this.res.status(200).json({ message: "Success" });
    return;
  }

  /**
   *
   * Subscription cancelled
   */
  public async onSubscriptionCancelled() {
    const { body: subscription }: { body: SubscriptionCancelledEvent } = this.req;
    const emailOfUser = subscription.payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;

    console.log("-----------------------------");
    console.log("Type: " + subscription.event);
    console.log("Email: " + emailOfUser);
    console.log("-----------------------------");

    await prisma.user.update({
      where: {
        email: emailOfUser,
      },
      data: {
        subscription: {
          delete:true
        }
      },
    });

    this.res.status(200).json({ message: "Success" });
    return;
  }

  /**
   *
   * Subscription halted
   */
  public async onSubscriptionHalted() {
    const { body: subscription }: { body: SubscriptionHaltedEvent } = this.req;
    const emailOfUser = subscription.payload.subscription.entity.notes.email;
    const prisma = PrismaClientSingleton.prisma;

    console.log("-----------------------------");
    console.log("Type: " + subscription.event);
    console.log("Email: " + emailOfUser);
    console.log("-----------------------------");

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

    this.res.status(200).json({ message: "Success" });
    return;
  }

  /**
   *
   * Validate webhook
   */
  private validateWebhook() {
    const { RAZORPAY_WEBHOOK_SECRET } = process.env;

    if (RAZORPAY_WEBHOOK_SECRET === undefined) {
      console.error("RAZORPAY_WEBHOOK_SECRET is not defined. Please set it in .env file");
      this.res.status(204).json({ error: "Internal server error" });
      return false;
    }

    if (!RAZORPAY_WEBHOOK_SECRET) {
      console.error("RAZORPAY_WEBHOOK_SECRET is not defined. Please set it in .env file");
      this.res.status(204).json({ error: "Internal server error" });
      return false;
    }

    const { payload } = this.req.body;

    if (payload === undefined) {
      console.error("payload is not defined.");
      this.res.status(204).json({ error: "Internal server error" });
      return false;
    }
    // x-razorpay-signature
    const { "x-razorpay-signature": signature } = this.req.headers;

    if (signature === undefined) {
      console.error("X-Razorpay-Signature is not defined.");
      this.res.status(204).json({ error: "Internal server error" });
      return false;
    }

    if (!signature) {
      console.error("X-Razorpay-Signature is not defined.");
      this.res.status(204).json({ error: "Internal server error" });
      return false;
    }

    console.log("-----------------------------");
    console.log("Webhook signature: " + signature);
    console.log("-----------------------------");
    return true;
  }

  /**
   *
   *
   * Is valid signature
   */
  private isValidSignature() {
    const { RAZORPAY_WEBHOOK_SECRET } = process.env;
    const payload = this.req.body;
    const { "x-razorpay-signature": signature } = this.req.headers;

    const expectedSignature = createHmac("sha256", RAZORPAY_WEBHOOK_SECRET || "")
      .update(JSON.stringify(payload))
      .digest("hex");

    console.log("-----------------------------");
    console.log("Secret: " + RAZORPAY_WEBHOOK_SECRET);
    console.log("Expected signature: " + expectedSignature);
    console.log("Actual signature: " + signature);
    console.log("-----------------------------");

    if (signature !== expectedSignature) {
      this.res.status(204).json({ message: "Invalid signature" });
      return false;
    }

    return true;
  }
}
