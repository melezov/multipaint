<?php

require_once __DIR__.'/../vendor/autoload.php'; 

define('WEB_URL', 'http://localhost:9000/');
define('API_URL', 'http://localhost:9001/');

define('LOGS', __DIR__.'/../logs/');
define('VIEWS', __DIR__.'/../views/');

$path = substr($_SERVER['REQUEST_URI'], 1);
$url = WEB_URL.$path;
$params = preg_split('/\\/+/u', $path);

$controller = new \MultiPaint\Controller($url, $params);
$controller->process();
