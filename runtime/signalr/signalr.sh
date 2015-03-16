#!/bin/bash

cwd="$( pwd )"; cd "$( dirname "$0" )"; dir="$( pwd )"; cd "$cwd" 

if [ -f "$dir/model/ServerModel.dll" ]; then rm "$dir/model/ServerModel.dll"; fi

cp "$dir/../../server/csharp/model/ServerModel.dll" "$dir/model"

exec "$dir/bin/Revenj.SignalR2SelfHost.exe"
