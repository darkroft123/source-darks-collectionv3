package ui;

import macros.GithubCommitHash;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import openfl.utils.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import external.memory.Memory;
import macros.GithubCommitHash;
import haxe.macro.Compiler;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import cpp.RawConstPointer;
import cpp.ConstCharStar;

/**
 * Shows basic info about the game.
 */
class SimpleInfoDisplay extends TextField {
	//                                      fps    mem   version console info , discord
	public var infoDisplayed:Array<Bool> = [false, false, false, false, false, false]; 


	public var framerate:Int = 0;

	private var framerateTimer:Float = 0.0;
	private var framesCounted:Int = 0;

	public var version:String = CoolUtil.getCurrentVersion();
	public var discordUserName:String = ""; 

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000, ?font:String) {
		super();

		this.x = x;
		this.y = y;
		selectable = false;
		defaultTextFormat = new TextFormat(font ?? Assets.getFont(Paths.font("vcr.ttf")).fontName, (font == "_sans" ? 12 : 14), color);

		FlxG.signals.postDraw.add(update);

		width = FlxG.width;
		height = FlxG.height;
	}

	public function update():Void {
		framerateTimer += FlxG.elapsed;
	
		if (framerateTimer >= 1) {
			framerateTimer = 0;
			framerate = framesCounted;
			framesCounted = 0;
		}
	
		framesCounted++;
	
		if (!visible) {
			return;
		}
	
		text = '';
		for (i in 0...infoDisplayed.length) {
			if (!infoDisplayed[i]) {
				continue;
			}
	
			switch (i) {
				case 0: // FPS
					text += '${framerate}fps\n';
				case 1: // Memory
					text += '${FlxStringUtil.formatBytes(Memory.getCurrentUsage())} / ${FlxStringUtil.formatBytes(Memory.getPeakUsage())}\n';
				case 2: // Version
					text += '$version\n';
				case 3: // Console
					text += Main.logsOverlay.logs.length > 0 ? '${Main.logsOverlay.logs.length} traced lines. F3 to view.\n' : '';
				case 4: // Commit Hash
					text += 'Commit ${GithubCommitHash.getGitCommitHash().substring(0, 7)}\n';
				case 5: // Discord Username
					text += 'Discord: ${discordUserName}\n'; 
			}
		}
	}
	
}
