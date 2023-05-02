#!/bin/bash

# goes into where the script is located
pushd "${0%/*}"

# loads variables from .env
set -a
source .env
set +a

function DoVersion () {
    pushd ../$PROJECT_NAME
    dotnet build -c release
    popd
    docfx metadata
    dfmg
}

# if VERSIONS exists, then loop through each version
if [ -z "$VERSIONS" ]
then
    DoVersion
else
    # do for latest
    DoVersion
    pushd ../$PROJECT_NAME
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    popd

    for version in $VERSIONS
    do
        split=(${version//;/ })
        docusaurus_version=${split[0]}
        checkout_version=${split[1]}
        echo "Doing version $version, docusaurus_version=$docusaurus_version, checkout_version=$checkout_version"
        pushd ../$PROJECT_NAME
        # maybe redundant git fetch
        git fetch
        git checkout $checkout_version
        popd
        # write config.yaml for this version
        original_text=$(cat ./config.yaml)
        text="outputPath: ./versioned_docs/version-$docusaurus_version/api
yamlPath: ./api"
        echo -e "$text" > ./config.yaml

        DoVersion
        # restore config.yaml
        echo -e "$original_text" > ./config.yaml
    done

    # restore to original branch
    pushd ../$PROJECT_NAME
    git checkout $current_branch
    popd
fi

popd
