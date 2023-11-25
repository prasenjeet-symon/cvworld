FROM ghcr.io/cirruslabs/flutter:stable AS build-env

# Run flutter doctor and enable web
RUN flutter doctor
RUN flutter config --enable-web

# Set the working directory inside the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.* ./

# Run Flutter package get to fetch the dependencies
RUN flutter pub get

# Copy the rest of the project files to the container
COPY . .

# Build the Flutter web application
RUN flutter build web --release --web-renderer=auto

# Cleanup unused files
RUN rm -rf /app/build/web/*.dart

# Use a lightweight web server to serve the built files
FROM nginx:alpine

# Copy the built web files to the nginx HTML directory
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy nginx.conf if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for web traffic
EXPOSE 8080:80

# Health check
HEALTHCHECK CMD wget --quiet --tries=1 --spider http://localhost:80 || exit 1

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]
