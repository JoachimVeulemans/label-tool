# Define base image
FROM node:latest

# Update image and install required packages
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y sqlite3 libsqlite3-dev

# Create required folders
WORKDIR /db
WORKDIR /uploads
WORKDIR /app

# Set project environment variables
ENV DATABASE_FILE_PATH=/db/db.sqlite
ENV UPLOADS_PATH=/uploads

# Set Docker environment variables
ENV PORT=3000
ENV NODE_ENV=production
EXPOSE 3000

# Copy files with dependencies
COPY package.json package.json
COPY yarn.lock yarn.lock
COPY client/package.json client/package.json
COPY client/yarn.lock client/yarn.lock
COPY server/package.json server/package.json
COPY server/yarn.lock server/yarn.lock

# Install dependencies
RUN yarn install
RUN cd client && yarn install
RUN cd server && yarn install

# Copy code into Docker and Build project
COPY . .
RUN cd client && yarn build

# Define command to execute on startup
CMD ["node", "server/src/index.js"]
