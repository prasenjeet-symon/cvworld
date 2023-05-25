import express, { NextFunction, Request, Response } from "express";
import { v4 } from "uuid";
import router from "./api";
import routerAuth from "./auth";

interface IGoogleAuthTokenResponse {
  userId: string;
  email: string;
  name: string;
  profile: string;
  success: boolean;
}

/** Sign in/ Sign up with google */
export async function signInOrSignUpWithGoogle(req: Request, res: Response): Promise<void> {
  const token = req.headers.google_token as string;
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
    const { PrismaClient } = require("@prisma/client");
    const prisma = new PrismaClient();
    const newUser = await prisma.user.create({
      data: {
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

/** Verify the Google Auth Token */
export async function verifyGoogleAuthToken(token: string): Promise<IGoogleAuthTokenResponse> {
  const GOOGLE_CLIENT_TOKEN = process.env.GOOGLE_CLIENT_TOKEN;
  if (!GOOGLE_CLIENT_TOKEN) {
    throw new Error("GOOGLE_CLIENT_TOKEN not set");
  }

  const { OAuth2Client } = require("google-auth-library");
  const client = new OAuth2Client(GOOGLE_CLIENT_TOKEN);
  const ticket = await client.verifyIdToken({
    idToken: token,
    audience: GOOGLE_CLIENT_TOKEN,
  });

  const payload = ticket.getPayload();
  const userId = payload.sub;
  const email = payload.email;
  const name = payload.name;
  const picture = payload.picture;

  return { success: true, userId, email, name, profile: picture };
}

/** Create the JSON web token */
export async function createJwt(userId: string, email: string, isAdmin: boolean = false): Promise<string> {
  const jwt = require("jsonwebtoken");
  const JWT_SECRET = process.env.JWT_SECRET;
  if (!JWT_SECRET) {
    throw new Error("JWT_SECRET not set");
  }

  return jwt.sign({ userId, email, isAdmin: isAdmin }, JWT_SECRET, { expiresIn: "1h" });
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
  const token = req.headers.authorization; // Example: Bearer <token>

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

/** Do user already exit */
export async function doUserAlreadyExit(email: string): Promise<any> {
  const { PrismaClient } = require("@prisma/client");
  const prisma = new PrismaClient();
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
  });

  return user;
}

/** Do admin user exit */
export async function doAdminUserExit(email: string): Promise<any> {
  const { PrismaClient } = require("@prisma/client");
  const prisma = new PrismaClient();
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

    // check for the requirement
    if (!(name && email && password)) {
      res.status(400).json({ message: "All input is required" });
      return;
    }

    const userAlreadyExit = await doUserAlreadyExit(req.body.email);
    if (userAlreadyExit) {
      res.status(400).json({ message: "User already exit" });
      return;
    }

    const hashedPassword = hashPassword(password);

    // Save the user to the database or perform any desired actions
    const profilePicture = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y";

    const { PrismaClient } = require("@prisma/client");
    const prisma = new PrismaClient();
    await prisma.user.create({
      data: {
        email: email,
        fullName: name,
        profilePicture: profilePicture,
        password: hashedPassword,
        reference: userId,
      },
    });

    // generate JSON Web Token
    const token = await createJwt(userId, email);
    res.status(201).json({ token });
  } catch (error) {
    // Handle any errors that occur during the signup process
    console.error("Error during user signup:", error);
    res.status(500).json({ message: "An error occurred during signup" });
  }
}

/** Sign in the user using email and password */
export async function signInWithEmailAndPassword(req: Request, res: Response) {
  const email = req.body.email;
  const password = req.body.password;

  if (!(email && password)) {
    res.status(400).json({ message: "All input is required" });
    return;
  }

  const oldUser = await doUserAlreadyExit(email);
  if (!oldUser) {
    res.status(400).json({ message: "User does not exit" });
    return;
  }

  const userId = oldUser.reference;
  const passwordOld = oldUser.password;
  const isPasswordCorrect = await comparePasswords(password, passwordOld);
  if (isPasswordCorrect) {
    // create json web token and return
    res.status(200).json({ token: await createJwt(userId, email) });
    return;
  } else {
    // incorrect password
    res.status(400).json({ message: "Incorrect password" });
  }
}

/** Get user by userId */
export async function getUserByUserId(userId: string) {
  const { PrismaClient } = require("@prisma/client");
  const prisma = new PrismaClient();
  const user = await prisma.user.findUnique({
    where: {
      reference: userId,
    },
  });

  return user;
}

/** Configure resume upload */
export function resumeUploadStorage() {
  const multer = require("multer");
  const storage = multer.diskStorage({
    limits: {
      fileSize: 20 * 1024 * 1024, // 20MB in bytes
    },
    destination: (req: any, file: any, cb: any) => {
      cb(null, "uploads"); // Specify the directory where uploaded files will be stored
    },
    filename: (req: any, file: any, cb: any) => {
      cb(null, file.originalname); // Use the original file name as the destination file name
    },
  });

  const upload = multer({ storage });
  return upload;
}

/** Upload the resume on at time */
export async function uploadResume(req: Request, res: Response) {
  const userId = res.locals.userId;
  const email = res.locals.email;
  const user = await getUserByUserId(userId);
  if (!user) {
    res.status(400).json({ message: "User does not exit" });
    return;
  }

  // file uploaded using multer
  // Read the uploaded file as a buffer
  const fs = require("fs");
  const fileBuffer = fs.readFileSync((req as any).file.path);
  // Convert the file buffer to Base64
  const base64Image = fileBuffer.toString("base64");

  // Update the user with the new resume
  const { PrismaClient } = require("@prisma/client");
  const prisma = new PrismaClient();
  // add new resume
  await prisma.resumes.create({
    data: {
      data: base64Image,
      userId: userId,
    },
  });

  // delete the file uploaded
  const fsExtra = require("fs-extra");
  await fsExtra.remove((req as any).file.path);
  // return the updated user
  const updatedUser = await getUserByUserId(userId);
  res.status(200).json({ updatedUser });
}
/**
 *
 * Sign in the admin
 *
 */
export async function signInAdmin(req: Request, res: Response) {
  const email = req.body.email;
  const password = req.body.password;

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
    res.status(400).json({ message: "Incorrect password" });
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
  const { PrismaClient } = require("@prisma/client");
  const prisma = new PrismaClient();
  await prisma.admin.create({
    data: {
      email: email,
      password: hashedPassword,
      fullName: process.env.ADMIN_NAME,
      reference: userId,
    },
  });

  // generate JSON Web Token
  const token = await createJwt(userId, email, true);
  return token;
}

/**
 * Create the server
 */
export function createServer() {
  require("dotenv").config();

  const cors = require("cors");
  const app = express();

  app.use(cors());
  app.use(express.json());
  app.use("/server/auth", routerAuth);
  app.use("/server/api", authenticateUser, router);

  app.get("/server/", (req, res) => {
    res.send({ message: "Hello World" });
  });

  return app;
}

/** Hashing password */
import crypto from "crypto";

const hashPassword = (password: string): string => {
  const hash = crypto.createHash("sha256");
  hash.update(password);
  return hash.digest("hex");
};

const comparePasswords = (plainPassword: string, hashedPassword: string): boolean => {
  const hashedInput = hashPassword(plainPassword);
  return hashedInput === hashedPassword;
};
