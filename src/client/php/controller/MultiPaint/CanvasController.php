<?php namespace MultiPaint;

class CanvasController extends \Controller {
    private $userID;
    private $password;

    private $artistApi;

    public function __construct($url, $method, $params) {
        parent::__construct($url, $method, $params);

        $this->userID = array_shift($this->params);
        $this->password = array_shift($this->params);

        // sanity check - userID-password should form a valid UUID
        if (!\NGS\UUID::isValid($this->userID.'-'.$this->password)) {
            $this->unauthorized('Invalid session ID: '.$this->userID.'/'.$this->password);
        }

        // instantiate the ArtistApi with the provided credentials
        $this->artistApi = new ArtistApi($this->userID, $this->password);
    }

    public function process() {
        $section = array_shift($this->params);

        switch ($section) {
            case '':
                require(VIEWS.'index.php');
                exit(0);

            case 'change-artist-name':
                $json = $this->getPostBody();
                $changeArtistName = ChangeArtistName::fromJson($json);
                $a = $this->artistApi->changeArtistName($changeArtistName->NewName);
                var_dump($a);
                die;

            default:
                $this->notFound();
        }
    }
}
