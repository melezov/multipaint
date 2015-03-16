#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

find "$dir/../../client/ts" -name "*.ts" | xargs tsc -target es5 -out "$dir/../nginx/static/js/multipaint.js" -w

#minify multipaint.js > multipaint.min.js
