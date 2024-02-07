# Use an official Node.js runtime as a base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app


# Install the application dependencies
RUN npm install

# Copy the application files to the working directory
COPY . .

# Expose the port on which the app will run
EXPOSE 3001

# Define the command to run your application
CMD ["node", "server.js"]
