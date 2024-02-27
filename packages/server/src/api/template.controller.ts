import { Request, Response } from "express";
import { Logger, PrismaClientSingleton, isDefined } from "../utils";

export class TemplateController {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Mark template favorite
   */
  public async markTemplateFavorite() {
    const validator = new TemplateControllerValidators(this.req, this.res);
    if (!validator.validateMarkTemplateFavorite()) {
      Logger.getInstance().logError("markTemplateFavorite:: Error validating method markTemplateFavorite");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;
    const { templateName } = this.req.body; // Template name is always unique

    // Template is already created at this point in time
    // Just connect the template to the user
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        favouriteTemplates: {
          connect: {
            name: templateName,
          },
        },
      },
    });

    this.res.status(200).json({ message: "Template marked as favorite successfully" });
    Logger.getInstance().logSuccess("markTemplateFavorite:: markTemplateFavorite success");
    return;
  }

  /**
   *
   * Get application's templates
   */
  public async getTemplates() {
    const validator = new TemplateControllerValidators(this.req, this.res);
    if (!validator.validateGetTemplates()) {
      Logger.getInstance().logError("getTemplates:: Error validating method getTemplates");
      return;
    }

    const email = this.res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const templates = await prisma.resumeTemplateMarketplace.findMany();

    if (templates.length === 0) {
      this.res.status(404).json({ message: "Templates not found" });
      Logger.getInstance().logError("getTemplates:: Templates not found");
      return;
    }

    this.res.json(templates);
    Logger.getInstance().logSuccess("getTemplates:: getTemplates success");
    return;
  }
}

/**
 *
 *
 * Validators
 */
class TemplateControllerValidators {
  private req: Request;
  private res: Response;

  constructor(req: Request, res: Response) {
    this.req = req;
    this.res = res;
  }

  /**
   *
   * Validate get templates
   */
  public validateGetTemplates() {
    return true;
  }

  /**
   *
   * Validate mark template favorite
   */
  public validateMarkTemplateFavorite() {
    const { templateName } = this.req.body;

    if (templateName === undefined) {
      this.res.status(400).json({ error: "templateName field is missing" });
      Logger.getInstance().logError("validateMarkTemplateFavorite:: templateName field is missing");
      return false;
    }

    if (!isDefined(templateName)) {
      this.res.status(400).json({ error: "templateName field is missing" });
      Logger.getInstance().logError("validateMarkTemplateFavorite:: templateName field is missing");
      return false;
    }

    return true;
  }
}
