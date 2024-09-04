FROM nginx:1.21

WORKDIR /etc/nginx

COPY nginx.conf ./
COPY ssl ./

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]