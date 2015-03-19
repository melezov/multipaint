#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

# find "$dir" -name "*.ts" | exec xargs tsc -target ES5 --out "$dir/../js/multipaint.js" --sourceMap -w
find "$dir" -name "*.ts" | exec xargs tsc -target ES5 --out "$dir/../../../../runtime/nginx/static/js/multipaint.js" --sourceMap -w
