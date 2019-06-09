FROM node:8.16.0-alpine

WORKDIR /atlas
EXPOSE 3000
EXPOSE 8080
CMD ["npm", "run", "dev"]

COPY package* ./
RUN npm install
COPY . .
