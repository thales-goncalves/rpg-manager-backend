FROM node:18.12.1-slim as build

WORKDIR /app
COPY package.json .
COPY  yarn.lock ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine As production

# Copy the bundled code from the build stage to the production image
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist

# Start the server using the production build
EXPOSE 3000
CMD [ "node", "dist/main.js" ]