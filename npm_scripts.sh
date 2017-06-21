#!/bin/sh

postinstall() {(set -e
# this function will run npm postinstall
    export PATH="$(pwd):$PATH"
    # install elasticsearch
    VERSION=1.7.6
    FILE_BASE="elasticsearch-$VERSION.tar.gz"
    FILE_URL="https://download.elastic.co/elasticsearch/elasticsearch/$FILE_BASE"
    if [ ! -f external/elasticsearch/bin/elasticsearch ]
    then
        # install file
        if [ ! -f "/tmp/$FILE_BASE" ]
        then
            FILE_TMP="$(mktemp "/tmp/$FILE_BASE.XXXXXXXX")"
            # copy cached file
            if [ -f "/$FILE_BASE" ]
            then
                cp "/$FILE_BASE" "$FILE_TMP"
            # download file
            else
                printf "downloading $FILE_URL to /tmp/$FILE_BASE ...\n"
                curl -#Lo "$FILE_TMP" "$FILE_URL"
            fi
            chmod 644 "$FILE_TMP"
            # mv file to prevent race-condition
            mv "$FILE_TMP" "/tmp/$FILE_BASE" 2>/dev/null || true
        fi
        # untar file
        mkdir -p external/elasticsearch
        tar --strip-components=1 -C external/elasticsearch -xzf /tmp/$FILE_BASE
    fi
    # install kibana
    VERSION=3.1.3
    FILE_BASE="kibana-$VERSION.tar.gz"
    FILE_URL="https://download.elastic.co/kibana/kibana/$FILE_BASE"
    if [ ! -f external/kibana/index.html ]
    then
        if [ ! -f "/tmp/$FILE_BASE" ]
        then
            FILE_TMP="$(mktemp "/tmp/$FILE_BASE.XXXXXXXX")"
            # copy cached file
            if [ -f "/$FILE_BASE" ]
            then
                cp "/$FILE_BASE" "$FILE_TMP"
            # download file
            else
                printf "downloading $FILE_URL to /tmp/$FILE_BASE ...\n"
                curl -#Lo "$FILE_TMP" "$FILE_URL"
            fi
            chmod 644 "$FILE_TMP"
            # mv file to prevent race-condition
            mv "$FILE_TMP" "/tmp/$FILE_BASE" 2>/dev/null || true
        fi
        # untar file
        mkdir -p external/kibana
        tar --strip-components=1 -C external/kibana -xzf /tmp/$FILE_BASE
    fi
)}

# run command
"$@"
