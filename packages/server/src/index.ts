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
        await addTemplate("templt_1", 0); // Free
        await addTemplate("templt_p_1", 0000);
        await addTemplate("templt_p_2", 0000);
        await addTemplate("templt_p_3", 0000);
        await addTemplate("templt_p_4", 0000);
        await addTemplate("templt_p_5", 0000);
        await addTemplate("templt_p_6", 0000);
        await addTemplate("templt_p_7", 0000);
        await addTemplate("templt_p_8", 0000);
        await addTemplate("templt_p_9", 0000);
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
