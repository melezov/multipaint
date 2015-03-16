<?php namespace MultiPaint;

use \NGS\Logger\FileLogger;
use \NGS\Logger\PsrLoggerBridge;
use \Psr\Log\LogLevel;

use \NGS\Client\DomainProxy;
use \NGS\Client\HttpClient;
use \NGS\Client\StandardProxy;
use \NGS\Client\Exception\InvalidRequestException;

class ArtistApi {
    private $standardProxy;
    private $domainProxy;

    public function __construct($userID, $password) {
        // instantiate authorized HttpClient
        $client = new HttpClient(API_URL, $userID, $password);
        $this->standardProxy = new StandardProxy($client);
        $this->domainProxy = new DomainProxy($client);

        // log authorized requests into separate log
        $logger = new PsrLoggerBridge($client);
        $logger->add(new FileLogger(LOGS.'artist-api.log', LogLevel::DEBUG));
    }

    public function changeArtistName($newName) {
        try {
            $changeArtistName = new ChangeArtistName();
            $changeArtistName->NewName = $newName;
            $this->domainProxy->submitEvent($changeArtistName);
            return true;
        }
        catch(InvalidRequestException $e) {
            return false;
        }
    }

/*
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
*/
}
