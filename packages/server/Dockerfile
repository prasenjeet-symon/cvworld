# Use the official Node.js 14.x image as the base
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json .
COPY package-lock.json .

# Install the dependencies
RUN npm install

# Set environment variables
ENV NODE_ENV=production

# Copy the Prisma schema and generate the Prisma client
COPY prisma ./prisma
RUN npx prisma generate

# Copy the application source code to the container
COPY . .

# Expose the port that the Express server listens on
EXPOSE 3000

# Build the application
RUN npm run build
