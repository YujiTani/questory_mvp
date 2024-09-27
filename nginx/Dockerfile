FROM nginx:1.21

WORKDIR /etc/nginx

COPY nginx.conf ./
COPY ssl ./ssl

RUN chmod 644 ssl/questory.com.key && chmod 600 ssl/questory.com.pem

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]