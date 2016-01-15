Dockerized PHP development stack [![Build Status](https://travis-ci.org/lagun4ik/docker-php-dev-stack.svg)](https://travis-ci.org/lagun4ik/docker-php-dev-stack)
--------------------------

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
#Show
docker ps | grep -P "\s([^\s]*nginx[^\s]*$)|(NAMES$)"

#Restart
docker exec -t YOU_CONTAINER_NAME bash -c "service nginx restart"
```

## Look at the logs

```bash
# all logs
docker-compose -p php-dev-stack logs

# specific service
docker-compose -p php-dev-stack logs nginx
```
