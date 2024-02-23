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

export function PasswordResetEmail(props: { userFullName: any; link: string; platformName: string }) {
  const { userFullName, link, platformName } = props;

  return (
    <Html lang="en">
      <Head title="Password Reset Request" />
      <Body style={emailStyle}>
        <Heading style={headingStyle}>Password Reset Request</Heading>
        <p style={paragraphStyle}>Dear {userFullName},</p>
        <p style={paragraphStyle}>We received a request to reset your password for your account at {platformName}.</p>
        <p style={paragraphStyle}>Please click the following link to reset your password:</p>
        <p style={paragraphStyle}>
          <a href={link} style={linkStyle}>
            {link}
          </a>
        </p>
        <p style={paragraphStyle}>If you did not initiate this request, you can safely ignore this email.</p>
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

const renderPasswordResetEmail = (userFullName: any, link: string, platformName: string) => render(<PasswordResetEmail userFullName={userFullName} link={link} platformName={platformName} />);

export default renderPasswordResetEmail;
