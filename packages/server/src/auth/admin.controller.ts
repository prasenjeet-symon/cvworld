import { Request, Response } from "express";
import { Logger, PrismaClientSingleton, createJwt, hashPassword, isDefined, isValidEmail } from "../utils";
import { v4 } from "uuid";

export class AdminController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Signup admin
   */
  static async signupAsAdmin() {
    if (!AdminValidator.validateSignupAsAdmin()) {
      Logger.getInstance().logError("signupAsAdmin :: Error validating method signupAsAdmin");
      return;
    }

    const { ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_NAME } = process.env;
    const userId = v4();
    const prisma = PrismaClientSingleton.prisma;

    const oldAdmin = await prisma.admin.findUnique({
      where: {
        email: ADMIN_EMAIL?.trim(),
      },
    });

    if (oldAdmin) {
      Logger.getInstance().logError("signupAsAdmin :: Admin already exists");
      return;
    }

    // Create new admin
    const newAdmin = await prisma.admin.create({
      data: {
        email: ADMIN_EMAIL?.trim() || "admin@example.com",
        fullName: ADMIN_NAME?.trim() || "Admin",
        password: ADMIN_PASSWORD?.trim() || "adminPassword@134$",
        reference: userId,
        profilePicture: "https://picsum.photos/200",
      },
      select: {
        id: true,
        email: true,
        fullName: true,
        profilePicture: true,
        password: true,
      },
    });

    Logger.getInstance().logSuccess("signupAsAdmin :: Admin created successfully " + "with email: " + newAdmin.email + " and password: " + newAdmin.password);
    return;
  }

  /**
   *
   * Signin as admin
   */
  public async signinAsAdmin() {
    const validator = new AdminValidator(this.req, this.res);
    if (!validator.validateSigninAsAdmin()) {
      Logger.getInstance().logError("signinAsAdmin :: Error validating method signinAsAdmin");
      return;
    }

    const { email, password, timeZone } = this.req.body;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.admin.findUnique({
      where: { email: email },
    });

    if (!oldUser) {
      this.res.status(404).json({ error: "User with associated email not found. Please signup to continue" });
      Logger.getInstance().logError("signinAsAdmin :: User not found");
      return;
    }

    const validPassword = hashPassword(password) === oldUser.password;

    if (!validPassword) {
      this.res.status(400).json({ error: "Wrong password. Please try again" });
      Logger.getInstance().logError("signinAsAdmin :: Invalid password");
      return;
    }

    const token = await createJwt(oldUser.reference, oldUser.email, true, null, timeZone);

    this.res.status(200).json({
      token: token,
      userId: oldUser.reference,
      email: oldUser.email,
      fullName: oldUser.fullName,
      timeZone: timeZone,
      userName: oldUser.reference,
    });

    Logger.getInstance().logSuccess("signinAsAdmin :: Signin success");
    return;
  }
}

/**
 *
 * Validator admin controller
 */
class AdminValidator {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate signin as admin
   */
  public validateSigninAsAdmin() {
    const { email, password, timeZone } = this.req.body;

    if (email === undefined || password === undefined || timeZone === undefined) {
      this.res.status(400).json({ error: "email, password, timeZone are required" });
      Logger.getInstance().logError("validateSigninAsAdmin :: email, password, timeZone are required");
      return false;
    }

    if (!isDefined(email) || !isDefined(password) || !isDefined(timeZone)) {
      this.res.status(400).json({ error: "email, password, timeZone are required" });
      Logger.getInstance().logError("validateSigninAsAdmin :: email, password, timeZone are required");
      return false;
    }

    if (!isValidEmail(email)) {
      this.res.status(400).json({ error: "Invalid email" });
      Logger.getInstance().logError("validateSigninAsAdmin :: Invalid email");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate signup as admin
   */
  public static validateSignupAsAdmin(): boolean {
    const { ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_NAME } = process.env;

    if (ADMIN_EMAIL === undefined || ADMIN_PASSWORD === undefined || ADMIN_NAME === undefined) {
      Logger.getInstance().logError("signupAsAdmin :: ADMIN_EMAIL or ADMIN_PASSWORD or ADMIN_NAME not set in .env");
      return false;
    }

    if (!isDefined(ADMIN_EMAIL) || !isDefined(ADMIN_PASSWORD) || !isDefined(ADMIN_NAME)) {
      Logger.getInstance().logError("signupAsAdmin :: ADMIN_EMAIL or ADMIN_PASSWORD or ADMIN_NAME not set in .env");
      return false;
    }

    if (!isValidEmail(ADMIN_EMAIL)) {
      Logger.getInstance().logError("signupAsAdmin :: ADMIN_EMAIL is not valid");
      return false;
    }

    return true;
  }
}
