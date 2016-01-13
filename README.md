Dockerized PHP development stack
--------------------------

##php7, nginx1.9, MySQL (MariaDB), MongoDB, Redis, Memcached

**PHP:** 7.0.2 with redis mongodb memcached composer

**Nginx:** 1.9.9 with pagespeed_module upload-progress-module

**MySQL:** 10.1

**MongoDB:** 3.2.1

**Redis:** 3.0.6

**Memcached:** 1.4.25


## Run

```bash
docker-compose -p php-dev-stack  up -d
```

## Show services

```bash
docker-compose -p php-dev-stack ps
```

## Composer

```bash
docker run --rm -it --volumes-from php-dev-stack_data -w /var/www/ php-dev-stack_php-fpm bash
```

## Look at the logs

```bash
# all logs
docker-compose -p php-dev-stack logs

# specific service
docker-compose -p php-dev-stack logs nginx
```

##Thanks
@ProPheT777