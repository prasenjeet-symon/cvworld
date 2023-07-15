import { BrowserPuppeteer, createPremiumTemplatePlan, createServer, createTemplatesInitial, signUpAdmin } from "./utils";

const PORT = 8080;
const app = createServer();

signUpAdmin()
  .then(async () => {
    await createPremiumTemplatePlan();
    await createTemplatesInitial();
  })
  .then(() => {
    return BrowserPuppeteer.browser();
  }).catch((err)=> console.log(err))
  .finally(() => {
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  });
