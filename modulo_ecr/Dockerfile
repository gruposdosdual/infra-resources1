# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy your application files to the Nginx HTML directory
COPY ./app /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Default command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
