# Development Roadmap
## Milestone 1
- [x] Create a new Flutter project
- [x] Create a new express API
- [x] Setup initial development environment for both Flutter and Express API

## Milestone 2
### Express Server
We are using Express server for the backend. For all the API related information please join postman workspace [PostMan](https://galactic-firefly-721755.postman.co/workspace/New-Team-Workspace~82ccca27-da29-4eeb-82f5-f0e810f86662/api/c553235d-2e04-4556-8dce-67627fb9068e)
- [x] Authentication
    <!-- Write small task description -->
    <!-- Is logged in -->
    - [x] Route to check if user is logged in
    <!-- Sign Up with email and password -->
    - [x] Route for signup with email and password
    <!-- Sign In with Email -->
    - [x] Route for signin with email and password
    <!-- Reset password -->
    - [ ] Route for reset password
    <!-- Sign in with google -->
    - [x] Route for signin with google
    <!-- Signup with google -->
    - [x] Route for signup with google
- [x] Resumes
    <!-- Delete resume -->
    - [x] Route to delete resume
    <!-- Update the resume -->
    - [x] Route to update resume
    <!-- Get single generated resume -->
    - [x] Route to get single generated resume
    <!-- Generate the new resume -->
    - [x] Route to generate new resume
    <!-- Get all the generated resumes -->
    - [x] Route to get all the generated resumes
- [x] User Skills
    <!-- Delete user skill -->
    - [x] Route to delete user skill
    <!-- Get user skills -->
    - [x] Route to get user skills
    <!-- Add update user skill -->
    - [x] Route to add update user skill
- [x] User Personal Details
    <!-- Get user details -->
    - [x] Route to get user details
    <!-- add_update_user_details -->
    - [x] Route to add update user details
- [x] User Hobby
    <!-- Add update the hobby of the user -->
    - [x] Route to add update the hobby of the user
    <!-- Get hobby of the user -->
    - [x] Route to get hobby of the user
    <!-- Delete the hobby of the user -->
    - [x] Route to delete the hobby of the user
- [x] Contact Us
    <!-- Add contact us -->
    - [x] Route to add contact us details
- [x] Professional Summary
    <!-- Get professionalSummary of the user -->
    - [x] Route to get professionalSummary of the user
    <!-- Add update the professionalSummary of the user -->
    - [x] Route to add update the professionalSummary of the user
    <!-- Delete the professionalSummary of the user -->
    - [x] Route to delete the professionalSummary of the user
- [x] User Languages
    <!-- Get languages of the user -->
    - [x] Route to get languages of the user
    <!-- Add update the language of the user -->
    - [x] Route to add update the language of the user
    <!-- Delete the language of the user -->
    - [x] Route to delete the language of the user
- [x] User Courses
    <!-- Get all courses of the user -->
    - [x] Route to get all courses of the user
    <!-- Add update the course of the user -->
    - [x] Route to add update the course of the user
    <!-- Delete the course of the user -->
    - [x] Route to delete the course of the user
- [x] User Education
    <!-- Get all educations of the user -->
    - [x] Route to get all educations of the user
    <!-- Add update the education of the user -->
    - [x] Route to add update the education of the user
    <!-- Delete the education of the user -->
    - [x] Route to delete the education of the user
- [x] User Employment
    <!-- Get all employmentHistories of the user -->
    - [x] Route to get all employmentHistories of the user
    <!-- Add update the employmentHistory of the user -->
    - [x] Route to add update the employmentHistory of the user
    <!-- Delete the employmentHistory of the user -->
    - [x] Route to delete the employmentHistory of the user
- [x] User Internship
    <!-- Get all internships of the user -->
    - [x] Route to get all internships of the user
    <!-- Add update the internship of the user -->
    - [x] Route to add update the internship of the user
    <!-- Delete the internship of the user -->
    - [x] Route to delete the internship of the user
- [x] User Websites Links
    <!-- Get all websites of the user -->
    - [x] Route to get all websites of the user
    <!-- Add update the website of the user -->
    - [x] Route to add update the website of the user
    <!-- Delete the website of the user -->
    - [x] Route to delete the website of the user
- [x] User Subscriptions
    <!-- Get all subscriptions of the user -->
    - [x] Route to get all subscriptions of the user
    <!-- Add update the subscription of the user -->
    - [x] Route to add update the subscription of the user
    <!-- Delete the subscription of the user -->
    - [x] Route to delete the subscription of the user
- [x] Users
    <!-- Get user single -->
    - [x] Route to get user single
    <!-- Handles the HTTP POST request to update the user profile picture. -->
    - [x] Route to update the user profile picture

### Flutter Web
- [x] Homepage
    <!-- add header section -->
    - [x] Make new widget to display the website header section
    <!-- make hero section -->
    - [x] Make new widget to display the website hero section
    <!-- make two more sub sections to express what cv world is  -->
    - [x] Make two new widget to display the cv world sub section
    <!-- Make pricing section -->
    - [x] Make new widget to display the pricing section
    <!-- Make footer -->
    - [x] Make new widget to display the footer
- [x] Contact Us Page
    <!-- Make new widget to display the contact us page -->
    - [x] Make new widget to display the contact us page and make it work properly
    <!-- Make a widget to display message sent successfully -->
    - [x] Make a widget to display message sent successfully
- [x] Login Page
    <!-- Make login page  -->
    - [x] Make login page and make it work properly ( email and password based )
    <!-- Make Google login button -->
    - [x] Make Google login button and make it work properly
- [x] Signup Page
    <!-- Make signup page  -->
    - [x] Make signup page and make it work properly ( email and password based )
    <!-- Make Google signup button -->
    - [x] Make Google signup button and make it work properly
- [x] Dashboard Page
    <!-- Make dashboard page -->
    - [x] Make dashboard page
        - This page list all the created resumes of the logged in user and provide the button to create new resume using the master resume.
        - This page also provide the ability to delete any created resume
        - This page also provide the ability to update any created resume
        - This page also provide the ability to view any created resume
        - This page also provide the ability to download any created resume
    - [x] Make dashboard header
        - Using this header logged in user can navigate to account setting page, logout , and back to dashboard page.
- [x] Account Page
    <!-- Make account page -->
    - [x] Make account page
        - This page holds master resume , user can easily edit master resume and all the information saved here will be used at the time of creating new resume from scratch
       - User can view their subscription plan and can change it too.
- [x] Resume maker page
    <!-- Make resume page -->
    - [x] Make resume page
        - This page is used to create new resume from scratch , user can edit already filled details and click a button to generate new resume instantly.
- [x] Resume editor page
    <!-- Make resume editor page -->
    - [x] Make resume editor page
        - This page is used to edit already created resume instantly. User can edit any details and click a button to re-generate resume instantly.
- [x] Resume preview page
    <!-- Make resume preview page -->
    - [x] Make resume preview page
        - This page is used to preview the resume generated by the resume maker page.
        - User can download the resume generated by the resume maker page from this page too as well as navigate to resume editor page.

## Current functionality
The CV World application currently offers the following features and functionality:

- Users can access the CV World homepage.
- Users can create a new account using either their email and password or their Google account.
- During the account creation process, users will be notified if they have chosen a weak password. If the account already exists, users will be redirected to the sign-in page.
- Users can log in to their existing accounts using either their email and password or their Google account.
- If users enter an incorrect password, they will be notified accordingly. If the account does not exist, users will be prompted to create a new account.
- After logging in, users can access the dashboard, where they can view all of their created resumes.
- Users can easily create new resumes and update their master resume. The master resume contains all the current details about the logged-in user, allowing for faster resume creation.
- Users can edit their created resumes, delete them, and download them as PDF files with a single click.
- Users can instantly preview all created resumes within the browser without needing to download them.
- Users can navigate to the account settings page, where they can update their master resume and view their current subscription plan. They also have the ability to upgrade their plan if desired.
- Users can log out from the dashboard using the header section.
Any public user can submit complaints or inquiries using the Contact Us page. The admin will be notified via email about these submissions.

## Missing features
- Users do not have the ability to reset their password if they have created an account using email. This limitation exists because the password reset functionality requires an email to be sent to the user, containing a password reset link. Currently, I have not integrated any email service providers such as SendGrid or MailChimp. I am waiting to set up an account with one of these providers to implement this feature.

- Users are unable to purchase any subscriptions because I do not have a clear understanding of the pricing structure and what should be included in each subscription. This decision is solely based on business considerations, and until I receive specific guidance, I cannot make any conclusions regarding the charging process.

- Users cannot access the social media links as I am missing some of the necessary social links. I am waiting for the complete list of social media links to incorporate them into the application.

- Users are unable to view the "About Us" page as I do not have any information regarding the people associated with the company. I am eagerly waiting for the relevant document or details to create the content for this page.

- The Privacy Policy and Terms and Conditions pages are currently unavailable as I lack the necessary information regarding the company's policies. Once I receive the required information, I will create and include these pages accordingly.

## Milestone 3
In this milestone i am going to build the `Mobile application` and `Admin Dashboard` with operational `payment integration`.

### Pricing Rules
#### Pricing Rules for CV World:

#### Template Options:

Upon signing up, users will have access to both free and premium templates.
Free templates can be used without any additional cost.
Premium templates can be purchased for a price of $1 each.
#### Monthly Subscription:

Users have the option to buy a monthly subscription plan for $9.99.
Once subscribed, users can generate multiple resumes using any premium template available.
There are no restrictions on the number of resumes that can be generated during the subscription period.
#### Template Usage:

With the purchased premium templates, users can generate as many resumes as they need.
#### Download Limit:

There is no restriction on the number of downloads for generated resumes. Users can download their resumes as many times as they want.
#### Subscription Cancellation:

Users have the flexibility to cancel their monthly subscription at any time.
#### Template Purchase:

Once a premium template is bought, it is a one-time purchase and cannot be returned or refunded.
#### Payment Gateway:
CV World utilizes Razorpay as the payment gateway for processing transactions.

### Express API ( Continued )
- [x] Razorpay Webhook
    - [x] Order Paid
        - Using this route user can buy on the go premium template.
    - [x] Subscription Authenticated
        - Using this route user can start the monthly subscription.
    - [x] Subscription Activated
        - Using this route user can start the monthly subscription which was previously paused or canceled.
    - [x] Subscription Charged
        - Using this route user can pay for the monthly subscription every month.
    - [x] Subscription Halted
        - When razorpay was not able to process the payment for any reason this route will be triggered.
    - [x] Subscription Cancelled
        - Using this route user can cancel the monthly subscription.
- [x] Payments
    - [x] Is Bought Template
        - Given the name of the template this route can determine weather that template is bought by the user or not
    - [x] Marketplace templates
        - Will give all the free plus premium templates with status of weather they are bought or not by the user. 
    - [x] create_subscription
        - Using this route we can create subscription link given the plan name to subscribe to. User can use this link to subscribe to the cv world premium plan.
    - [x] Generate Order Premium Template
        - Using this route we can generate order for premium template to be used by the Razorpay.

### Flutter ( client )
- [x] Make market place page
    - Using this page user can easily choose the template to use for resume and also can buy the premium template on the go. This page will also highlight the template that is bought by the user.
- [x] Connect all the payments related routes and finalize the payment integration.
    - Finalize the payment integration using Razorpay.

<!-- Note  -->
> **_NOTE:_** The payment and subscription integration is complete. Website is working properly and user can use this to generate new template by choosing the free templates or can buy the premium templates on the go . User cal also subscribe to the monthly subscription plan to get all the templates.

### Mobile Application
- [x] Make the tutorial page
    - Using this page user can learn how to use the application and it's benefits. usually 3 to 5 slides will be shown.
- [x] Make the sign up page with google and email based authentication.
    - Using this route user can create a new account using either their email and password or their Google account.
- [x] Make the login page with google and email based authentication.
    - Using this route user can log in to their existing accounts using either their email and password or their Google account.
- [x] Make the dashboard page.
    - Using this page user can view all the created resumes. User can delete any created resume. User can view the resume and can download or buy that if template used is premium with monthly subscription.
- [x] Make the resume view page.
    - Using this page user can view all the created resumes in the full screen mode and can also navigate to edit page. User can either download or buy that if template used is premium with no monthly subscription.
- [x] Make the account setting page
    - Using this page user can subscribe to premium plan and can also cancel the plan anytime. User can edit there personal information that can be reused at the time of resume building.

- [x] Make the resume builder page
    - Using this user can easily create and edit the resume quickly.

> Please note that during the testing Mobile Application may work slowly because it is connected to the local server using the Ngrok that is slow most of the time due to high traffic. But on the Production server everything will work lightning fast.
# Technologies stack
- Node.js         
- Express.js       
- Flutter      
- MYSQL      

# Run Application In Production
We are using the Express server on top of `node.js` version `16.X.X`.

To run the server in production environment use the steps discussed below :

## Connect your Linux Machine to GitHub
To connect your Linux machine to GitHub, follow these steps:    
- Generate SSH keys on your Linux machine using the command:
    ```PowerShell
      ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
- Add the SSH key to your GitHub account:
    - Copy the public key using the command:
        ``` PowerShell
        cat ~/.ssh/id_rsa.pub
        ```
    - Go to your GitHub account settings, navigate to "SSH and GPG keys," and click on "New SSH key."
    - Give a title to the SSH key and paste the copied key into the "Key" field.
    - Click "Add SSH key" to save the key to your GitHub account.
- Test the SSH connection:
    - Run the command:
        ```BASH
        ssh -T git@github.com
        ```
    - You should see a success message indicating that you've successfully authenticated with GitHub.

Now your Linux machine is connected to GitHub, allowing you to clone, push, and pull repositories using SSH authentication.

## Install Docker on your Linux Machine
Here are the steps to install Docker on your Linux machine:
 - Update the package index:
    ```bash
    sudo apt-get update
    ```
- Install necessary packages to allow apt to use a repository over HTTPS:
    ```bash
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    ```
- Add the official Docker GPG key:
    ```bash
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    ```
- Set up the Docker repository:
    ```bash
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```
- Update the package index again:
    ```bash
    sudo apt-get update
    ```
- Install Docker:
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```
- Verify that Docker is installed and running:
    ```
    sudo docker run hello-world
    ```
These steps will guide you through the installation of Docker on your Linux machine.

## Pull your repo to the linux machine
Here are the steps to pull your repository to the Linux machine:
- Open a terminal on your Linux machine.
- Navigate to the directory where you want to clone the repository using the cd command. For example:
    ```bash
    cd ~
    ```
- Run the following command to clone the repository:
    ```bash
        git clone git@github.com:iAmPawanBhatia/cvworld.me.git cvworld
    ```
     If you have an SSH key added already, you can use the SSH URL. If not, you can use the HTTPS URL.
- Enter your Git username and password if prompted.
- Wait for the cloning process to complete. Once finished, you will have a local copy of your repository on your Linux machine.

Now you have successfully pulled your repository to your Linux machine. You can navigate into the cloned repository directory using the cd command and start working with your project files.

## Pull latest release 
To pull the latest release of you app use following command
```bash
    cd cvworld
```

```bash
   git pull
```

## Build the application
To build the application all at once just run the following command : 
```BASH
docker-compose build
```

Once the build process is completed which may take some time you start your application using the following command :
```BASH
docker-compose up -d
```

> Awesome you application is up and running

## How to stop the running application 
To stop the running application you can run the following command : 
```BASH
docker-compose down
```

## How to run the latest version of application
Make sure you are in the folder `cvworld` if not then run the following commands :
```BASH
cd ~
```
Then go to the `cvworld` folder :
```BASH
cd cvworld
```

Then pull the latest version from the `GitHub`
```BASH
git pull
```
Once the latest source code is fetched from the `GitHub` run the following commands : 
```BASH
docker-compose build client
```
This command will build the flutter client. To build the express server run the following command:
```BASH
docker-compose build server
```
After the command finish executing it is time to update the running container. To update the client run this command :
```BASH
docker-compose up --no-deps -d client
```
To update the server run this command :
```BASH
docker-compose up --no-deps -d server
```

## Hard build and run application
First of all we need to delete the `cvworld` folder. To delete that use the following command
```BASH
cd ~
```
```BASH
rm -rf cvworld
```

Then pull the latest version from the `GitHub`
```BASH
git clone git@github.com:iAmPawanBhatia/cvworld.me.git cvworld
```
Then goto the cloned folder using following command
```BASH
cd cvworld
```
Stop any running container
```BASH
docker-compose down --rmi all --volumes
```
Once the latest source code is fetched and containers are sopped run the following commands : 
```BASH
docker-compose build --no-cache
```

After the command finish executing it is time to run container. To run containers run this command :
```BASH
docker-compose up -d
```

## Install Local Tunnel For Application & Webhook Testing

1. Open a terminal.

2. Download the Ngrok binary for Linux:

```bash
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
```

3. Extract the downloaded archive:

```bash
unzip ngrok-stable-linux-amd64.zip
```

4. Move the Ngrok binary to a suitable location in your system's PATH:

```bash
sudo mv ngrok /usr/local/bin/
```

5. Make the Ngrok binary executable:

```bash
sudo chmod +x /usr/local/bin/ngrok
```

6. Test the installation:

```bash
ngrok --version
```

You should see the Ngrok version information printed in the terminal.

Ngrok is now installed on your Linux system and ready to be used from the command line.

### Sign in and start the tunnel ( currently using my Account - Prasenjeet Symon )

1. Signin to Ngrok
```BASH
ngrok config add-authtoken 2THw2qEDXP71v5A3rbUtKpJvKVd_pociQgFLVEVdMY4it45x
```
2. Start the tunnel
```BASH
ngrok http --domain=native-humorous-mule.ngrok-free.app 8081
```

### Mobile Application Download Link

[Download CVWORLD Android Application](https://drive.google.com/file/d/1nV2Cw4C35BiIOYUdq5FlZujbNTwTbB9C/view?usp=drive_link)

[Download Version 1.0.1](https://www.dropbox.com/scl/fi/5clx5y7fvt1ymr5k9ib4d/app-release.apk?rlkey=g3z0crupne6zft622bgazqiu3&dl=0 )

[Download Version 1.0.2](https://www.dropbox.com/scl/fi/5clx5y7fvt1ymr5k9ib4d/app-release.apk?rlkey=g3z0crupne6zft622bgazqiu3&dl=0)

[Download Version 1.0.3](https://www.dropbox.com/scl/fi/5clx5y7fvt1ymr5k9ib4d/app-release.apk?rlkey=g3z0crupne6zft622bgazqiu3&dl=0)