#!/bin/sh

BASEDIR=$(dirname $0)
cd $BASEDIR

templhs-compiler Asdf.templ.html -o Asdf.hs || exit 1
hastec Main.hs || exit 2
