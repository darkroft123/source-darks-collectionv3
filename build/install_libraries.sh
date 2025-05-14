#! /bin/sh

echo Installing all required libraries.

haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
haxelib install format
haxelib install hxp
haxelib --skip-dependencies git lime https://github.com/swordcubes-grave-of-shite/lime
haxelib --skip-dependencies git openfl https://github.com/swordcubes-grave-of-shite/openfl
haxelib --skip-dependencies git flixel https://github.com/swordcubes-grave-of-shite/flixel dev
haxelib --skip-dependencies git flixel-addons https://github.com/swordcubes-grave-of-shite/flixel-addons dev
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui
haxelib git linc_luajit https://github.com/Leather128/linc_luajit.git
haxelib git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved codename-dev
haxelib git scriptless-polymod https://github.com/Vortex2Oblivion/scriptless-polymod
haxelib git hxNoise https://github.com/whuop/hxNoise
haxelib git hxvlc https://github.com/Vortex2Oblivion/hxvlc
haxelib --skip-dependencies install hxdiscord_rpc
haxelib git fnf-modcharting-tools https://github.com/Vortex2Oblivion/FNF-Modcharting-Tools
haxelib git flxanimate https://github.com/Vortex2Oblivion/flxanimate
haxelib git thx.core https://github.com/fponticelli/thx.core
haxelib git thx.semver https://github.com/fponticelli/thx.semver.git
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis
haxelib git jsonpath https://github.com/EliteMasterEric/jsonpath
haxelib --skip-dependencies git jsonpatch https://github.com/EliteMasterEric/jsonpatch
haxelib install hxcpp-debug-server

echo Finished
