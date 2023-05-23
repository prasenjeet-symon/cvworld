# Use the official Node.js 14.x image as the base
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the application source code to the container
COPY . .

# Expose the port that the Express server listens on
EXPOSE 3000

# Start the server
CMD [ "npm", "start" ]
