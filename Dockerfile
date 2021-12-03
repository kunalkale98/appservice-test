# Using Node 12 buster-slim as builder
FROM node:12-buster-slim as builder

# Copying everything to the container
COPY . /usr/app/

# Setting WORKDIR
WORKDIR /usr/app/

# Creating a Production Build
# RUN npm ci --only=production && npm run build
RUN npm install && npm run build

# Using NGINX Unprivileged as the Web Server
FROM nginxinc/nginx-unprivileged

# Replacing NGINX's default.conf with the custom one for this application
COPY default.conf /etc/nginx/conf.d/default.conf

# Copying build files from the builder to App's root dir
COPY --from=builder /usr/app/build/ /usr/share/nginx/html/

# Copying SSL files from the builder to NGINX's dir
#COPY --from=builder /usr/app/deploy/ssl-certs/STAGE_PLACEHOLDER/ /usr/share/nginx/

# Setting WORKDIR
WORKDIR /usr/share/nginx/
 
# Exposing port 8080 of the container
# Cannot run on port below 1024 in non-root mode 
EXPOSE 8080
