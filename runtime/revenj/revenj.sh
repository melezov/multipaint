#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

if [ -f "$dir/model/ServerModel.dll" ]; then rm "$dir/model/ServerModel.dll"; fi
if [ -f "$dir/events/events.dll" ]; then rm "$dir/events/events.dll"; fi

cp "$dir/../../server/csharp/model/ServerModel.dll" "$dir/model"
cp "$dir/../../server/csharp/events/bin/Debug/events.dll" "$dir/events"

exec "$dir/bin/Revenj.Http.exe"
