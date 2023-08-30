import { BrowserPuppeteer, addTemplate, createPremiumTemplatePlan, createServer, signUpAdmin } from "./utils";
require("dotenv").config();

const PORT = process.env.PORT ? +process.env.PORT : 8081;
const app = createServer();

signUpAdmin()
  .then(() => {
    return createPremiumTemplatePlan();
  })
  .then(() => {
    return BrowserPuppeteer.browser();
  })
  .then((browser) => {
    return new Promise<boolean>((resolve, reject) => {
      setTimeout(async () => {
        await addTemplate("templt_1", 0);
        await addTemplate("templt_p_1", 8000);
        resolve(true);
      }, 5000);
    });
  })
  .catch((err) => console.log(err))
  .finally(() => {
    app.listen(PORT, async () => {
      console.log(`Server is running on port ${PORT}`);
    });
  });
