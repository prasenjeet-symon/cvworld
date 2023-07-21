import { BrowserPuppeteer, createLocaltunnel, createServer, signUpAdmin } from "./utils";

const PORT = process.env.PORT ? +process.env.PORT : 8080;
const app = createServer();

signUpAdmin()
  .then(async () => {
    // await createPremiumTemplatePlan();
  })
  .then(() => {
    return BrowserPuppeteer.browser();
  })
  .catch((err) => console.log(err))
  .finally(() => {
    app.listen(PORT, async () => { 
      console.log(`Server is running on port ${PORT}`);
      const tunnelURL = await createLocaltunnel(PORT);
      console.log(`Tunnel URL: ${tunnelURL}`);
    });
  });
