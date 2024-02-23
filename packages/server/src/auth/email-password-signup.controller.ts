import { Request, Response } from "express";
import { v4 } from "uuid";
import { Logger, PrismaClientSingleton, createJwt, getClientLocation, hashPassword, isDefined, isValidEmail } from "../utils";

export class EmailPasswordSignUpController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Signup with email and password
   */
  public async signupWithEmailPassword() {
    const validator = new EmailPasswordSignUpValidator(this.req, this.res);
    if (!validator.validateSignupWithEmailPassword()) {
      Logger.getInstance().logError("Error validating method signupWithEmailPassword");
      return;
    }

    const { email, password, fullName, timeZone, userName } = this.req.body as {
      email: string;
      password: string;
      fullName: string;
      timeZone: string;
      userName: string;
    };

    const prisma = PrismaClientSingleton.prisma;

    // If the user already exit then return error
    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (oldUser) {
      this.res.status(400).json({ error: "User with same email already exists. Please login" });
      Logger.getInstance().logError("signupWithEmailPassword:: User already exists");
      return;
    }

    const hashedPassword = hashPassword(password);
    const ipLocation = await getClientLocation(this.req);
    const timeZoneName = timeZone ? timeZone : ipLocation?.timezone ? ipLocation.timezone : "IST";

    // Create new user
    const newUser = await prisma.user.create({
      data: {
        email: email,
        password: hashedPassword,
        fullName: fullName,
        reference: v4(),
        timeZone: timeZoneName,
        userName: userName,
      },
      select: {
        reference: true,
        email: true,
        fullName: true,
        timeZone: true,
        userName: true,
      },
    });

    const token = await createJwt(newUser.reference, newUser.email, false, null, timeZoneName);

    this.res.status(200).json({
      token: token,
      userId: newUser.reference,
      email: newUser.email,
      fullName: newUser.fullName,
      timeZone: newUser.timeZone,
      userName: newUser.userName,
    });

    Logger.getInstance().logSuccess("signupWithEmailPassword:: User created successfully");

    // TODO: send welcome email
    // TODO: send email to verify email

    return;
  }
}
/**
 *
 *
 *
 * Validator class
 */
class EmailPasswordSignUpValidator {
  constructor(private req: Request, private res: Response) {}

  /**
   *
   * Validate signup with email and password
   */
  public validateSignupWithEmailPassword(): boolean {
    const { email, password, fullName, timeZone, userName } = this.req.body;

    if (email === undefined || password === undefined || fullName === undefined || timeZone === undefined || userName === undefined) {
      this.res.status(400).json({ error: "email, password, fullName, timeZone, userName are required" });
      Logger.getInstance().logError("email, password, fullName, timeZone, userName are required");
      return false;
    }

    if (!isDefined(email) || !isDefined(password) || !isDefined(fullName) || !isDefined(timeZone) || !isDefined(userName)) {
      this.res.status(400).json({ error: "email, password, fullName, timeZone, userName are required" });
      Logger.getInstance().logError("email, password, fullName, timeZone, userName are required");
      return false;
    }

    if (!isValidEmail(email)) {
      this.res.status(400).json({ error: "Invalid email" });
      Logger.getInstance().logError("Invalid email");
      return false;
    }

    return true;
  }
}
