#/bin/bash

apt-get update
apt-get install -y apache2-utils unzip wget
htpasswd -c ./data/nginx/.htpasswd root

git clone https://github.com/codeb2cc/phpMemcachedAdmin ./data/www/localhost/phpMemcachedAdmin
sed -i "s/127\.0\.0\.1/memcached)/g" ./data/www/localhost/phpMemcachedAdmin/Config/Memcache.php

sed -i "s/#//g" ./data/nginx/localhost.conf
sed -i "s/deny/#deny/g" ./data/nginx/localhost.conf

wget https://github.com/phpmyadmin/phpmyadmin/archive/RELEASE_4_4_15_2.zip
unzip RELEASE_4_4_15_2.zip -d ./data/www/localhost
mv ./data/www/localhost/phpmyadmin-RELEASE_4_4_15_2 ./data/www/localhost/phpmyadmin
rm RELEASE_4_4_15_2.zip
mv ./data/www/localhost/phpmyadmin/config.sample.inc.php ./data/www/localhost/phpmyadmin/config.inc.php

sed -i -r "s/$cfg\['blowfish_secret'\] = ''/$cfg\['blowfish_secret'\] = '$(openssl rand -base64 32)'/g" ./data/www/localhost/phpmyadmin/config.inc.php
sed -i -r "s/localhost/mysql/g" ./data/www/localhost/phpmyadmin/config.inc.php

echo "restart nginx"
