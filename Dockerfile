FROM httpd:2.4

COPY config/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY config/httpd-default.conf /usr/local/apache2/conf/extra/httpd-default.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["httpd-foreground"]
