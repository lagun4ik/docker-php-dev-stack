Dockerized PHP development stack [![Build Status](https://travis-ci.org/lagun4ik/docker-php-dev-stack.svg)](https://travis-ci.org/lagun4ik/docker-php-dev-stack)
--------------------------

* [Nginx 1.9.9](http://nginx.org/)
 * [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed)
 * [nginx-upload-progress-module](https://github.com/masterzen/nginx-upload-progress-module)
* [PHP7.0-FPM](http://php-fpm.org/)
 * [Installed php modules](#installed-php-modules)
 * [Composer](https://getcomposer.org/)
* [MariaDB 3.2](https://mariadb.org/)
* [MongoDB 3.2](http://www.mongodb.org/)
* [Memcached 1.4.25](http://memcached.org/)
* [Redis 3.0.6](http://redis.io/)

## Database

If you need only one database, use the appropriate branches.
```bash
#mysql
git clone -b mysql https://github.com/lagun4ik/docker-php-dev-stack.git

#mongo
git clone -b mysql https://github.com/lagun4ik/docker-php-dev-stack.git

#mongo and mysql
git clone -b master https://github.com/lagun4ik/docker-php-dev-stack.git
```

## Run

```bash
docker-compose -p php-dev-stack up -d
```

## Show services

```bash
docker-compose -p php-dev-stack ps
```

## Composer

Enter the name of your container.

```bash
#Show container names
docker ps | grep -P "\s([^\s]*php-fpm[^$]\s)|(IMAGE)"

#Run bash in container
docker run --rm -it \
  --volumes-from php-dev-stack_data -w /var/www/ \
  YOU_IMAGE_NAME bash
```


## Restart nginx

Enter the name of your container.

```bash
#Show image name
docker ps | grep -P "\s([^\s]*nginx[^\s]*$)|(NAMES$)"

#Restart nginx
docker exec -t YOU_CONTAINER_NAME bash -c "service nginx restart"
```

## Look at the logs

```bash
# all logs
docker-compose -p php-dev-stack logs

# specific service
docker-compose -p php-dev-stack logs nginx
```

## Connect to DB
Use `mongo` or `mysql` as a host for the database connection.
```php
$dbh = new PDO('mysql:host=mysql;dbname=' . $db, $user, $pass);
```
```php
$manager = new MongoDB\Driver\Manager("mongodb://mongo");
```

## Memcached and Redis docker memory limit

Change the value `mem_limit` in the file `docker-compose.yml`.

## Installed php modules
```
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
gd
gettext
hash
iconv
intl
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
recode
redis
Reflection
session
SimpleXML
sockets
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib
Zend OPcache
```

##Thanks
@ProPheT777
