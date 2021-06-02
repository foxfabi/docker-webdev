FROM nginx:latest
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
