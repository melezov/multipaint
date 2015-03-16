<?php

define('WEB_URL', 'http://multipaint-nginx:8080/');
define('API_URL', 'http://multipaint-revenj:9001/');

define('LOGS', __DIR__.'/../logs/');

require 'phar://'.__DIR__.'/client.phar/public/index.php';
