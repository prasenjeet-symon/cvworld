import { PrismaClient } from "@prisma/client";
import express, { NextFunction, Request, Response } from "express";
import { v4, validate } from "uuid";
import router from "./api";
import routerAdmin from "./api-admin/index";
import routerPublic from "./api-public";
import routerAuth from "./auth";
import { Resend } from 'resend';
/** 
 * 
 * Send email using resend
 */
export async function sendEmail(data: EmailOptions): Promise<string | undefined> {
  const from = process.env.RESEND_FROM || 'onboarding@resend.dev';
  const API_KEY = process.env.RESEND_API_KEY || '';
  const resend = new Resend(API_KEY);

  try {
      const sendResult = await resend.emails.send({
          from: from,
          to: data.to,
          subject: data.subject,
          html: data.html || '',
      });

      if (sendResult.error) throw sendResult.error;
      return sendResult.data?.id;
  } catch (error: any) {
      Logger.getInstance().logError('Error sending email : ' + error);
      return undefined;
  }
}
/** 
 * 
 * Get random user name
 */

export function generateUniqueUsername(fullName: string): string {
  const randomNumber = Math.floor(1000 + Math.random() * 9000); // Generate random number between 1000 and 9999
  const username = `${fullName}_${randomNumber}`.toLowerCase();
  return username;
}


export function isTokenActive(token: string): { isActive: boolean; payload?: any } {
  try {
    const jwt = require("jsonwebtoken");

    const decoded = jwt.verify(token, process.env.JWT_SECRET || "", {
      ignoreExpiration: false,
    });

    Logger.getInstance().logSuccess(JSON.stringify(decoded));

    // Return both the status and the payload
    return { isActive: true, payload: decoded };
  } catch (error) {
    console.error(error);
    // An error occurred while decoding the token
    return { isActive: false };
  }
}

/*
 *
 *
 * Create JWT
 */
export async function createJwt(userId: string, email: string, isAdmin: boolean = false, expiresIn: string | null = null, timeZone: string | null = null): Promise<string> {
  const jwt = require("jsonwebtoken");
  const JWT_SECRET = process.env.JWT_SECRET;
  const JWT_EXPIRES_IN = expiresIn || process.env.JWT_EXPIRES_IN || "1d";

  if (!JWT_SECRET) {
    Logger.getInstance().logError("JWT_SECRET not set in the environment variables");
    throw new Error("JWT_SECRET not set in the environment variables");
  }

  return jwt.sign({ userId, email, isAdmin: isAdmin, timeZone }, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}

/*
 *
 * Get client ip address
 */
export function getClientIP(req: Request): string {
  // Check if the request is coming through a proxy
  const forwardedFor = req.headers["x-forwarded-for"];
  if (forwardedFor && typeof forwardedFor === "string") {
    // Extract the client IP from the X-Forwarded-For header
    const ips = forwardedFor.split(",");
    return ips[0].trim();
  }

  // If not behind a proxy, simply use the remote address from the request
  return req.ip || "";
}

/*
 *
 * Get client location
 */
export async function getClientLocation(req: Request): Promise<LocationInfo | undefined> {
  const { IPINFO_TOKEN } = process.env;
  if (IPINFO_TOKEN === undefined) {
    Logger.getInstance().logError("IPINFO_TOKEN is not defined. Please set it in .env file");
    return;
  }

  const clientIP = getClientIP(req);
  console.log("Client IP: " + clientIP);

  try {
    // Make a request to the ipinfo.io API to get location information
    const response = await axios.get<LocationInfo>(`https://ipinfo.io/${clientIP}?token=${IPINFO_TOKEN}`);
    return response.data;
  } catch (error) {
    Logger.getInstance().logError("Error getting client location : " + error);
    return;
  }
}

/**
 *
 *
 * Logger
 */
export class Logger {
  private static instance: Logger;

  private constructor() {}

  public static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }

  private log(message: any) {
    console.log(message);
  }

  private logWithColor(message: string, color: string): void {
    console.log(`${color}%s\x1b[0m`, message);
  }

  public logWarning(message: string): void {
    this.logWithColor(`Warning: ${message}`, "\x1b[33m"); // Yellow
  }

  public logError(message: string): void {
    this.logWithColor(`Error: ${message}`, "\x1b[31m"); // Red
  }

  public logSuccess(message: string): void {
    this.logWithColor(`Success: ${message}`, "\x1b[32m"); // Green
  }
}

/**
 *
 * Is input integer
 */
export function isInteger(value: any): boolean {
  return Number.isInteger(value);
}
/**
 *
 * Is valid email
 */
