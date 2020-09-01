FROM nginx:alpine
RUN mkdir /var/nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./cors_support /etc/nginx/cors_support
COPY ./ssl.conf /etc/nginx/ssl.conf
COPY ./index.html /usr/share/nginx/html/index.html
COPY ./certs/ /certs/
