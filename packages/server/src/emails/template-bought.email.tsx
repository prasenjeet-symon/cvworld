import { Body, Head, Heading, Html, render } from "@react-email/components";
import React from "react";

export function ThankYouEmail(props: { userFullName: string; templateName: string; platformName: string; price: string }) {
  const { userFullName, templateName, platformName, price } = props;

  // Define styles
  const styles = {
    body: {
      fontFamily: "Arial, sans-serif",
      color: "#333",
      lineHeight: "1.6",
    },
    heading: {
      fontSize: "24px",
      fontWeight: "bold",
      color: "#007bff",
      marginBottom: "20px",
    },
    paragraph: {
      fontSize: "16px",
      marginBottom: "20px",
    },
    link: {
      color: "#007bff",
      textDecoration: "none",
    },
  };

  return (
    <Html lang="en">
      <Head title="Thank You for Purchasing Resume Template" />
      <Body style={styles.body}>
        <Heading style={styles.heading}>Thank You for Purchasing a Resume Template from {platformName}!</Heading>
        <p style={styles.paragraph}>Dear {userFullName},</p>
        <p style={styles.paragraph}>
          We want to express our gratitude for purchasing the {templateName} resume template from {platformName}. You paid {price} for it.
        </p>
        <p style={styles.paragraph}>This template is designed to help you create a professional and eye-catching resume that stands out to potential employers.</p>
        <p style={styles.paragraph}>We hope you find this template valuable in advancing your career goals.</p>
        <p style={styles.paragraph}>If you have any questions or need assistance with the template, feel free to reach out to our support team.</p>
        <p style={styles.paragraph}>Thank you again for choosing {platformName} for your resume needs. We wish you all the best in your job search!</p>
        <p style={styles.paragraph}>
          Best regards,
          <br />
          The {platformName} Team
        </p>
      </Body>
    </Html>
  );
}

const renderThankYouEmail = (userFullName: string, templateName: string, platformName: string, price: string) =>
  render(<ThankYouEmail userFullName={userFullName} templateName={templateName} platformName={platformName} price={price} />);

export default renderThankYouEmail;
