import request from "supertest";
import { createServer, signUpAdmin } from "../utils";

describe("Home Test", () => {
  test("GET /server", async () => {
    const response = await request(createServer()).get("/server");
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ message: "Hello World" });
  });

  /** Create admin */
  test("Create Admin", async () => {
    const response = await signUpAdmin();
    // check if the response is string
    expect(typeof response).toBe("string");
  });
});

/** Test Auth Route */
describe("Auth Test", () => {
  test("POST /server/auth", async () => {
    const response = await request(createServer()).get("/server/auth");
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ message: "Authentication working..." });
  });
});

/** Email and password signup */
describe("Signup Test", () => {
  test("POST /server/auth/sign_up_with_email_and_password", async () => {
    const payload = {
      email: "testuser4@gmail.com",
      password: "test",
      name: "testuser",
    };

    const response = await request(createServer()).post("/server/auth/sign_up_with_email_and_password").send(payload);
    expect(response.status).toBe(201);
  });
});

/** Sign in email and password */
describe("Signin Test", () => {
  test("POST /server/auth/sign_in_with_email_and_password", async () => {
    const payload = {
      email: "testuser4@gmail.com",
      password: "test",
    };

    const response = await request(createServer()).post("/server/auth/sign_in_with_email_and_password").send(payload);
    expect(response.status).toBe(200);
  });

  /** Test the admin */
  test("POST /server/auth/sign_in_as_admin", async () => {
    const payload = {
      email: process.env.ADMIN_EMAIL,
      password: process.env.ADMIN_PASSWORD,
    };

    const response = await request(createServer()).post("/server/auth/sign_in_as_admin").send(payload);
    expect(response.status).toBe(200);
  });
});
