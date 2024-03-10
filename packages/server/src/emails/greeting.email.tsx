import { Body, Head, Heading, Html, render } from "@react-email/components";
import React from "react";

export function WelcomeEmail(props: { userFullName: any; platformName: string; platformURL: string }) {
  const { userFullName, platformName, platformURL } = props;

  // Define styles
  const styles = {
    body: {
      fontFamily: "Arial, sans-serif",
      color: "#333",
      lineHeight: "1.6"
    },
    heading: {
      fontSize: "24px",
      fontWeight: "bold",
      color: "#007bff",
      marginBottom: "20px"
    },
    paragraph: {
      fontSize: "16px",
      marginBottom: "20px"
    },
    link: {
      color: "#007bff",
      textDecoration: "none"
    }
  };

  return (
    <Html lang="en">
      <Head title={`Welcome to ${platformName}`} />
      <Body style={styles.body}>
        <Heading style={styles.heading}>Welcome to {platformName}!</Heading>
        <p style={styles.paragraph}>Dear {userFullName},</p>
        <p style={styles.paragraph}>We are excited to welcome you to {platformName}! Your journey to a successful career starts here.</p>
        <p style={styles.paragraph}>{platformName} is a premier platform designed to help you craft outstanding resumes and land your dream job efficiently.</p>
        <p style={styles.paragraph}>
          Feel free to explore our tools and resources to create a professional CV that highlights your skills and experiences. If you have any questions, our support team is here to assist you.
        </p>
        <p style={styles.paragraph}>
          Get started by visiting our website:{" "}
          <a href={platformURL} style={styles.link}>
            {platformURL}
          </a>
        </p>
        <p style={styles.paragraph}>Thank you for choosing {platformName}. We look forward to helping you succeed in your career aspirations.</p>
        <p style={styles.paragraph}>
          Best regards,
          <br />
          The {platformName} Team
        </p>
      </Body>
    </Html>
  );
}

const renderWelcomeEmail = (userFullName: any, platformName: string, platformURL: string) => render(<WelcomeEmail userFullName={userFullName} platformName={platformName} platformURL={platformURL} />);

export default renderWelcomeEmail;
