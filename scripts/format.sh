#!/usr/bin/env bash

ROOT=`dirname $0`/..
cd $ROOT

    # ./{Tuist,Targets} \
    # ./*.swift \
mint run swift-format --in-place --recursive -- \
    ./SwiftUIComposableDemo \
    && echo "All done" \
    || (echo "Failed"; exit 1)
