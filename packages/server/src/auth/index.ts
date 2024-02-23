import express from "express";
import { authenticateUser } from "../utils";
import { AdminController } from "./admin.controller";
import { EmailPasswordSignInController } from "./email-password-signin.controller";
import { EmailPasswordSignUpController } from "./email-password-signup.controller";
import { GoogleController } from "./google.controller";

const router = express.Router();

/** Home route */
router.get("/", (req, res) => {
  res.send({ message: "Authentication working..." });
});

/** Signup with email and password */
router.post("/sign_up", (req, res) => new EmailPasswordSignUpController(req, res).signupWithEmailPassword());

/** Sign in with email and password */
router.post("/sign_in", (req, res) => new EmailPasswordSignInController(req, res).signinWithEmailPassword());

/** Login with google */
router.post("/google_login", (req, res) => new GoogleController(req, res).signinWithGoogle());

/** Signup with google */
router.post("/google_signup", (req, res) => new GoogleController(req, res).signupWithGoogle());

/** Is token active */
router.post("/is_token_active", (req, res) => new EmailPasswordSignUpController(req, res).isTokenActive());

/** Admin login */
router.post("/admin_signin", async (req, res) => new AdminController(req, res).signinAsAdmin());

router.post("/session", (req, res) => {
  authenticateUser(req, res, () => {
    const { userId, email, isAdmin } = res.locals;
    res.send({ userId, email, isAdmin });
  });
});

export default router;