export function isValidEmail(email: string): boolean {
  // Regular expression for basic email format validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 *
 * Is valid UUID
 */
export function isValidUUID(uuid: string): boolean {
  return validate(uuid);
}

/**
 *
 * Is valid string length
 */
export function isValidStringLength(value: string, min: number, max: number): boolean {
  return value.length >= min && value.length <= max;
}

/**
 *
 * Is boolean
 */
export function isBoolean(value: any): boolean {
  return typeof value === "boolean";
}

/**
 *
 * Is defined
 */
export function isDefined(value: any): boolean {
  return value !== undefined && value !== null;
}

export type paymentMethod = "netbanking" | "card" | "wallet" | "upi";
export enum EPaymentMethod {
  netbanking = "netbanking",
  card = "card",
  wallet = "wallet",
  upi = "upi",
}

export interface Order {
  id: string;
  entity: string;
  amount: number;
  amountPaid: number;
  amountDue: number;
  currency: string;
  receipt?: string | null;
  offerId?: string | null;
  status: string;
  attempts: number;
  notes: { [key: string]: any };
  createdAt: Date;
}

export interface Subscription {
  id: string;
  entity: string;
  plan_id: string;
  status: string;
  current_start: number | null;
  current_end: number | null;
  ended_at: number | null;
  quantity: number;
  notes: {
    [key: string]: string;
  };
  charge_at: number;
  start_at: number;
  end_at: number;
  auth_attempts: number;
  total_count: number;
  paid_count: number;
  customer_notify: boolean;
  created_at: number;
  expire_by: number;
  short_url: string;
  has_scheduled_changes: boolean;
  change_scheduled_at: number | null;
  source: string;
  offer_id: string;
  remaining_count: number;
}

interface Plan {
  id: string;
  entity: string;
  interval: number;
  period: string;
  item: {
    id: string;
    active: boolean;
    name: string;
    description: string | null;
    amount: number;
    unit_amount: number;
    currency: string;
    type: string;
    unit: string | null;
    tax_inclusive: boolean;
    hsn_code: string | null;
    sac_code: string | null;
    tax_rate: number | null;
    tax_id: string | null;
    tax_group_id: string | null;
    created_at: number;
    updated_at: number;
  };
  notes: Record<string, string> | Array<unknown>;
  created_at: number;
}

export interface templatePlans {
  entity: string;
  count: number;
  items: Plan[];
}

export interface PremiumTemplatePlan {
  id: string;
  entity: string;
  interval: number;
  period: string;
  item: {
    id: string;
    active: boolean;
    name: string;
    description: string;
    amount: number;
    unit_amount: number;
    currency: string;
    type: string;
    unit: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    tax_inclusive: boolean;
    hsn_code: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    sac_code: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    tax_rate: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    tax_id: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    tax_group_id: any; // The type for this property is not provided in the JSON, so it's set as 'any'
    created_at: number;
    updated_at: number;
  };
  notes: any;
  created_at: number;
}

export interface SubscriptionHaltedEvent {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    subscription: {
      entity: {
        id: string;
        entity: string;
        plan_id: string;
        customer_id: string;
        status: string;
        type: number;
        current_start: number;
        current_end: number;
        ended_at: number | null;
        quantity: number;
        notes: {
          [key: string]: string;
        };
        charge_at: number;
        start_at: number;
        end_at: number;
        auth_attempts: number;
        total_count: number;
        paid_count: number;
        customer_notify: boolean;
        created_at: number;
        expire_by: number;
        short_url: string | null;
        has_scheduled_changes: boolean;
        change_scheduled_at: number | null;
        source: string;
        offer_id: string;
        remaining_count: number;
      };
    };
  };
  created_at: number;
}

export interface SubscriptionCancelledEvent {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    subscription: {
      entity: {
        id: string;
        entity: string;
        plan_id: string;
        customer_id: string;
        status: string;
        type: number;
        current_start: number;
        current_end: number;
        ended_at: number;
        quantity: number;
        notes: {
          [key: string]: string;
        };
        charge_at: number | null;
        start_at: number;
        end_at: number;
        auth_attempts: number;
        total_count: number;
        paid_count: number;
        customer_notify: boolean;
        created_at: number;
        expire_by: number | null;
        short_url: string | null;
        has_scheduled_changes: boolean;
        change_scheduled_at: number | null;
        source: string;
        offer_id: string;
        remaining_count: number;
      };
    };
  };
  created_at: number;
}

export interface SubscriptionChargedEvent {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    subscription: {
      entity: {
        id: string;
        entity: string;
        plan_id: string;
        customer_id: string;
        status: string;
        type: number;
        current_start: number;
        current_end: number;
        ended_at: number | null;
        quantity: number;
        notes: {
          [key: string]: string;
        };
        charge_at: number;
        start_at: number;
        end_at: number;
        auth_attempts: number;
        total_count: number;
        paid_count: number;
        customer_notify: boolean;
        created_at: number;
        expire_by: number | null;
        short_url: string | null;
        has_scheduled_changes: boolean;
        change_scheduled_at: number | null;
        source: string;
        offer_id: string;
        remaining_count: number;
      };
    };
    payment: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        currency: string;
        status: string;
        order_id: string;
        invoice_id: string;
        international: boolean;
        method: string;
        amount_refunded: number;
        amount_transferred: number;
        refund_status: string | null;
        captured: string;
        description: string;
        card_id: string;
        card: {
          id: string;
          entity: string;
          name: string;
          last4: string;
          network: string;
          type: string;
          issuer: string | null;
          international: boolean;
          emi: boolean;
          expiry_month: number;
          expiry_year: number;
        };
        bank: string | null;
        wallet: string | null;
        vpa: string | null;
        email: string;
        contact: string;
        customer_id: string;
        token_id: string | null;
        notes: any[];
        fee: number;
        tax: number;
        error_code: string | null;
        error_description: string | null;
        created_at: number;
      };
    };
  };
  created_at: number;
}

export interface SubscriptionAuthenticatedEvent {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    subscription: {
      entity: {
        id: string;
        entity: string;
        plan_id: string;
        customer_id: string;
        status: string;
        current_start: number | null;
        current_end: number | null;
        ended_at: number | null;
        quantity: number;
        notes: any;
        charge_at: number;
        start_at: number;
        end_at: number;
        auth_attempts: number;
        total_count: number;
        paid_count: number;
        customer_notify: boolean;
        created_at: number;
        expire_by: number | null;
        short_url: string | null;
        has_scheduled_changes: boolean;
        change_scheduled_at: number | null;
        source: string;
        offer_id: string;
        remaining_count: number;
      };
    };
  };
  created_at: number;
}

export interface SubscriptionActivatedEvent {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    subscription: {
      entity: {
        id: string;
        entity: string;
        plan_id: string;
        customer_id: string;
        status: string;
        current_start: number;
        current_end: number;
        ended_at: number | null;
        quantity: number;
        notes: {
          [key: string]: string;
        };
        charge_at: number;
        start_at: number;
        end_at: number;
        auth_attempts: number;
        total_count: number;
        paid_count: number;
        customer_notify: boolean;
        created_at: number;
        expire_by: number;
        short_url: string | null;
        has_scheduled_changes: boolean;
        change_scheduled_at: number | null;
        source: string;
        offer_id: string;
        remaining_count: number;
      };
    };
  };
  created_at: number;
}

export interface OrderPayloadNetBanking {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    payment: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        currency: string;
        status: string;
        order_id: string;
        invoice_id: string | null;
        international: boolean;
        method: paymentMethod;
        amount_refunded: number;
        refund_status: string | null;
        captured: boolean;
        description: string | null;
        card_id: string | null;
        bank: string;
        wallet: string | null;
        vpa: string | null;
        email: string;
        contact: string;
        notes: any;
        fee: number;
        tax: number;
        error_code: string | null;
        error_description: string | null;
        created_at: number;
      };
    };
    order: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        amount_paid: number;
        amount_due: number;
        currency: string;
        receipt: string;
        offer_id: string | null;
        status: string;
        attempts: number;
        notes: any;
        created_at: number;
      };
    };
  };
  created_at: number;
}

