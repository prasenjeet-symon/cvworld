import { createServer, signUpAdmin } from "./utils";

const PORT = 80;
const app = createServer();
signUpAdmin().finally(() => {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
});
