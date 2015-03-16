#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

if [ -f  "$dir/app/client.phar" ]; then rm "$dir/app/client.phar"; fi

php "$dir/bundle/bundle.php"

hhvm --mode server -vServer.Type=fastcgi -vServer.Port=9003