export interface OrderPayloadCard {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    payment: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        currency: string;
        status: string;
        order_id: string;
        invoice_id: string | null;
        international: boolean;
        method: paymentMethod;
        amount_refunded: number;
        refund_status: string | null;
        captured: boolean;
        description: string | null;
        card_id: string | null;
        card: {
          id: string;
          entity: string;
          name: string;
          last4: string;
          network: string;
          type: string;
          issuer: string | null;
          international: boolean;
          emi: boolean;
        };
        bank: string | null;
        wallet: string | null;
        vpa: string | null;
        email: string;
        contact: string;
        notes: any;
        fee: number;
        tax: number;
        error_code: string | null;
        error_description: string | null;
        created_at: number;
      };
    };
    order: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        amount_paid: number;
        amount_due: number;
        currency: string;
        receipt: string;
        offer_id: string | null;
        status: string;
        attempts: number;
        notes: any;
        created_at: number;
      };
    };
  };
  created_at: number;
}

export interface OrderPayloadWallet {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    payment: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        currency: string;
        status: string;
        order_id: string;
        invoice_id: string | null;
        international: boolean;
        method: paymentMethod;
        amount_refunded: number;
        refund_status: string | null;
        captured: boolean;
        description: string | null;
        card_id: string | null;
        bank: string | null;
        wallet: string;
        vpa: string | null;
        email: string;
        contact: string;
        notes: any;
        fee: number;
        tax: number;
        error_code: string | null;
        error_description: string | null;
        created_at: number;
      };
    };
    order: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        amount_paid: number;
        amount_due: number;
        currency: string;
        receipt: string;
        offer_id: string | null;
        status: string;
        attempts: number;
        notes: any;
        created_at: number;
      };
    };
  };
  created_at: number;
}

export interface OrderPayloadUPI {
  entity: string;
  account_id: string;
  event: string;
  contains: string[];
  payload: {
    payment: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        currency: string;
        status: string;
        order_id: string;
        invoice_id: string | null;
        international: boolean;
        method: paymentMethod;
        amount_refunded: number;
        refund_status: string | null;
        captured: boolean;
        description: string | null;
        card_id: string | null;
        bank: string | null;
        wallet: string | null;
        vpa: string | null;
        email: string;
        contact: string;
        notes: any;
        fee: number;
        tax: number;
        error_code: string | null;
        error_description: string | null;
        created_at: number;
      };
    };
    order: {
      entity: {
        id: string;
        entity: string;
        amount: number;
        amount_paid: number;
        amount_due: number;
        currency: string;
        receipt: string;
        offer_id: string | null;
        status: string;
        attempts: number;
        notes: any;
        created_at: number;
      };
    };
  };
  created_at: number;
}

interface IGoogleAuthTokenResponse {
  userId: string;
  email: string;
  name: string;
  profile: string;
  success: boolean;
}

export namespace DatabaseType {
  export interface Subscription {
    id: number;
    planName: string;
    isActive: boolean;
    expireOn: Date;
    activatedOn: Date;
    cycle: SubscriptionCycle;
    discount: bigint;
    basePrice: bigint;
    userId: number;
    createdAt: Date;
    updatedAt: Date;
  }

  type SubscriptionCycle = "MONTHLY" | "YEARLY";

