import renderWelcomeEmail from "../emails/greeting.email";
import { ApiEventData } from "../schema";
import { Logger, PrismaClientSingleton, isDefined, isValidEmail, sendEmail } from "../utils";

export class AuthenticationEvent {
  private data: ApiEventData;

  constructor(data: ApiEventData) {
    this.data = data;
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
}
