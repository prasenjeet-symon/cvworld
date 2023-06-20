import { BrowserPuppeteer, createServer, signUpAdmin } from "./utils";

const PORT = 8080;
const app = createServer();

signUpAdmin().then(()=>{
  return BrowserPuppeteer.browser()
}).finally(() => {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
});
