#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

find "$dir/ts" -name "*.ts" | exec xargs tsc -target ES5 --out "$dir/../js/multipaint.js" --sourceMap -w
