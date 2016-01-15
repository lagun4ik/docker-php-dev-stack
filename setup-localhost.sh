#/bin/bash

apt-get update
apt-get install -y apache2-utils
htpasswd -c /data/nginx/.htpasswd exampleuser

git clone https://github.com/codeb2cc/phpMemcachedAdmin ./data/www/localhost/phpMemcachedAdmin
sed -i "s/127\.0\.0\.1/memcached)/g" ./data/www/localhost/phpMemcachedAdmin

sed -i "s/#//g" ./data/nginx/localhost.conf
sed -i "s/deny/#deny)/g" ./data/nginx/localhost.conf

git clone https://github.com/phpmyadmin/phpmyadmin.git ./data/www/localhost/phpmyadmin
mv ./data/www/localhost/phpmyadmin/config.sample.inc.php ./data/www/localhost/phpmyadmin/config.inc.php

sed -i -r "s/$cfg\['blowfish_secret'\] = ''/$cfg\['blowfish_secret'\] = '$(openssl rand -base64 32)'/g" ./data/www/localhost/phpmyadmin/config.inc.php
sed -i -r "s/localhost/mysql/g" ./data/www/localhost/phpmyadmin/config.inc.php

 docker-compose restart
