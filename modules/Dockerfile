FROM node:18-alpine

WORKDIR /app

# Copy package.json first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy rest of app files
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
