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

