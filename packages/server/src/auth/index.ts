import express from "express";
import { signInAdmin, signInOrSignUpWithGoogle, signInWithEmailAndPassword, signUpWithEmailAndPassword } from "../utils";

const router = express.Router();

router.get("/", (req, res) => {
  res.send({ message: "Authentication working..." });
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

export default router;
