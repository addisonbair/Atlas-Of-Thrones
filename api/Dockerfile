FROM node:8.16.0-alpine

WORKDIR /atlas
EXPOSE 5000
CMD ["npm", "run", "start"]

COPY package* ./
RUN npm install
COPY . .
