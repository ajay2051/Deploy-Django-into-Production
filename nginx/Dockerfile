FROM nginx:1.25.3-alpine-slim

RUN rm /etc/nginx/conf.d/default.conf  # Removes default nginx conf file
COPY nginx/nginx.conf /etc/nginx/conf.d