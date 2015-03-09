<?php namespace MultiPaint;

class BaseController {
    protected $url;
    protected $params;

    protected function __construct($url, $params) {
        $this->url = $url;
        $this->params = $params;        
    }
    
    private static function halt($status, $code) {
        header($_SERVER['SERVER_PROTOCOL'].' '.$code.' '.$status, true, $code);
        exit(0);
    }
    
    protected function notFound() {
        echo 'URL '.$this->url.' does not exist!';
        self::halt('Not Found', 404);
    }

    protected function unauthorized($message) {
        echo $message;
        self::halt('Unauthorized', 401);
    }

    protected function error($message) {
        echo $message;
        self::halt('Bad Request', 400);
    }
    
    protected function redirect($path) {
        header('Location: '.WEB_URL.$path, true, 302);
        exit(0);
    }    
}      
