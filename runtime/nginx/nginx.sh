#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

if [ -d "$dir/static" ]; then rm -rf "$dir/static"; fi
mkdir "$dir/static"

mkdir "$dir/static/css"
cp -t "$dir/static/css" "$dir/../../client/static/css/"*.css

mkdir "$dir/static/js"
cp -t "$dir/static/js" "$dir/../../client/static/js/"*.js

mkdir "$dir/static/images"
cp -t "$dir/static/images" "$dir/../../client/static/images/"*.png

cp -t "$dir/static/images" "$dir/../../client/static/favicon/favicon.ico"

nginx -c "$dir/conf/nginx.conf" -p "$dir"
exit 0
