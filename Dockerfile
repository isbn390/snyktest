# build stage
FROM node:14-alpine3.11 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG configuration=production
RUN npm run build -- --mode $configuration # production stage
FROM nginx:1-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
