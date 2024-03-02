# Understand your environment variables

| Key                                     | Description                                              | Value                                                    |
|-----------------------------------------|----------------------------------------------------------|----------------------------------------------------------|
| MYSQL_ROOT_PASSWORD                    | Password for MySQL server administrative access.         | root                                                     |
| MYSQL_DATABASE                         | Name of the MySQL database.                              | cvworld                                                  |
| MYSQL_USER                             | Username for MySQL database access.                      | cvworld                                                  |
| MYSQL_PASSWORD                         | Password for MySQL database access.                      | cvworld                                                  |
| MYSQL_PORT                             | Port number for the MySQL server.                        | 3306                                                     |
| MYSQL_HOST                             | Hostname or IP address of the MySQL server.              | localhost                                                |
| DATABASE_URL                           | URL for connecting to the MySQL database.                | mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DATABASE} |
| ADMIN_EMAIL                            | Email address of the administrator.                     | prasenjeetsymon@gmail.com                               |
| ADMIN_PASSWORD                         | Password for the administrator account.                 | spiderman@134$                                           |
| ADMIN_NAME                             | Name of the administrator.                               | Prasenjeet Kumar                                         |
| JWT_SECRET                             | Secret key for generating JWT tokens.                   | secret                                                   |
| JWT_EXPIRES_IN                         | Expiration time for JWT tokens.                          | 1d                                                       |
| JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN    | Expiration time for password reset JWT tokens.           | 1d                                                       |
| PLAN_NAME                              | Name of the premium plan.                                | Premium                                                  |
| PLAN_PRICE                             | Price of the premium plan (in INR).                      | 499                                                      |
| PLAN_DESCRIPTION                      | Description of the premium plan.                         | This is a premium plan                                   |
| PLAN_CURRENCY                         | Currency used for pricing the premium plan.             | INR                                                      |
| RAZORPAY_KEY_ID                        | Public key for Razorpay integration.                     | rzp_test_FaATrPhyri9oHO                                  |
| RAZORPAY_KEY_SECRET                    | Secret key for Razorpay integration.                     | ZDLjszKDiZaahHgGtjb7TAqJ                                |
| RAZORPAY_WEBHOOK_SECRET               | Secret key for validating Razorpay webhooks.            | cvworld                                                  |
| IS_SERVERLESS                          | Boolean indicating if the application is serverless.     | false                                                    |
| APPLICATION_NAME                       | Name of the application.                                 | CVWorld                                                  |
| FORGOT_PASSWORD_TOKEN_EXPIRES_IN       | Expiration time for forgot password tokens.              | 30m                                                      |
| BASE_URL                               | Base URL of the server application.                             | http://localhost:8081                                    |
| PASSWORD_RESET_BASE_LINK               | Base link for password reset emails. ( client )                    | http://localhost:64667/#/                               |
| RESEND_API_KEY                         | API key for sending resend emails.                       | re_BDQaEQAR_JiwnvMNG9J91iwQfgwq7p7sK                    |
| RESEND_FROM                            | Sender email address for resend emails.                 | onboarding@resend.dev                                    |
| API_INFO_KEY                          | Key for accessing API information.                       | apikey                                                   |

