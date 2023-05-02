#!/bin/bash

# goes into where the script is located
pushd "${0%/*}"
# loads variables from .env
set -a
source .env
set +a
pushd ../$PROJECT_NAME
dotnet build -c release
popd
docfx metadata
dfmg
popd
