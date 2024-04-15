# Stage 1: Build the application
FROM node:14 AS builder

WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install production dependencies
RUN npm install --only=prod

# Install nodemon as a development dependency
RUN npm install --save-dev nodemon@3.1.0

# Copy the entire application directory to the working directory
COPY . .

# Stage 2: Create the production image
FROM node:alpine

WORKDIR /app

# Copy package.json and package-lock.json from the builder stage
COPY --from=builder /app/package.json /app/package-lock.json ./

# Copy the built application files from the builder stage
COPY --from=builder /app ./

# Install only production dependencies
RUN npm install --only=prod

# Set the default command to run the application
CMD ["node", "src/index.js"]
