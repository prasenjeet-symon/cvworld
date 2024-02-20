import { Request, Response } from "express";
import { Logger, PrismaClientSingleton, createJwt, hashPassword, isDefined, isValidEmail } from "../utils";

export class EmailPasswordSignInController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Sign in with email and password
   */
  public async signinWithEmailPassword() {
    const validator = new EmailPasswordSignInValidator(this.req, this.res);
    if (!validator.validateSigninWithEmailPassword()) {
      Logger.getInstance().logError("signinWithEmailPassword:: Error validating method signinWithEmailPassword");
      return;
    }

    const { email, password } = this.req.body;
    const prisma = PrismaClientSingleton.prisma;

    const user = await prisma.user.findUnique({
      where: { email: email },
      select: {
        reference: true,
        email: true,
        password: true,
        fullName: true,
        timeZone: true,
      },
    });

    if (!user) {
      this.res.status(404).json({ error: "User with associated email not found. Please signup to continue" });
      Logger.getInstance().logError("signinWithEmailPassword:: User not found");
      return;
    }

    const validPassword = hashPassword(password) === user.password;

    if (!validPassword) {
      this.res.status(400).json({ error: "Wrong password. Please try again" });
      Logger.getInstance().logError("signinWithEmailPassword:: Invalid password");
      return;
    }

    const token = await createJwt(user.reference, user.email, false, null, user.timeZone);

    this.res.status(200).json({
      token: token,
      userId: user.reference,
      email: user.email,
      fullName: user.fullName,
      timeZone: user.timeZone,
    });

    Logger.getInstance().logSuccess("signinWithEmailPassword:: Login successful");
    return;
  }
}
/**
 *
 *
 * Email Password Sign In Validator
 */
class EmailPasswordSignInValidator {
  constructor(private req: Request, private res: Response) {}

  /**
   *
   * Validate signin with email and password
   */
  public validateSigninWithEmailPassword(): boolean {
    const { email, password } = this.req.body;

    if (email === undefined || password === undefined) {
      this.res.status(400).json({ error: "email, password are required" });
      Logger.getInstance().logError("email, password are required");
      return false;
    }

    if (!isDefined(email) || !isDefined(password)) {
      this.res.status(400).json({ error: "email, password are required" });
      Logger.getInstance().logError("email, password are required");
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
