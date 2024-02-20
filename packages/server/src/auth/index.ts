import express from "express";
import { authenticateUser, isTokenExpired, signInAdmin, signInOrSignUpWithGoogle, signInWithEmailAndPassword, signUpWithEmailAndPassword } from "../utils";
import { EmailPasswordSignInController } from "./email-password-signin.controller";
import { EmailPasswordSignUpController } from "./email-password-signup.controller";

const router = express.Router();

router.get("/", (req, res) => {
  res.send({ message: "Authentication working..." });
});

/** Signup with email and password */
router.post("/sign_up", (req, res) => new EmailPasswordSignUpController(req, res).signupWithEmailPassword());

/** Sign in with email and password */
router.post("/sign_in", (req, res) => new EmailPasswordSignInController(req, res).signinWithEmailPassword());

/** Is token active */
router.post("/is_token_active", (req, res) => {
  const token = req.body.token;

  if (!token) {
    res.status(400).json({ error: "Missing token" });
    return;
  }

  if (isTokenExpired(token)) {
    res.status(401).json({ error: "Token expired" });
    return;
  }

  res.status(200).json({ message: "Token is active" });
});

/** Sign in with Google */
router.post("/continue_with_google", async (req, res) => {
  await signInOrSignUpWithGoogle(req, res);
});

/** Sign in with email and password */
router.post("/sign_in_with_email_and_password", async (req, res) => {
  await signInWithEmailAndPassword(req, res);
});

/** Sign up with email and password  */
router.post("/sign_up_with_email_and_password", async (req, res) => {
  await signUpWithEmailAndPassword(req, res);
});

/** Sign the ADMIN */
router.post("/sign_in_as_admin", async (req, res) => {
  await signInAdmin(req, res);
});

router.post("/session", (req, res) => {
  authenticateUser(req, res, () => {
    const { userId, email, isAdmin } = res.locals;
    res.send({ userId, email, isAdmin });
  });
});

export default router;
