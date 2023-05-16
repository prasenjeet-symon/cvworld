import express from "express";
import router from "./api";
require("dotenv").config();
const cors = require("cors");

const mysql = require("mysql2");
const app = express();
const port = 3000;
const dbHost = process.env.DB_HOST;
const dbUser = process.env.DB_USER;
const dbPassword = process.env.DB_PASSWORD;
const dbDatabase = process.env.DB_DATABASE;
app.use(cors());
app.use(express.json());
app.use("/api", router);

app.get("/", (req, res) => {
  res.send("Hello, Express");
});

// Create a connection to the MySQL server
const connection = mysql.createConnection({
  host: dbHost,
  user: dbUser,
  password: dbPassword,
  database: dbDatabase,
});

// Connect to the database
connection.connect((error: any) => {
  if (error) {
    console.error("Error connecting to MySQL:", error);
    return;
  }
  console.log("Connected to MySQL database!");
  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });
});
