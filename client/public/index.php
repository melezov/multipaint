<?php namespace MultiPaint;

define('API_URL', 'http://localhost:9000/api/');
      
require_once __DIR__.'/../vendor/autoload.php'; 

use \NGS\Logger\FileLogger;
use \NGS\Logger\PsrLoggerBridge;
use \Psr\Log\LogLevel;

use \NGS\Client\DomainProxy;
use \NGS\Client\HttpClient;
use \NGS\Client\StandardProxy;
use \NGS\Client\ReportingProxy;

/*$brushes = Brush::findAll();
foreach ($brushes as $b) {
  $b->delete();
}

$artists = Artist::findAll();
foreach ($artists as $a) {
  $a->delete();
}
*/

class GuestApi {
    private $standardProxy;
    
    public function __construct() {
        // Instantiate an unauthorized API
        // This is the same as using the default user/pass "Guest"/"Guest"
        // because of DefaultAuthorization config setting in Revenj
        $client = new HttpClient(API_URL);
        $this->standardProxy = new StandardProxy($client);

        // log unauthorized requests into separate log
        $logger = new PsrLoggerBridge($client);
        $logger->add(new FileLogger(__DIR__.'/../guest-api.log', LogLevel::DEBUG));
    }

    public function registerArtist($name) {
        return $this->standardProxy->execute('MultiPaint.RegisterArtist', json_encode($name));
    }
}

class ArtistApi {
    private $standardProxy;
    private $domainProxy;
    
    public function __construct($token) {
        $userPass = base64_decode($token);

        // HttpClient expects user/pass so we need to split the auth token
        $splitAt = strpos($userPass, ':');
        $user = substr($userPass, 0, $splitAt);
        $pass = substr($userPass, $splitAt + 1);

        // instantiate authorized HttpClient
        $client = new HttpClient(API_URL, $user, $pass);
        $this->standardProxy = new StandardProxy($client);
        $this->domainProxy = new DomainProxy($client);        

        // log authorized requests into separate log
        $logger = new PsrLoggerBridge($client);
        $logger->add(new FileLogger(__DIR__.'/../artist-api.log', LogLevel::DEBUG));
    }
    
    public function changeBrush($color, $thickness) {
      $changeBrush = new ChangeBrush(array(
        'Color' => $color,
        'Thickness' => $thickness
      ));      
      
      $changeBrush = $this->domainProxy->submitEvent($changeBrush, true);
      return $changeBrush->BrushID;
    }
    
    public function getLastBrushes() {
        $cube = new LastBrush();
        $filter = new LastBrush\ActiveSince();
        $filter->AgeInMinutes = 5;

        $dimensions = array(LastBrush::ArtistName);
        $facts = array(LastBrush::LastBrushID);
        $order = array(LastBrush::LastBrushID => true);
        
        $lastBrushIDs = $this->standardProxy->olapCubeWithSpecification(
            $cube, $filter, $dimensions, $facts, $order);
      
        echo '<pre>';
      
 //     die;

        var_dump($lastBrushIDs);
        
        $lastBrushIDs = array_map(
            function($lb) { return $lb['LastBrushID']; }, 
            $lastBrushIDs);
      
        var_dump($lastBrushIDs);

        $lastBrushes = $this->domainProxy->find(
            'MultiPaint\ArtistBrush',
            $lastBrushIDs);
                      
        foreach ($lastBrushes as $lb) {
            echo '<hr>';
            echo $lb;
        }
    }
}

$guestApi = new GuestApi();
$token = $guestApi->registerArtist('Pero'.time());

$artistApi = new ArtistApi($token);
$brushID = $artistApi->changeBrush('#aabbcc', 100);
var_dump($brushID);

$brushID = $artistApi->changeBrush('#aabbcc', 110);
var_dump($brushID);

$artistApi->getLastBrushes();

