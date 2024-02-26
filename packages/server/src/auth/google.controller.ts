import axios from "axios";
import { Request, Response } from "express";
import { v4 } from "uuid";
import { IGoogleAuthTokenResponse } from "../schema";
import { Logger, PrismaClientSingleton, createJwt, generateUniqueUsername, isDefined } from "../utils";

export class GoogleController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Signup with google
   */
  public async signupWithGoogle() {
    const validator = new GoogleValidator(this.req, this.res);
    if (!validator.validateSignupWithGoogle()) {
      Logger.getInstance().logError("signupWithGoogle :: Error validating method signupWithGoogle");
      return;
    }

    const { token, timeZone } = this.req.body;
    const googleAuthTokenResponse = await this.verifyGoogleAuthToken(token);
    if (!googleAuthTokenResponse) {
      this.res.status(400).json({ error: "Invalid google auth token" });
      Logger.getInstance().logError("signupWithGoogle :: Invalid google auth token");
      return;
    }

    const { userId, email, name, profile } = googleAuthTokenResponse;
    const userName = generateUniqueUsername(name);
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (oldUser) {
      this.res.status(400).json({ error: "User with same email already exists. Please login" });
      Logger.getInstance().logError("signupWithGoogle :: User already exists");
      return;
    }

    const newUser = await prisma.user.create({
      data: {
        email: email,
        fullName: name,
        reference: v4(),
        password: v4(),
        profilePicture: profile,
        timeZone: timeZone || null,
        userName: userName,
      },
      select: {
        reference: true,
        email: true,
        fullName: true,
        profilePicture: true,
        timeZone: true,
        userName: true,
      },
    });

    const tokenFinal = await createJwt(newUser.reference, newUser.email, false, null, newUser.timeZone);

    this.res.status(200).json({
      token: tokenFinal,
      userId: newUser.reference,
      email: newUser.email,
      fullName: newUser.fullName,
      timeZone: newUser.timeZone,
      userName: newUser.userName,
    });

    //TODO : Send greeting email to the user
    Logger.getInstance().logSuccess("signupWithGoogle :: Login successful");
    return;
  }

  /**
   *
   * Google signin
   */
  public async signinWithGoogle() {
    const validator = new GoogleValidator(this.req, this.res);
    if (!validator.validateSigninWithGoogle()) {
      Logger.getInstance().logError("signinWithGoogle :: Error validating method signinWithGoogle");
      return;
    }

    const { token } = this.req.body;
    const googleAuthTokenResponse = await this.verifyGoogleAuthToken(token);
    if (!googleAuthTokenResponse) {
      this.res.status(400).json({ error: "Invalid google auth token" });
      Logger.getInstance().logError("signinWithGoogle :: Invalid google auth token");
      return;
    }

    const { userId, email, name, profile } = googleAuthTokenResponse;
    const prisma = PrismaClientSingleton.prisma;

    const oldUser = await prisma.user.findUnique({
      where: { email: email },
    });

    if (!oldUser) {
      this.res.status(404).json({ error: "User with associated email not found. Please signup to continue" });
      Logger.getInstance().logError("signinWithGoogle :: User not found");
      return;
    }

    const tokenFinal = await createJwt(oldUser.reference, oldUser.email, false, null, oldUser.timeZone);

    this.res.status(200).json({
      token: tokenFinal,
      userId: oldUser.reference,
      email: oldUser.email,
      fullName: oldUser.fullName,
      timeZone: oldUser.timeZone,
      userName: oldUser.userName,
    });

    Logger.getInstance().logSuccess("signinWithGoogle :: Login successful");
    return;
  }

  /**
   *
   * Verify google auth token
   *
   */
  async verifyGoogleAuthToken(token: string): Promise<IGoogleAuthTokenResponse | null> {
    try {
      const [tokenInfoResponse, userInfoResponse] = await Promise.all([
        axios.get("https://oauth2.googleapis.com/tokeninfo", {
          params: {
            access_token: token,
          },
        }),
        axios.get("https://www.googleapis.com/oauth2/v1/userinfo", {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }),
      ]);

      const payload = tokenInfoResponse.data;
      const userId = payload.sub;
      const email = payload.email;
      const userProfile = userInfoResponse.data;
      const name = userProfile.name;
      const picture = userProfile.picture;

      return { success: true, userId, email, name, profile: picture };
    } catch (error: any) {
      Logger.getInstance().logError(error);
      return null;
    }
  }
}

/**
 *
 *
 *  Google Validator
 */
class GoogleValidator {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate signup with google
   */
  public validateSignupWithGoogle() {
    const { token, timeZone } = this.req.body;

    if (token === undefined || timeZone === undefined) {
      this.res.status(400).json({ error: "token, timeZone are required" });
      Logger.getInstance().logError("validateSignupWithGoogle :: token, timeZone are required");
      return false;
    }

    if (!isDefined(token) || !isDefined(timeZone)) {
      this.res.status(400).json({ error: "token, timeZone are required" });
      Logger.getInstance().logError("validateSignupWithGoogle :: token, timeZone are required");
      return false;
    }

    return true;
  }

  /**
   *
   *
   * Validate signin with google
   */
  public validateSigninWithGoogle() {
    const { token } = this.req.body;

    if (token === undefined) {
      this.res.status(400).json({ error: "token is required" });
      Logger.getInstance().logError("validateSigninWithGoogle :: token is required");
      return false;
    }

    if (!isDefined(token)) {
      this.res.status(400).json({ error: "token is required" });
      Logger.getInstance().logError("validateSigninWithGoogle :: token is required");
      return false;
    }

    return true;
  }
}
