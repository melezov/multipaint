#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

if [ -f "$dir/model/SignalRModel.dll" ]; then rm "$dir/model/SignalRModel.dll"; fi

cp "$dir/../../src/server/csharp/model/SignalRModel.dll" "$dir/model"

exec "$dir/bin/Revenj.SignalR2SelfHost.exe"