  export interface Hobby {
    id: number;
    hobby: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface ProfessionalSummary {
    id: number;
    profile: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Resumes {
    id: number;
    resume: Resume;
    imageUrl: string;
    pdfUrl: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface PersonalDetails {
    id: number;
    profession: string;
    name: string;
    email: string;
    phone: string;
    country: string;
    city: string;
    address: string;
    postalCode: string;
    drivingLicense: string;
    nationality: string;
    placeOfBirth: string;
    dateOfBirth: Date;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Languages {
    id: number;
    language: string;
    level: number;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Skills {
    id: number;
    skill: string;
    level: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Courses {
    id: number;
    course: string;
    institution: string;
    startDate: Date;
    endDate: Date;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Educations {
    id: number;
    school: string;
    startDate: Date;
    endDate: Date;
    degree: string;
    city: string;
    description: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface EmploymentHistories {
    id: number;
    job: string;
    employer: string;
    startDate: Date;
    endDate: Date;
    city: string;
    description: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Internships {
    id: number;
    job: string;
    employer: string;
    startDate: Date;
    endDate: Date;
    city: string;
    description: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface ProfessionalSummary {
    id: number;
    profile: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Links {
    id: number;
    title: string;
    url: string;
    userId: number;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface Admin {
    id: number;
    email: string;
    fullName: string;
    profilePicture?: string;
    password: string;
    reference: string;
    createdAt?: Date;
    updatedAt?: Date;
  }

  export interface User {
    id: number;
    email: string;
    fullName: string;
    profilePicture?: string;
    password?: string;
    reference: string;
    subscription?: Subscription;
    personalDetails?: PersonalDetails;
    hobby?: Hobby;
    professionalSummary?: ProfessionalSummary;
    resumes: Resumes[];
    skills: Skills[];
    languages: Languages[];
    courses: Courses[];
    educations: Educations[];
    employmentHistories: EmploymentHistories[];
    internships: Internships[];
    links: Links[];
    createdAt?: Date;
    updatedAt?: Date;
  }
}

/** Sign in/ Sign up with google */
export async function signInOrSignUpWithGoogle(req: Request, res: Response): Promise<void> {
  const token = req.body.google_token as string;
  const timeZone = req.body.timeZone as string;

  if (!token) {
    res.status(400).json({ error: "Missing google_token" });
    return;
  }

  const verifiedToken = await verifyGoogleAuthToken(token);

  const oldUser = await doUserAlreadyExit(verifiedToken.email);
  if (oldUser) {
    // sign token and return
    res.status(200).json({ token: await createJwt(oldUser.reference, oldUser.email) });
    return;
  } else {
    const userId = v4();
    // create new user and sign token and return
    const prisma = PrismaClientSingleton.prisma;
    const newUser = await prisma.user.create({
      data: {
        timeZone: timeZone,
        email: verifiedToken.email,
        fullName: verifiedToken.name,
        profilePicture: verifiedToken.profile || "",
        reference: userId,
      },
    });

    res.status(200).json({ token: await createJwt(newUser.reference, newUser.email) });
    return;
  }
}

/**  Detect if the JWT is expired or not */

export function isTokenExpired(token: string): boolean {
  try {
    const jwt = require("jsonwebtoken");
    const decodedToken: any = jwt.decode(token);

    if (!decodedToken || !decodedToken.exp) {
      // Token or expiration claim is missing
      return true;
    }

    // Convert expiration time from seconds to milliseconds (assuming it's already in UTC)
    const expirationTimeUTC = decodedToken.exp * 1000;

    // Get the current time in UTC
    const currentTimeUTC = new Date().getTime();

    // Check if the token has expired
    return currentTimeUTC > expirationTimeUTC;
  } catch (error) {
    // An error occurred while decoding the token
    return true;
  }
}

/** Verify the Google Auth Token */
export async function verifyGoogleAuthToken(token: string): Promise<IGoogleAuthTokenResponse> {
  const response = await axios.get("https://oauth2.googleapis.com/tokeninfo", {
    params: {
      access_token: token,
    },
  });

  const userInfoEndpoint = "https://www.googleapis.com/oauth2/v1/userinfo";
  const userInfoResponse = await axios.get(userInfoEndpoint, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  const userProfile = userInfoResponse.data;

  const payload = response.data;
  const userId = payload.sub;
  const email = payload.email;
  const name = userProfile.name;
  const picture = userProfile.picture;
  return { success: true, userId, email, name, profile: picture };
}

/** Verify the JSON WEB TOKEN */
export const authenticateUser = (req: Request, res: Response, next: NextFunction) => {
  const JWT_SECRET = process.env.JWT_SECRET;
  if (!JWT_SECRET) {
    res.status(500).json({ error: "Internal server error" });
    return;
  }

  const jwt = require("jsonwebtoken");
  // Get the authentication token from the request headers, query parameters, or cookies
  // Example: Bearer <token>
  const token = req.headers.authorization ? req.headers.authorization.split(" ")[1] : req.query.token;

  // Verify and decode the token
  try {
    // Verify the token using your secret key or public key
    const decodedToken = jwt.verify(token, JWT_SECRET);

    // Set the userId and email in the request object
    res.locals.userId = decodedToken.userId;
    res.locals.email = decodedToken.email;
    res.locals.isAdmin = decodedToken.isAdmin;
    // Move to the next middleware
    next();
  } catch (error) {
    // Token verification failed
    res.status(401).json({ error: "Invalid token" });
    return;
  }
};

/** Authenticate admin  */
export const authenticateAdmin = (req: Request, res: Response, next: NextFunction) => {
  // if res.locals.isAdmin is false, return
  if (!res.locals.isAdmin) {
    res.status(401).json({ error: "Unauthorized" });
    return;
  }

  next();
};

/** Do user already exit */
export async function doUserAlreadyExit(email: string) {
  const prisma = PrismaClientSingleton.prisma;
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
  });

  return user;
}

/** Do admin user exit */
export async function doAdminUserExit(email: string): Promise<any> {
  const prisma = PrismaClientSingleton.prisma;
  const user = await prisma.admin.findUnique({
    where: {
      email: email,
    },
  });

  return user;
}

/** Sign Up with email and password */
export async function signUpWithEmailAndPassword(req: Request, res: Response) {
  try {
    const name = req.body.name;
    const email = req.body.email;
    const password = req.body.password;
    const userId = v4();
    const timeZone = req.body.timeZone;

    if (!("name" in req.body && "email" in req.body && "password" in req.body && "timeZone" in req.body)) {
      res.status(400).json({ message: "All input is required" });
      return;
    }

    if (!(name && email && password)) {
      res.status(400).json({ message: "All input is required" });
      return;
    }
    const prisma = PrismaClientSingleton.prisma;

    const userAlreadyExit = await doUserAlreadyExit(req.body.email);
    if (userAlreadyExit) {
      res.status(402).json({ message: "User already exit" });
      return;
    }

    const hashedPassword = hashPassword(password);

    // Save the user to the database or perform any desired actions
    const profilePicture = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y";

    await prisma.user.create({
      data: {
        timeZone: timeZone,
        email: email,
        fullName: name,
        profilePicture: profilePicture,
        password: hashedPassword,
        reference: userId,
        resumes: {
          create: [],
        },
      },
    });

    // generate JSON Web Token
    const token = await createJwt(userId, email);
    res.status(200).json({ token });
  } catch (error) {
    // Handle any errors that occur during the signup process
    console.error("Error during user signup:", error);
    res.status(500).json({ message: "An error occurred during signup" });
  }
}

/** Sign in the user using email and password */
export async function signInWithEmailAndPassword(req: Request, res: Response) {
  if (!("email" in req.body && "password" in req.body)) {
    res.status(400).json({ message: "Email and password are required" });
    return;
  }

  const email = req.body.email;
  const password = req.body.password;
  const oldUser = await doUserAlreadyExit(email);

  if (!oldUser) {
    res.status(402).json({ message: "User does not exit" });
    return;
  }

  const userId = oldUser.reference;
  const passwordOld = oldUser.password || "";
  const isPasswordCorrect = comparePasswords(password, passwordOld);
  if (isPasswordCorrect) {
    // create json web token and return
    res.status(200).json({ token: await createJwt(userId, email) });
    return;
  } else {
    // incorrect password
    res.status(403).json({ message: "Incorrect password" });
  }
}

/** Get user by userId */
export async function getUserByUserId(userId: string) {
  const prisma = PrismaClientSingleton.prisma;
  const user = await prisma.user.findUnique({
    where: {},
  });

  return user;
}
/**
 *
 * Sign in the admin
 *
 */
export async function signInAdmin(req: Request, res: Response) {
  const email = req.body.email;
  const password = req.body.password;

  console.log("email :", email, "password :", password);

  if (!(email && password)) {
    res.status(400).json({ message: "All input is required" });
    return;
  }

  const oldUser = await doAdminUserExit(email);
  if (!oldUser) {
    res.status(400).json({ message: "User does not exit" });
    return;
  }

  const userId = oldUser.reference;
  const passwordOld = oldUser.password;
  const isPasswordCorrect = await comparePasswords(password, passwordOld);
  if (isPasswordCorrect) {
    // create json web token and return
    res.status(200).json({ token: await createJwt(userId, email, true) });
    return;
  } else {
    // incorrect password
    res.status(401).json({ message: "Incorrect password" });
  }
}
/**
 *
 * Sign up admin on server init
 *
 */
export async function signUpAdmin() {
  // extract the email and password from the ENV
  const email = process.env.ADMIN_EMAIL;
  const password = process.env.ADMIN_PASSWORD;

  console.log("email", email, "password", password);

  if (!(email && password)) {
    throw new Error("Admin email and password are required");
  }

  const userId = v4();
  const oldUser = await doAdminUserExit(email);
  if (oldUser) {
    return;
  }

  // Hash the password
  const hashedPassword = hashPassword(password);

  // Save the user to the database or perform any desired actions
  const prisma = PrismaClientSingleton.prisma;
  await prisma.admin.create({
    data: {
      email: email,
      password: hashedPassword,
      fullName: process.env.ADMIN_NAME || "",
      reference: userId,
    },
  });

  // generate JSON Web Token
  const token = await createJwt(userId, email, true);
  return token;
}

export class PrismaClientSingleton {
  static #instance: PrismaClient;

  static get prisma() {
    if (!PrismaClientSingleton.#instance) {
      PrismaClientSingleton.#instance = new PrismaClient();
    }
    return PrismaClientSingleton.#instance;
  }
}
/**
 * Create the server
 */
export function createServer() {
  const cors = require("cors");
  const app = express();

  app.use(cors());
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use("/server/media", express.static(path.join(process.cwd(), "public")));
  app.use("/server/auth", routerAuth);
  app.use("/server/api_public", routerPublic);
  app.use("/server/api", authenticateUser, router);
  app.use("/server/api_admin", authenticateUser, authenticateAdmin, routerAdmin);

  app.get("/server/", (req, res) => {
    res.send({ message: "Hello World" });
  });

  return app;
}

/** Hashing password */
import crypto from "crypto";
import path from "path";

export const hashPassword = (password: string): string => {
  const hash = crypto.createHash("sha256");
  hash.update(password);
  return hash.digest("hex");
};

const comparePasswords = (plainPassword: string, hashedPassword: string): boolean => {
  const hashedInput = hashPassword(plainPassword);
  return hashedInput === hashedPassword;
};

export interface Resume {
  name: string;
  profession: string;
  profile: string;
  profilePicture: string;
  employmentHistory: {
    job: string;
    employer: string;
    startDate: Date;
    endDate: Date;
    city: string;
    description: string;
  }[];
  education: {
    school: string;
    startDate: Date;
    endDate: Date;
    degree: string;
    city: string;
    description: string;
  }[];
  internship: {
    job: string;
    employer: string;
    startDate: Date;
    endDate: Date;
    city: string;
    description: string;
  }[];
  courses: {
    course: string;
    institution: string;
    startDate: Date;
    endDate: Date;
  }[];
  details: {
    email: string;
    phone: string;
    country: string;
    city: string;
    address: string;
    postalCode: string;
    drivingLicense: string;
    nationality: string;
    placeOfBirth: string;
    dateOfBirth: Date;
  };
  links: { title: string; url: string }[];
  skills: {
    skill: string;
    level: number; // in percentage
  }[];
  hobbies: string;
  languages: {
    language: string;
    level: number;
  }[];
}

import { faker } from "@faker-js/faker";
import axios from "axios";
import { EmailOptions, LocationInfo } from "./schema";

// Generate dummy data for the Resume interface
export function generateDummyResume(): Resume {
  const resume: Resume = {
    profilePicture: "https://picsum.photos/200/200",
    name: faker.person.fullName(),
    profession: faker.person.jobTitle(),
    profile: faker.lorem.paragraph(),
    employmentHistory: [],
    education: [],
    internship: [],
    courses: [],
    details: {
      email: faker.internet.email(),
      phone: faker.phone.number(),
      country: faker.location.country(),
      city: faker.location.city(),
      address: faker.location.streetAddress(),
      postalCode: faker.location.zipCode(),
      drivingLicense: faker.word.words(2),
      nationality: faker.location.country(),
      placeOfBirth: faker.location.city(),
      dateOfBirth: faker.date.past(),
    },
    links: [],
    skills: [],
    hobbies: faker.lorem.paragraphs(),
    languages: [],
  };

  // Generate dummy employment history
  for (let i = 0; i < 3; i++) {
    const employment = {
      job: faker.person.jobTitle(),
      employer: faker.company.name(),
      startDate: faker.date.past(),
      endDate: faker.date.recent(),
      city: faker.location.city(),
      description: faker.lorem.paragraph(),
    };
    resume.employmentHistory.push(employment);
  }

  // Generate dummy education
  for (let i = 0; i < 2; i++) {
    const education = {
      school: faker.company.name(),
      startDate: faker.date.past(),
      endDate: faker.date.recent(),
      degree: faker.lorem.words(),
      city: faker.location.city(),
      description: faker.lorem.paragraph(),
    };
    resume.education.push(education);
  }

  // Generate dummy internship
  for (let i = 0; i < 2; i++) {
    const internship = {
      job: faker.person.jobTitle(),
      employer: faker.company.name(),
      startDate: faker.date.past(),
      endDate: faker.date.recent(),
      city: faker.location.city(),
      description: faker.lorem.paragraph(),
    };
    resume.internship.push(internship);
  }

  // Generate dummy courses
  for (let i = 0; i < 2; i++) {
    const course = {
      course: faker.lorem.words(),
      institution: faker.company.name(),
      startDate: faker.date.past(),
      endDate: faker.date.recent(),
    };
    resume.courses.push(course);
  }

  // Generate dummy links
  for (let i = 0; i < 2; i++) {
    const link = {
      title: faker.lorem.words(),
      url: faker.internet.url(),
    };
    resume.links.push(link);
  }

  // Generate dummy skills
  for (let i = 0; i < 3; i++) {
    const skill = {
      skill: faker.lorem.word(),
      level: faker.number.int({ min: 0, max: 100 }),
    };
    resume.skills.push(skill);
  }

  // Generate dummy languages
  for (let i = 0; i < 2; i++) {
    const language = {
      language: faker.lorem.word(),
      level: faker.number.int({ min: 0, max: 100 }),
    };
    resume.languages.push(language);
  }

  return resume;
}

/** Format date */
export function formatDate(utcTimestamp: Date, timeZone: string) {
  const utcDate = new Date(utcTimestamp);

  const formatter = new Intl.DateTimeFormat("en-US", {
    timeZone: timeZone,
    year: "numeric",
    month: "short",
    day: "numeric",
  });

  const convertedDateStr = formatter.format(utcDate);
  return convertedDateStr;
}

/** Generate the resume HTML */
export function generateResumeHTML(resume: Resume, timeZone: string) {
  return `
      <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
        <style>
          @import url("https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500;600&display=swap");

          .resume {
            padding: 50px;
            font-family: "Rubik", sans-serif;
            width: 210mm;
            height: 297mm;
            margin: 0 auto;
            background-color: white;
          }

          .resume > div:nth-of-type(1) {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
          }

          .resume > div:nth-of-type(1) > div:nth-of-type(1) {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 5px;
          }

          .resume > div:nth-of-type(1) > div:nth-of-type(2) {
            font-size: 1rem;
            font-weight: 400;
          }

          .lowerBody {
            display: grid;
            grid-template-columns: 2fr 1fr;
            grid-gap: 10px;
          }

          .lowerBody .profileSection,
          .lowerBody .employmentSection,
          .lowerBody .educationSection,
          .lowerBody .internshipSection,
          .lowerBody .coursesSection {
            display: flex;
            align-items: flex-start;
            padding: 10px 10px 10px 0px;
            margin: 15px 0px;
          }

          .lowerBody .profileSection > div:nth-of-type(2),
          .lowerBody .employmentSection > div:nth-of-type(2),
          .lowerBody .educationSection > div:nth-of-type(2),
          .lowerBody .internshipSection > div:nth-of-type(2),
          .lowerBody .coursesSection > div:nth-of-type(2) {
            flex: 1;
            margin-left: 10px;
          }

          .lowerBody .profileSection > div:nth-of-type(2) > div:nth-of-type(1),
          .lowerBody .employmentSection > div:nth-of-type(2) > div:nth-of-type(1),
          .lowerBody .educationSection > div:nth-of-type(2) > div:nth-of-type(1),
          .lowerBody .internshipSection > div:nth-of-type(2) > div:nth-of-type(1),
          .lowerBody .coursesSection > div:nth-of-type(2) > div:nth-of-type(1) {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 5px;
          }

          /* Profile section */
          .lowerBody .profileSection > div:nth-of-type(2) > div:nth-of-type(2) {
            font-size: 0.9rem;
            font-weight: 400;
          }

          /* Employment section */
          .lowerBody .employmentSection .employmentHistoryItem,
          .lowerBody .educationSection .educationSectionItem,
          .lowerBody .internshipSection .internshipSectionItem,
          .lowerBody .coursesSection .coursesSectionItem {
            margin: 10px 0px 20px 0px;
          }

          .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(1),
          .lowerBody .educationSection .educationSectionItem > div:nth-of-type(1),
          .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(1),
          .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(1) {
            font-size: 0.95rem;
            font-weight: 500;
          }

          .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(2),
          .lowerBody .educationSection .educationSectionItem > div:nth-of-type(2),
          .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(2),
          .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(2) {
            font-weight: 200;
            font-size: 0.85rem;
            margin: 5px 0px;
          }

          .lowerBody .employmentSection .employmentHistoryItem > div:nth-of-type(3),
          .lowerBody .educationSection .educationSectionItem > div:nth-of-type(3),
          .lowerBody .internshipSection .internshipSectionItem > div:nth-of-type(3),
          .lowerBody .coursesSection .coursesSectionItem > div:nth-of-type(3) {
            font-size: 0.9rem;
            font-weight: 400;
          }

          /* Right section */
          .detailsSection > div:nth-of-type(1) {
            font-weight: 500;
          }
          .detailsSection > div:nth-of-type(2) {
            font-size: 0.9rem;
            font-weight: 400;
            margin: 10px 0px;
            line-height: 1.25rem;
          }

          .detailsSection > div:nth-of-type(3) {
            color: darkcyan;
            font-size: 0.9rem;
            font-weight: 500;
            margin: 10px 0px;
          }

          .detailsSection > div:nth-of-type(4) {
            font-size: 0.9rem;
            font-weight: 400;
            margin: 10px 0px;
            line-height: 1.25rem;
          }

          .detailsSection > div:nth-of-type(4) > div:nth-of-type(1) {
            font-weight: 500;
          }

          .detailsSection > div:nth-of-type(5) {
            font-size: 0.9rem;
            font-weight: 400;
            margin: 10px 0px;
            line-height: 1.25rem;
          }

          .detailsSection > div:nth-of-type(5) > div:nth-of-type(1) {
            font-weight: 500;
          }

          .linksSection {
            margin: 20px 0px;
          }

          .linksSection > div:nth-of-type(1) {
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 5px;
          }

          .linksSection .linkItem {
            color: darkcyan;
            font-weight: 500;
            margin: 0px 10px 5px 0px;
          }

          .linksSection .linkItem a {
            text-decoration: none;
            font-size: 0.9rem;
          }

          .linksSection > div:nth-of-type(2) {
            display: flex;
            flex-wrap: wrap;
          }

          /* For the skill section */
          .skillSection {
            margin: 20px 0px;
            font-size: 0.9rem;
            font-weight: 400;
          }

          .skillSection > div:nth-of-type(1) {
            font-weight: 500;
          }

          .skillSection .skillItem {
            margin: 10px 0px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: flex-start;
          }

          .skillSection .skillItem > div:nth-of-type(2), .skillSection .skillItem > hr {
            display: inline-block;
            height: 1px;
            border: 0px;
            background-color: white;
            outline: none;
            margin-top: 5px;
            border-bottom: 3px solid black;
          }

          /* For the hobbies */
          .hobbiesSection {
            margin: 20px 0px;
            font-size: 0.9rem;
            font-weight: 400;
            line-height: 1.25rem;
          }

          .hobbiesSection > div:nth-child(1) {
            font-weight: 500;
            margin-bottom: 5px;
          }
        </style>
      </head>
      <body>
        <section id="resume" class="resume">
          <div class="header">
            <div>${resume.name}</div>
            <div>${resume.profession}</div>
          </div>
          <div class="lowerBody">
            <section>
              <!-- profile section -->
              ${
                resume.profile
                  ? `
                <div class="profileSection">
                <div><span class="material-symbols-outlined"> person </span></div>
                <div>
                  <div>Profile</div>
                  <div>
                  ${resume.profile}
                  </div>
                </div>
              </div>
              `
                  : ""
              }
              <!-- employment history section -->
              ${
                resume.employmentHistory.length !== 0
                  ? `
                  <div class="employmentSection">
                  <div><span class="material-symbols-outlined"> work </span></div>
                  <div>
                    <div>Employment History</div>
                    <div>
                      <!-- list all the employment history here -->
                      ${resume.employmentHistory
                        .map((p) => {
                          return `
                        <div class="employmentHistoryItem">
                        <div>${p.job} at ${p.employer} , ${p.city}</div>
                        <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                        <div>${p.description}</div>
                        </div>
                        `;
                        })
                        .join(" ")}
                    </div>
                  </div>
                </div>
              `
                  : ""
              }
              ${
                resume.education.length !== 0
                  ? `
              <div class="educationSection">
              <div><span class="material-symbols-outlined"> school </span></div>
              <div>
                <div>Education</div>
                <div>
                  <!-- list all the employment history here -->
                  ${resume.education
                    .map((p) => {
                      return `
                    <div class="educationSectionItem">
                    <div>${p.degree}, ${p.school}, ${p.city}</div>
                    <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                    <div></div>
                    </div>
                    `;
                    })
                    .join(" ")}
                </div>
              </div>
              </div>
              `
                  : ""
              }

              <!-- Internship -->
              ${
                resume.internship.length !== 0
                  ? `
              <div class="internshipSection">
              <div><span class="material-symbols-outlined"> group </span></div>
              <div>
                <div>Internship</div>
                <div>
                  <!-- list all the employment history here -->
                  ${resume.internship
                    .map((p) => {
                      return `
                    <div class="internshipSectionItem">
                    <div>${p.job}, ${p.employer}, ${p.city}</div>
                    <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                    <div>${p.description}</div>
                    </div>
                    `;
                    })
                    .join(" ")}
                </div>
              </div>
              </div>
              `
                  : ""
              }

              <!-- Courses Section -->
              ${
                resume.courses.length !== 0
                  ? `
              <div class="coursesSection">
              <div><span class="material-symbols-outlined"> book </span></div>
              <div>
                <div>Courses</div>
                <div>
                  <!-- list all the employment history here -->
                  ${resume.courses
                    .map((p) => {
                      return `
                    <div class="coursesSectionItem">
                    <div>${p.course}, ${p.institution}</div>
                    <div>${formatDate(p.startDate, timeZone)} -- ${formatDate(p.endDate, timeZone)}</div>
                    <div></div>
                    </div>
                    `;
                    })
                    .join(" ")}
                </div>
              </div>
            </div>
              `
                  : ""
              }
            </section>
            <section>
              <!-- details -->
              <div class="detailsSection">
                <div>Details</div>
                <div>
                  ${resume.details.address} <br />
                  ${resume.details.city} ${resume.details.postalCode} <br />
                  ${resume.details.country} <br />
                  ${resume.details.phone}
                </div>
                <div>${resume.details.email}</div>
                <div>
                  <div>Date/Place of birth</div>
                  <div>
                    ${formatDate(resume.details.dateOfBirth, timeZone)} <br />
                    ${resume.details.placeOfBirth}
                  </div>
                </div>
                <div>
                  <div>Driving license</div>
                  <div>${resume.details.drivingLicense}</div>
                </div>
              </div>

              <!-- links sections -->
              ${
                resume.links.length !== 0
                  ? `
              <div class="linksSection">
              <div>Links</div>
              <div>
                ${resume.links
                  .map((p) => {
                    return `<div class="linkItem"><a href="">${p.url}</a></div>`;
                  })
                  .join(" ")}
              </div>
              </div>
              `
                  : ""
              }

              <!-- skills section -->
              ${
                resume.skills.length !== 0
                  ? `
              <div class="skillSection">
              <div>Skills</div>
              <div>
                ${resume.skills
                  .map((p) => {
                    return `
                  <div class="skillItem">
                  <div>${p.skill}</div>
                  <div style="width: ${p.level}%"></div>
                 </div>
                  `;
                  })
                  .join(" ")}
              </div>
              </div>
              `
                  : ""
              }

              <!-- hobbies section -->
              ${
                resume.hobbies
                  ? `
              <div class="hobbiesSection">
              <div>Hobbies</div>
              <div>
                ${resume.hobbies}
              </div>
              </div>
              `
                  : ""
              }

              <!-- Languages section -->
              ${
                resume.languages.length !== 0
                  ? `
              <div class="skillSection">
              <div>Language</div>
              <div>
                ${resume.languages
                  .map((p) => {
                    return `
                  <div class="skillItem">
                  <div>${p.language}</div>
                  <div style="width: ${p.level}%"></div>
                  </div>
                  `;
                  })
                  .join(" ")}
              </div>
              </div>
              `
                  : ""
              }
            </section>
          </div>
        </section>
      </body>
    </html>
  `;
}

/** Generate the PDF */
export async function generatePDF(timeZone: string, resume: Resume, resumeMaker: null | ((resume: Resume, timeZone: string) => string) = null, resumeUUID?: string) {
  const browser = (await BrowserPuppeteer.browser()).browserInstance;
  const page = await browser.newPage();
  const resumeHTML = resumeMaker ? resumeMaker(resume, timeZone) : generateResumeHTML(resume, timeZone);
  await page.setContent(resumeHTML);
  await page.waitForNetworkIdle({ idleTime: 1000 });

  // upload to the public folder we are inside the src and public folder is one step above
  const publicFolderPath = path.join(process.cwd(), "public");
  // create the resume.pdf file in the public folder
  const resumeName = resumeUUID ? resumeUUID : v4();
  const resumeFilePath = path.join(publicFolderPath, `${resumeName}.pdf`);
  await page.pdf({ path: resumeFilePath, format: "A4", printBackground: true });
  return `${resumeName}.pdf`;
}

/** Generate the Image of the resume */
export async function generateImage(timeZone: string, resume: Resume, resumeMaker: null | ((resume: Resume, timeZone: string) => string) = null, resumeUUID?: string) {
  const browser = (await BrowserPuppeteer.browser()).browserInstance;
  const page = await browser.newPage();
  const resumeHTML = resumeMaker ? resumeMaker(resume, timeZone) : generateResumeHTML(resume, timeZone);
  await page.setContent(resumeHTML);
  await page.waitForSelector(".resume");
  await page.waitForNetworkIdle({ idleTime: 1000 });
  const elementHandle = await page.$(".resume");
  // upload to the public folder we are inside the src and public folder is one step above
  const publicFolderPath = path.join(process.cwd(), "public");
  // create the resume.pdf file in the public folder
  const resumeName = resumeUUID ? resumeUUID : v4();
  const resumeFilePath = path.join(publicFolderPath, `${resumeName}.png`);
  await elementHandle.screenshot({ path: resumeFilePath });
  return `${resumeName}.png`;
}

export class BrowserPuppeteer {
  static #instance: BrowserPuppeteer;
  public browserInstance: any;

  private constructor() {}

  public static async browser() {
    if (!BrowserPuppeteer.#instance) {
      BrowserPuppeteer.#instance = new BrowserPuppeteer();
      console.log("IS_SERVERLESS", process.env.IS_SERVERLESS);
      if (process.env.IS_SERVERLESS === "true") {
        const puppeteer = require("puppeteer-core");
        const chromium = require("@sparticuz/chromium");
        BrowserPuppeteer.#instance.browserInstance = await puppeteer.launch({
          args: chromium.args,
          defaultViewport: chromium.defaultViewport,
          executablePath: await chromium.executablePath(),
          headless: chromium.headless,
        });
      } else {
        const puppeteer = require("puppeteer");
        BrowserPuppeteer.#instance.browserInstance = await puppeteer.launch({
          args: ["--no-sandbox", "--disable-setuid-sandbox"],
          headless: true,
        });
      }
    }

    return BrowserPuppeteer.#instance;
  }
}

/** Sanitize the prisma data */
export function sanitizePrismaData(data: any): any {
  if (typeof data === "object" && data !== null) {
    const sanitizedData: any = {};

    Object.keys(data).forEach((key) => {
      if (key !== "createdAt" && key !== "updatedAt" && key !== "id") {
        sanitizedData[key] = sanitizePrismaData(data[key]);
      }
    });

    return sanitizedData;
  }

  return data;
}

export function isWeakPassword(password: string): boolean {
  // Criteria for a weak password
  const minLength = 8; // Minimum password length
  const maxRepeatedCharacters = 2; // Maximum number of repeated characters allowed

  // Check password length
  if (password.length < minLength) {
    return true; // Password is too short
  }

  // Check for repeated characters
  const repeatedCharacters = new Map<string, number>();
  for (const char of password) {
    const count = repeatedCharacters.get(char) || 0;
    repeatedCharacters.set(char, count + 1);
    if (count + 1 > maxRepeatedCharacters) {
      return true; // Password has too many repeated characters
    }
  }

  // Password is considered strong
  return false;
}

function isNumeric(value: any) {
  // Use isNaN() to check if the value is NaN (Not a Number)
  // Use Number() to attempt to convert the value to a number
  // If the converted value is NaN, it means the value is not a valid number
  return !isNaN(Number(value));
}

export function razorpayPrice(price: number) {
  if (!price) return 0;
  if (!isNumeric(price)) return 0;
  return +(+price * 100).toFixed(0);
}


/**
 * Create localtunnel for the testing webhook
 */
export async function createLocaltunnel(port: number) {
  const localtunnel = require("localtunnel");
  const tunnel = await localtunnel({ port: port, subdomain: "cvworld-cvw-cvw-cvw-cvw" });

  tunnel.on("error", (err: any) => {
    console.log(err);
  });

  tunnel.on("close", () => {
    console.log("Tunnel closed");
  });

  return tunnel.url;
}

/** Get the base URL of server */
export function getBaseUrl() {
  const baseUrl = process.env.BASE_URL;
  return baseUrl;
}

export function getResourcePath(url: string) {
  const resourcesPath = getBaseUrl() + "/" + url;
  return resourcesPath;
}

/**
 *
 *
 *
 */
export async function addTemplate(name: string, price: number) {
  const loadTemplate = async () => {
    const template = await import(`./templates/${name}`);
    return template as unknown as { default: (resume: Resume) => string };
  };

  const template = await loadTemplate();

  const moment = require("moment-timezone");
  const timeZone: string = "Asia/Kolkata";

  // generate the dummy template for the preview
  const dummyResume = generateDummyResume();
  const imageUrl = await generateImage(timeZone, dummyResume, template.default);

  // add to the database template marketplace
  const prisma = PrismaClientSingleton.prisma;

  // if already created then update
  const oldTemplate = await prisma.resumeTemplateMarketplace.findFirst({
    where: {
      name: name,
    },
  });

  if (oldTemplate) {
    await prisma.resumeTemplateMarketplace.update({
      where: {
        id: oldTemplate.id,
      },
      data: {
        name: name,
        price: price,
        previewImgUrl: imageUrl,
      },
    });
  } else {
    await prisma.resumeTemplateMarketplace.create({
      data: {
        name: name,
        price: price,
        previewImgUrl: imageUrl,
      },
    });
  }

  return imageUrl;
}
