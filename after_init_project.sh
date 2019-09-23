#!/bin/bash

git clone -b master --depth=1 git@github.com:magento/modularity-refactoring-tools.git modularity-refactoring-tools
cp -r magento magento2ce-split
rm -rf magento2ce-split/.git
mv magento2ce-split magento/
rm -rf magento/app/code/Magento
rm -rf magento/lib/internal
php ./modularity-refactoring-tools/extract-ui-modules.php ../magento/magento2ce-split/app/code/Magento
cp magento/magento2ce-split/composer.json magento

cp -r magento-graphql magento2ce-split
rm -rf magento2ce-split/.git
mv magento2ce-split magento-graphql/
rm -rf magento-graphql/app/code/Magento
rm -rf magento-graphql/lib/internal
php ./modularity-refactoring-tools/extract-ui-modules.php ../magento-graphql/magento2ce-split/app/code/Magento
cp magento-graphql/magento2ce-split/composer.json magento-graphql

rm -rf ./magento/composer.lock
rm -rf ./magento-graphql/composer.lock

php ./modularity-refactoring-tools/prepare-composer-json.php ../magento/composer.json admin-ui
php ./modularity-refactoring-tools/prepare-composer-json.php ../magento-graphql/composer.json graph-ql

bash k-set-context magento
bash m-composer install
bash m-reinstall

bash k-set-context magento-graphql
bash m-composer install

cp magento/app/etc/env.php /magento-graphql/app/etc/
cp magento/app/etc/config.php /magento-graphql/app/etc/

bash m-bin-magento setup:upgrade
