# Use the official Node.js 14.x image as the base
FROM node:lts

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json .

# Install the dependencies
RUN npm install

# Install necessary libraries for Puppeteer
RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2

# Set environment variables
ENV NODE_ENV=production

# Copy the Prisma schema and generate the Prisma client
COPY prisma ./prisma
RUN npx prisma generate

# Copy the application source code to the container
COPY . .

# Expose the port that the Express server listens on
EXPOSE 8080:8080

# Build the application
RUN npm run build
