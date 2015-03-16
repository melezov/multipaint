<?php namespace MultiPaint;

use \NGS\Logger\FileLogger;
use \NGS\Logger\PsrLoggerBridge;
use \Psr\Log\LogLevel;

use \NGS\Client\DomainProxy;
use \NGS\Client\HttpClient;
use \NGS\Client\Exception\InvalidRequestException;

class GuestApi {
    private $domainProxy;

    public function __construct() {
        // Instantiate an unauthorized API
        // This is the same as using the default user/pass "Guest"/"Guest"
        // because of DefaultAuthorization config setting in Revenj
        $client = new HttpClient(API_URL);
        $this->domainProxy = new DomainProxy($client);

        // log unauthorized requests into separate log
        $logger = new PsrLoggerBridge($client);
        $logger->add(new FileLogger(LOGS.'guest-api.log', LogLevel::DEBUG));
    }

    // creates an Artist, and returns the new credentials within the RegisterArtist event
    public function registerArtist($name) {
        try {
            $registerArtist = new RegisterArtist();
            $registerArtist->Name = $name;
            return $this->domainProxy->submitEvent($registerArtist, true);
        }
        catch (InvalidRequestException $e) {
            return null;
        }
    }
}
