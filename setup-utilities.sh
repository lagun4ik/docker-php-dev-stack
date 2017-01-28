#!/usr/bin/env bash

echo "Set data patch (./data):"
read DATA_PATCH

if [[ "$DATA_PATCH" = "" ]]
then
  DATA_PATCH="./data"
fi

htpasswd -c $DATA_PATCH/nginx/.htpasswd root

git clone https://github.com/codeb2cc/phpMemcachedAdmin $DATA_PATCH/www/localhost/phpMemcachedAdmin
sed -i "s/127\.0\.0\.1/memcached/g" $DATA_PATCH/www/localhost/phpMemcachedAdmin/Config/Memcache.php

sed -i "s/#//g" $DATA_PATCH/nginx/localhost.conf
sed -i "s/deny/#deny/g" $DATA_PATCH/nginx/localhost.conf

wget https://github.com/phpmyadmin/phpmyadmin/archive/RELEASE_4_4_15_2.zip
unzip RELEASE_4_4_15_2.zip -d $DATA_PATCH/www/localhost
mv $DATA_PATCH/www/localhost/phpmyadmin-RELEASE_4_4_15_2 $DATA_PATCH/www/localhost/phpmyadmin
rm RELEASE_4_4_15_2.zip
mv $DATA_PATCH/www/localhost/phpmyadmin/config.sample.inc.php $DATA_PATCH/www/localhost/phpmyadmin/config.inc.php

sed -i -r "s/$cfg\['blowfish_secret'\] = ''/$cfg\['blowfish_secret'\] = '$(openssl rand -base64 32)'/g" $DATA_PATCH/www/localhost/phpmyadmin/config.inc.php
sed -i -r "s/localhost/mysql/g" $DATA_PATCH/www/localhost/phpmyadmin/config.inc.php

git clone https://github.com/ErikDubbelboer/phpRedisAdmin.git $DATA_PATCH/www/localhost/phpredisadmin
git clone https://github.com/nrk/predis.git $DATA_PATCH/www/localhost/phpredisadmin/vendor

mv $DATA_PATCH/www/localhost/phpredisadmin/includes/config.sample.inc.php $DATA_PATCH/www/localhost/phpredisadmin/includes/config.inc.php
sed -i -r "s/127.0.0.1/redis/g" $DATA_PATCH/www/localhost/phpredisadmin/includes/config.inc.php
