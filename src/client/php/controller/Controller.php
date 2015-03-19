<?php

class Controller {
    protected $url;
    protected $method;
    protected $params;

    protected function __construct($url, $method, $params) {
        $this->url = $url;
        $this->method = $method;
        $this->params = $params;
    }

    protected function getPostBody() {
        if ($this->method !== 'POST')
            self::methodNotAllowed();

        return file_get_contents('php://input');
    }

    private static function halt($status, $code) {
        header($_SERVER['SERVER_PROTOCOL'].' '.$code.' '.$status, true, $code);
        exit(0);
    }

    protected function redirect($path) {
        header('Location: '.WEB_URL.$path, true, 302);
        exit(0);
    }

    protected function error($message) {
        echo $message;
        self::halt('Bad Request', 400);
    }

    protected function unauthorized($message) {
        echo $message;
        self::halt('Unauthorized', 401);
    }

    protected function notFound() {
        echo 'URL '.$this->url.' does not exist!';
        self::halt('Not Found', 404);
    }

    protected function methodNotAllowed() {
        echo $this->method.' on URL '.$this->url.' is not allowed!';
        self::halt('Method Not Allowed', 405);
    }
}
