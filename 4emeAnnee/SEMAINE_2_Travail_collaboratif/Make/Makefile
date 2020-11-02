install:
	composer install
	yarn install

lint: 
 	php vendor/bin/phpstan

test: 
	test_behat 
	test_php_unit

test_behat:
	php vendor/bin/behat

test_php_unit: 
	php vendor/bin/phpunit
