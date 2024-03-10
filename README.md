## Understand your environment variables


| Key                                     | Description                                              |
|-----------------------------------------|----------------------------------------------------------|
| MYSQL_ROOT_PASSWORD                    | Password for MySQL server administrative access.         |
| MYSQL_DATABASE                         | Name of the MySQL database.                              |
| MYSQL_USER                             | Username for MySQL database access.                      |
| MYSQL_PASSWORD                         | Password for MySQL database access.                      |
| MYSQL_PORT                             | Port number for the MySQL server.                        |
| MYSQL_HOST                             | Hostname or IP address of the MySQL server.              |
| ADMIN_EMAIL                            | Email address of the administrator.                     |
| ADMIN_PASSWORD                         | Password for the administrator account.                 |
| ADMIN_NAME                             | Name of the administrator.                               |
| JWT_SECRET                             | Secret key for generating JWT tokens.                   |
| JWT_EXPIRES_IN                         | Expiration time for JWT tokens.                          |
| JWT_PASSWORD_RESET_TOKEN_EXPIRES_IN    | Expiration time for password reset JWT tokens.           |
| PLAN_NAME                              | Name of the premium plan.                                |
| PLAN_PRICE                             | Price of the premium plan (in INR).                      |
| PLAN_DESCRIPTION                      | Description of the premium plan.                         |
| PLAN_CURRENCY                         | Currency used for pricing the premium plan.             |
| RAZORPAY_KEY_ID                        | Public key for Razorpay integration.                     |
| RAZORPAY_KEY_SECRET                    | Secret key for Razorpay integration.                     |
| RAZORPAY_WEBHOOK_SECRET               | Secret key for validating Razorpay webhooks.            |
| IS_SERVERLESS                          | Boolean indicating if the application is serverless.     |
| APPLICATION_NAME                       | Name of the application.                                 |
| FORGOT_PASSWORD_TOKEN_EXPIRES_IN       | Expiration time for forgot password tokens.              |
| BASE_URL                               | Server URL of the application.                           |
| PASSWORD_RESET_BASE_LINK               | Base link for password reset emails.                    |
| RESEND_API_KEY                         | API key for sending resend emails.                       |
| RESEND_FROM                            | Sender email address for resend emails.                 |
| API_INFO_KEY                          | Key for accessing API information.                       |


>> Make sure you have your .env beside .env.example file in server folder


---

## Deploying the Application in Production Environment

### Step 1: Connect your Linux Machine to GitHub
- **Generate SSH Keys:** Use the command below to generate SSH keys on your Linux machine:
  ```
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
  ```
- **Add SSH Key to GitHub:**
  - Copy the public key using:
    ```
    cat ~/.ssh/id_rsa.pub
    ```
  - Navigate to GitHub settings, locate "SSH and GPG keys," and add the copied key.
- **Test SSH Connection:** Run:
  ```
  ssh -T git@github.com
  ```

### Step 2: Install Docker on your Linux Machine
- **Update Package Index:** Execute:
  ```
  sudo apt-get update
  ```
- **Install Necessary Packages:**
  ```
  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
  ```
- **Add Docker GPG Key:**
  ```
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  ```
- **Set Up Docker Repository:**
  ```
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  ```
- **Update Package Index Again:**
  ```
  sudo apt-get update
  ```
- **Install Docker:**
  ```
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  ```
- **Verify Docker Installation:**
  ```
  sudo docker run hello-world
  ```

### Step 3: Pull your repository to the Linux machine
- **Clone Repository:**
  ```
  cd ~
  git clone git@github.com:iAmPawanBhatia/cvworld.me.git cvworld
  ```

### Step 4: Pull latest release
- **Pull Latest Release:**
  ```
  cd cvworld
  git pull
  ```

### Step 5: Build and Run the Application
- **Build Application:**
  ```
  docker-compose build
  ```
- **Run Application:**
  ```
  docker-compose up -d
  ```

### Step 6: Stopping the Application
- **Stop Application:**
  ```
  docker-compose down
  ```

### Step 7: Running the Latest Version of the Application
- **Pull Latest Version from GitHub:**
  ```
  cd ~
  cd cvworld
  git pull
  ```
- **Update Client and Server:**
  ```
  docker-compose build client
  docker-compose up --no-deps -d client
  docker-compose build server
  docker-compose up --no-deps -d server
  ```

### Step 8: Hard Build and Run Application
- **Delete Existing `cvworld` Folder:**
  ```
  cd ~
  rm -rf cvworld
  ```
- **Pull Latest Version from GitHub:**
  ```
  git clone git@github.com:iAmPawanBhatia/cvworld.me.git cvworld
  ```
- **Stop Running Containers and remove images and volumes:**
  ```
  docker-compose down --rmi all --volumes
  ```
- **Build and Run Containers:**
  ```
  docker-compose build --no-cache
  docker-compose up -d
  ```

These step-by-step instructions will assist you in deploying your application efficiently in a production environment on a Linux machine.

--- 

# API Keys

## Setting Up Production-Ready Resend API Keys and Email Configuration

### Step 1: Sign Up and Log In

1. Go to [Resend](https://resend.com/) and sign up using your desired email ID and password. If you don't have an account, create a new one.

### Step 2: Add Your Domain

1. Once logged in, navigate to the "Domains" section in the dashboard.
2. Click on the "Add Domain" button.
3. A popup will appear; fill in your desired domain name (e.g., "example.com") and click "Add."

### Step 3: Configure DNS Records

1. After adding the domain, you'll see MX record details, TXT record details, and DKIM records.
2. Access your domain provider's dashboard and locate the DNS record configuration page.
3. Add all the DKIM, SPF, and DMARC records provided by Resend.
4. Once added, return to the Resend dashboard and click "VERIFY DNS RECORDS" to ensure everything is correctly configured.

### Step 4: Generate API Key

1. In the Resend dashboard, go to the "API" menu.
2. Click on "Create API key."
3. A popup will appear; choose a name for your API key and click "Add."
4. Once added, copy the API key generated.

### Step 5: Update Environment Variables

1. Open your server's ENV file.
2. Add the copied API key to your ENV file.
3. Ensure that the "RESEND_FROM" variable contains your domain instead of "resend."

### Step 6: Final Configuration

By completing the above steps, you have successfully configured Resend API keys and email for your server. Now, your server is ready to send emails using Resend.

