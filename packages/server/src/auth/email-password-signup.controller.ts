import { Request, Response } from "express";
import { v4 } from "uuid";
import { ApiEvent, ApiEventNames } from "../events";
import { Logger, PrismaClientSingleton, createJwt, getClientLocation, hashPassword, isDefined, isTokenActive, isValidEmail } from "../utils";

export class EmailPasswordSignUpController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Is username already taken
   */
  public async isUsernameTaken() {
    const validator = new EmailPasswordSignUpValidator(this.req, this.res);
    if (!validator.validateIsUsernameTaken()) {
      Logger.getInstance().logError("isUsernameTaken :: Error validating method isUsernameTaken");
      return;
    }

    const { username } = this.req.body;
    const prisma = PrismaClientSingleton.prisma;

    const user = await prisma.user.findFirst({
      where: {
        userName: username,
      },
    });

    if (user) {
      this.res.status(400).json({ error: "Username already taken" });
      Logger.getInstance().logError("isUsernameTaken :: Username already taken");
      return;
    }

    this.res.status(200).json({ message: "Username is available" });
    Logger.getInstance().logSuccess("isUsernameTaken :: Username is available");
    return;
  }

  /**
   *
   * Is token active
   */
  public async isTokenActive() {
    const validator = new EmailPasswordSignUpValidator(this.req, this.res);
    if (!validator.validateIsTokenActive()) {
      Logger.getInstance().logError("isTokenActive :: Error validating method isTokenActive");
      return;
    }

    const { token } = this.req.body;
    const isTokenAct = isTokenActive(token);

    if (!isTokenAct.isActive) {
      this.res.status(401).json({ error: "Token expired" });
      Logger.getInstance().logError("isTokenActive :: Token expired");
      return;
    }

    this.res.status(200).json({ message: "Token is active" });
    Logger.getInstance().logSuccess("isTokenActive :: Token is active");
    return;
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
    ApiEvent.getInstance().dispatch(ApiEventNames.SEND_GREETING_EMAIL, { email: email });

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
   * Validate is username already taken
   */
  public validateIsUsernameTaken(): boolean {
    const { username } = this.req.body;

    if (username === undefined) {
      this.res.status(400).json({ error: "username is required" });
      Logger.getInstance().logError("username is required");
      return false;
    }

    if (!isDefined(username)) {
      this.res.status(400).json({ error: "username is required" });
      Logger.getInstance().logError("username is required");
      return false;
    }

    return true;
  }

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

  /**
   *
   * Validate is token active
   */
  public validateIsTokenActive(): boolean {
    const { token } = this.req.body;

    if (token === undefined) {
      this.res.status(400).json({ error: "token is required" });
      Logger.getInstance().logError("validateIsTokenActive :: token is required");
      return false;
    }

    if (!isDefined(token)) {
      this.res.status(400).json({ error: "token is required" });
      Logger.getInstance().logError("validateIsTokenActive :: token is required");
      return false;
    }

    return true;
  }
}
