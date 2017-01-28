Dockerized PHP stack [![Build Status](https://travis-ci.org/lagun4ik/docker-php-dev-stack.svg)](https://travis-ci.org/lagun4ik/docker-php-dev-stack)
--------------------------

* [Nginx](https://github.com/lagun4ik/docker-nginx-pagespeed)
* [PHP7.0-FPM](https://github.com/lagun4ik/docker-php7-fpm)
* [MariaDB](https://hub.docker.com/_/mariadb/)
* [MongoDB](https://hub.docker.com/_/mongo/)
* [Memcached](https://hub.docker.com/_/memcached/)
* [Redis](https://hub.docker.com/_/redis/)
* [Let's Encrypt docker container](https://github.com/lagun4ik/docker-letsencrypt-webroot)

## Utilities
Install phpMyAdmin, phpMemcachedAdmin, pagespeedAdmin, phpRedisAdmin
```bash
./setup-utilities.sh
```
Go to `http://you_server_ip/`


## Installed php modules
```
amqp
bcmath
bz2
Core
ctype
curl
date
dom
fileinfo
filter
gd
gettext
gmp
hash
iconv
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
odbc
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
PDO_ODBC
pdo_pgsql
pdo_sqlite
redis
Reflection
session
SimpleXML
soap
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlrpc
xmlwriter
Zend OPcache
zip

[Zend Modules]
Xdebug
Zend OPcache
```
