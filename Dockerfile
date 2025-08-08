FROM nginx:latest

# Remove the default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy your app's static files to the nginx served directory
COPY app/public/ /usr/share/nginx/html/

# Expose port 80 to the outside
EXPOSE 80

# Start nginx 
CMD ["nginx", "-g", "daemon off;"]
