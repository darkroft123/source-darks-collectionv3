#! /bin/sh

haxe docs/docs.hxml
haxelib run dox -i docs -o pages --title "Leather Engine Documentation" -D source-path https://github.com/Vortex2Oblivion/LeatherEngine/tree/main/source
