<?php

require_once __DIR__.'/../vendor/autoload.php';

define('VERSION', time());
define('VIEWS', __DIR__.'/../views/');

$path = substr($_SERVER['REQUEST_URI'], 1);
$url = WEB_URL.$path;
$params = preg_split('/\\/+/u', $path);

$controller = new \MultiPaint\IndexController($url, $params);
$controller->process();
