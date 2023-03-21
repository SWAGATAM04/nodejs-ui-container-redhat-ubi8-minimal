FROM redhat/ubi8-minimal
RUN microdnf install  nginx curl jq which git procps-ng -y \
 && chmod -R g+w /run \
 && chmod -R g+w /var \
 && chmod -R g+w /var/log \
 && chmod -R g+w /var/log/nginx 


#Installing Node
RUN curl -sL https://rpm.nodesource.com/setup_16.x |  bash -
RUN microdnf  module enable nodejs:16 \
 && microdnf install -y nodejs

COPY ./nginx.conf /etc/nginx/nginx.conf

WORKDIR /app
# Install app dependencies
COPY package.json package-lock.json   /app/
RUN cd /app && npm set progress=false && npm install
# Copy project files into the docker image
COPY .  /app
RUN cd /app && npm run build

COPY ./dist/angular-nginx-docker/ /usr/share/nginx/html

#COPY --from=builder /app/dist/angular-nginx-docker /usr/share/nginx/html

# Default command to run our server!
CMD ["nginx", "-g", "daemon off;"]

