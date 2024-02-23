import { Request, Response } from "express";
import { Logger, PrismaClientSingleton, createJwt, hashPassword, isDefined, isTokenActive, isValidEmail } from "../utils";

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
        userName: true,
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
      userName: user.userName,
    });

    Logger.getInstance().logSuccess("signinWithEmailPassword:: Login successful");
    return;
  }

  /**
   *
   *
   * Forgot password
   */
  public async forgotPassword() {
    const validator = new EmailPasswordSignInValidator(this.req, this.res);
    if (!validator.validateForgotPassword()) {
      Logger.getInstance().logError("forgotPassword:: Error validating method forgotPassword");
      return;
    }

    const { email } = this.req.body;
    const { JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN, PASSWORD_RESET_BASE_LINK } = process.env;
    const prisma = PrismaClientSingleton.prisma;

    const user = await prisma.user.findUnique({
      where: { email: email },
      select: {
        reference: true,
        email: true,
        timeZone: true,
      },
    });

    if (!user) {
      this.res.status(404).json({ error: "User with associated email not found" });
      Logger.getInstance().logError("forgotPassword:: User not found");
      return;
    }

    const token = await createJwt(user.reference, user.email, false, JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN, user.timeZone);
    const link = `${PASSWORD_RESET_BASE_LINK}/?token=${token}&userId=${user.reference}`;
    // TODO: Sent email with a link to reset password where query param contains token and userId

    this.res.status(200).json({ message: `Password reset link has been sent to ${email}` });
    return;
  }

  /**
   *
   * Reset password
   */
  public async resetPassword() {
    const validator = new EmailPasswordSignInValidator(this.req, this.res);
    if (!validator.validateResetPassword()) {
      Logger.getInstance().logError("resetPassword:: Error validating method resetPassword");
      return;
    }

    const { userId, token, password } = this.req.body;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { reference: userId },
    });

    if (!oldUser) {
      this.res.status(404).json({ error: "User not found" });
      Logger.getInstance().logError("resetPassword:: User not found");
      return;
    }

    const isTokenAct = isTokenActive(token);

    if (!isTokenAct.isActive) {
      this.res.status(400).json({ error: "Invalid token" });
      Logger.getInstance().logError("resetPassword:: Invalid token");
      return;
    }

    // If same user token or not
    const { payload } = isTokenAct;
    const { userId: tokenUserId } = payload;

    if (tokenUserId !== userId) {
      this.res.status(400).json({ error: "Invalid token" });
      Logger.getInstance().logError("resetPassword:: Invalid token");
      return;
    }

    const hashedPassword = hashPassword(password);

    // Update user's password
    await prisma.user.update({
      where: { reference: userId },
      data: { password: hashedPassword },
    });

    const jwtToken = await createJwt(oldUser.reference, oldUser.email, false, null, oldUser.timeZone);

    this.res.status(200).json({
      token: jwtToken,
      userId: oldUser.reference,
      email: oldUser.email,
      fullName: oldUser.fullName,
      timeZone: oldUser.timeZone,
      userName: oldUser.userName,
    });

    // TODO: Send email regarding password reset success

    Logger.getInstance().logSuccess("resetPassword:: Password reset successful");
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

    const { JWT_SECRET } = process.env;

    if (JWT_SECRET === undefined) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("JWT_SECRET is not set in .env");
      return false;
    }

    if (!isDefined(JWT_SECRET)) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("JWT_SECRET is not set in .env");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate forgot password
   */
  public validateForgotPassword(): boolean {
    const { email } = this.req.body;

    if (email === undefined) {
      this.res.status(400).json({ error: "email is required" });
      Logger.getInstance().logError("validateForgotPassword:: email is required");
      return false;
    }

    if (!isDefined(email)) {
      this.res.status(400).json({ error: "email is required" });
      Logger.getInstance().logError("validateForgotPassword:: email is required");
      return false;
    }

    if (!isValidEmail(email)) {
      this.res.status(400).json({ error: "Invalid email" });
      Logger.getInstance().logError("validateForgotPassword:: Invalid email");
      return false;
    }

    const { JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN } = process.env;

    if (JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN === undefined) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateForgotPassword:: JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN is not set in .env");
      return false;
    }

    if (!isDefined(JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN)) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateForgotPassword:: JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN is not set in .env");
      return false;
    }

    const { JWT_SECRET } = process.env;

    if (JWT_SECRET === undefined) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateForgotPassword:: JWT_SECRET is not set in .env");
      return false;
    }

    if (!isDefined(JWT_SECRET)) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateForgotPassword:: JWT_SECRET is not set in .env");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate reset password
   */
  public validateResetPassword(): boolean {
    const { userId, token, password } = this.req.body;

    if (userId === undefined || token === undefined || password === undefined) {
      this.res.status(400).json({ error: "userId, token, password are required" });
      Logger.getInstance().logError("validateResetPassword:: userId, token, password are required");
      return false;
    }

    if (!isDefined(userId) || !isDefined(token) || !isDefined(password)) {
      this.res.status(400).json({ error: "userId, token, password are required" });
      Logger.getInstance().logError("validateResetPassword:: userId, token, password are required");
      return false;
    }

    const { JWT_SECRET } = process.env;

    if (JWT_SECRET === undefined) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateResetPassword:: JWT_SECRET is not set in .env");
      return false;
    }

    if (!isDefined(JWT_SECRET)) {
      this.res.status(500).json({ error: "Internal server error" });
      Logger.getInstance().logError("validateResetPassword:: JWT_SECRET is not set in .env");
      return false;
    }

    return true;
  }
}
