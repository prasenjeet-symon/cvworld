import renderPasswordResetEmail from "../emails/forgot-password.email";
import renderWelcomeEmail from "../emails/greeting.email";
import renderSuccessfulPasswordResetEmail from "../emails/password-reset-done.email";
import { ApiEventData } from "../schema";
import { Logger, PrismaClientSingleton, isDefined, isValidEmail, sendEmail } from "../utils";

export class AuthenticationEvent {
  private data: ApiEventData;

  constructor(data: ApiEventData) {
    this.data = data;
  }

  /**
   *
   *
   * Send password reset successful
   */
  public async sendPasswordResetSuccessful() {
    const validator = new AuthenticationEventValidator(this.data);
    if (!validator.validatePasswordResetSuccess()) {
      Logger.getInstance().logError("sendPasswordResetSuccessful :: Error validating method sendPasswordResetSuccessful");
      return;
    }

    const { email } = this.data.data;
    const { APPLICATION_NAME } = process.env;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (!oldUser) {
      Logger.getInstance().logError("sendPasswordResetSuccessful :: User not found");
      return;
    }

    // Send email
    const template = renderSuccessfulPasswordResetEmail(oldUser.fullName, APPLICATION_NAME!);

    const emailSentId = await sendEmail({
      subject: "Password reset successful",
      to: email,
      html: template,
    });

    if (!emailSentId) {
      Logger.getInstance().logError("sendPasswordResetSuccessful :: Email not sent");
      return;
    }

    Logger.getInstance().logSuccess("sendPasswordResetSuccessful :: Email sent");
    return;
  }

  /**
   *
   * Send password reset link
   */
  public async sendPasswordResetLink() {
    const validator = new AuthenticationEventValidator(this.data);
    if (!validator.validateSendPasswordResetLink()) {
      Logger.getInstance().logError("sendPasswordResetLink :: Error validating method sendPasswordResetLink");
      return;
    }

    const { email, link } = this.data.data;
    const { APPLICATION_NAME } = process.env;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (!oldUser) {
      Logger.getInstance().logError("sendPasswordResetLink :: User not found");
      return;
    }

    // Send email
    const template = renderPasswordResetEmail(oldUser.fullName, link, APPLICATION_NAME!);

    const emailSentId = await sendEmail({
      subject: "Reset your password",
      to: email,
      html: template,
    });

    if (!emailSentId) {
      Logger.getInstance().logError("sendPasswordResetLink :: Email not sent");
      return;
    }

    Logger.getInstance().logSuccess("sendPasswordResetLink :: Email sent");
    return;
  }

  /**
   *
   * Send greeting email
   */
  public async sendGreetingEmail() {
    const validator = new AuthenticationEventValidator(this.data);
    if (!validator.validateSendGreetingEmail()) {
      Logger.getInstance().logError("sendGreetingEmail :: Error validating method sendGreetingEmail");
      return;
    }

    const { email } = this.data.data;
    const { BASE_URL, APPLICATION_NAME } = process.env;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (!oldUser) {
      Logger.getInstance().logError("sendGreetingEmail :: User not found");
      return;
    }

    const template = renderWelcomeEmail(oldUser.fullName, APPLICATION_NAME!, BASE_URL!);

    // Send email
    const emailSentId = await sendEmail({
      subject: "Welcome to " + APPLICATION_NAME!,
      to: email,
      html: template,
    });

    if (!emailSentId) {
      Logger.getInstance().logError("sendGreetingEmail :: Email not sent");
      return;
    }

    Logger.getInstance().logSuccess("sendGreetingEmail :: Email sent");
    return;
  }
}
/**
 *
 *
 * Validator
 */

class AuthenticationEventValidator {
  private data: ApiEventData;

  constructor(data: ApiEventData) {
    this.data = data;
  }

  /**
   *
   * Validate greeting email
   */
  public validateSendGreetingEmail() {
    const { email } = this.data.data;
    const { BASE_URL, APPLICATION_NAME } = process.env;

    if (email === undefined) {
      Logger.getInstance().logError("validateSendGreetingEmail :: Email not found");
      return false;
    }

    if (!isDefined(email)) {
      Logger.getInstance().logError("validateSendGreetingEmail :: Email not found");
      return false;
    }

    if (!isValidEmail(email)) {
      Logger.getInstance().logError("validateSendGreetingEmail :: Invalid email");
      return false;
    }

    if (BASE_URL === undefined || APPLICATION_NAME === undefined) {
      Logger.getInstance().logError("validateSendGreetingEmail :: BASE_URL or APPLICATION_NAME not set in .env");
      return false;
    }

    if (!isDefined(BASE_URL) || !isDefined(APPLICATION_NAME)) {
      Logger.getInstance().logError("validateSendGreetingEmail :: BASE_URL or APPLICATION_NAME not set in .env");
      return false;
    }

    return true;
  }

  /**
   *
   *
   * Validate password reset
   */
  public validateSendPasswordResetLink() {
    const { email, link } = this.data.data;

    if (email === undefined || link === undefined) {
      Logger.getInstance().logError("validateSendPasswordResetLink :: Email or link not found");
      return false;
    }

    if (!isDefined(email) || !isDefined(link)) {
      Logger.getInstance().logError("validateSendPasswordResetLink :: Email or link not found");
      return false;
    }

    if (!isValidEmail(email)) {
      Logger.getInstance().logError("validateSendPasswordResetLink :: Invalid email");
      return false;
    }

    const { APPLICATION_NAME } = process.env;

    if (APPLICATION_NAME === undefined) {
      Logger.getInstance().logError("validateSendPasswordResetLink :: APPLICATION_NAME not set in .env");
      return false;
    }

    if (!isDefined(APPLICATION_NAME)) {
      Logger.getInstance().logError("validateSendPasswordResetLink :: APPLICATION_NAME not set in .env");
      return false;
    }

    return true;
  }

  /**
   *
   * Validate password reset success
   */
  public validatePasswordResetSuccess() {
    const { email } = this.data.data;

    if (email === undefined) {
      Logger.getInstance().logError("validatePasswordResetSuccess :: Email not found");
      return false;
    }

    if (!isDefined(email)) {
      Logger.getInstance().logError("validatePasswordResetSuccess :: Email not found");
      return false;
    }

    if (!isValidEmail(email)) {
      Logger.getInstance().logError("validatePasswordResetSuccess :: Invalid email");
      return false;
    }

    return true;
  }
}
