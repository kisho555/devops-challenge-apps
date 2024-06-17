# Use the official Node.js image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to work directory
COPY webapp/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY webapp/ .

# Expose port 3000 (or the port your app runs on)
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
