import { Body, Head, Heading, Html, render } from "@react-email/components";
import React from "react";

const emailStyle = {
  fontFamily: "Arial, sans-serif",
  color: "#333",
  lineHeight: "1.6",
};

const headingStyle = {
  fontSize: "24px",
  fontWeight: "bold",
  color: "#007bff",
  marginBottom: "20px",
};

const paragraphStyle = {
  fontSize: "16px",
  marginBottom: "20px",
};

const linkStyle = {
  color: "#007bff",
  textDecoration: "none",
};

export function SuccessfulPasswordResetEmail(props: { userFullName: any; platformName: string }) {
  const { userFullName, platformName } = props;

  return (
    <Html lang="en">
      <Head title="Password Successfully Reset" />
      <Body style={emailStyle}>
        <Heading style={headingStyle}>Password Successfully Reset</Heading>
        <p style={paragraphStyle}>Dear {userFullName},</p>
        <p style={paragraphStyle}>Your password for your account at {platformName} has been successfully reset.</p>
        <p style={paragraphStyle}>If you initiated this password reset, you can disregard this email.</p>
        <p style={paragraphStyle}>If you did not request this change, please contact our support team immediately.</p>
        <p style={paragraphStyle}>Thank you for using {platformName}!</p>
        <p style={paragraphStyle}>
          Best regards,
          <br />
          The {platformName} Team
        </p>
      </Body>
    </Html>
  );
}

const renderSuccessfulPasswordResetEmail = (userFullName: any, platformName: string) => render(<SuccessfulPasswordResetEmail userFullName={userFullName} platformName={platformName} />);

export default renderSuccessfulPasswordResetEmail;
