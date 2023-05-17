import express from "express";
import router from "./api";
import routerAuth from "./auth";
import { authenticateUser } from "./utils";
require("dotenv").config();

const cors = require("cors");
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use("/auth", routerAuth);
app.use("/api", authenticateUser, router);

app.get("/", (req, res) => {
  res.send("Hello, Express");
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
