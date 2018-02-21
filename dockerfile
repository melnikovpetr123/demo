FROM php:7.0-apache
RUN apt-get update
RUN apt-get install wget -y
RUN wget https://raw.githubusercontent.com/melnikovpetr123/demo/master/index.php
EXPOSE 80