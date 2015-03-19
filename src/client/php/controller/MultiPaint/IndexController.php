<?php namespace MultiPaint;

class IndexController extends \Controller {
    const CANVAS = 'canvas';

    const DEFAULT_ARTIST_NAME = 'Guest';

    public function __construct($url, $method, $params) {
        parent::__construct($url, $method, $params);
    }

    private function registerAndRedirect($name) {
        $guestApi = new \MultiPaint\GuestApi();
        $registerArtist = $guestApi->registerArtist($name);

        // in case of invalid Artist name
        if ($registerArtist === null) {
            $this->error('Invalid Artist name: '.$name);
        }

        // redirect to the authorized drawing area
        $this->redirect(self::CANVAS.'/'.$registerArtist->UserID.'/'.$registerArtist->Password);
    }

    public function process() {
        $section = array_shift($this->params);

        switch ($section) {
            case '':
                $this->registerAndRedirect(self::DEFAULT_ARTIST_NAME);

            case 'register':
                $name = array_shift($this->params);
                $this->registerAndRedirect($name);

            case self::CANVAS:
                $controller = new CanvasController($this->url, $this->method, $this->params);
                $controller->process();

            default:
                $this->notFound();
        }
    }
}
