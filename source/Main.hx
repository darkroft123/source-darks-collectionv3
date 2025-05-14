package;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.system.debug.log.LogStyle;
import haxe.CallStack;
import haxe.Log;
import haxe.io.Path;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.text.TextFormat;
import openfl.utils._internal.Log as OpenFLLog;
import states.TitleState;
import ui.SimpleInfoDisplay;
import ui.logs.Logs;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import openfl.events.Event;

import lime.system.CFFI;
import polymod.backends.PolymodAssets;

class Main extends Sprite {
	public static var game:FlxGame;
	public static var display:SimpleInfoDisplay;
	public static var logsOverlay:Logs;

	public static var previousState:FlxState;

	public static var onCrash(default, null):FlxTypedSignal<UncaughtErrorEvent->Void> = new FlxTypedSignal<UncaughtErrorEvent->Void>();

	public function new() {
		super();

		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, _onCrash);
		#end

		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(_onCrash); // this is important i guess?
		#end

		CoolUtil.haxe_trace = Log.trace;
		Log.trace = CoolUtil.haxe_print;
		OpenFLLog.throwErrors = false;

		game = new FlxGame(1280, 720, TitleState, 60, 60, true);

		FlxG.signals.preStateSwitch.add(() -> {
			Main.previousState = FlxG.state;
		});

		FlxG.signals.preStateCreate.add((state) -> {
			CoolUtil.clearMemory();
		});

		// FlxG.game._customSoundTray wants just the class, it calls new from
		// create() in there, which gets called when it's added to stage
		// which is why it needs to be added before addChild(game) here
		@:privateAccess
		game._customSoundTray = ui.FunkinSoundTray;

		addChild(game);
		logsOverlay = new Logs();
		logsOverlay.visible = false;
		addChild(logsOverlay);

		LogStyle.WARNING.onLog.add((data, ?pos) -> trace(data, WARNING, pos));
		LogStyle.ERROR.onLog.add((data, ?pos) -> trace(data, ERROR, pos));
		LogStyle.NOTICE.onLog.add((data, ?pos) -> trace(data, LOG, pos));

		display = new SimpleInfoDisplay(8, 3, 0xFFFFFF, "_sans");
		addChild(display);

		// shader coords fix
		// stolen from psych engine lol
		FlxG.signals.gameResized.add(function(w, h) {
			if (FlxG.cameras != null) {
				for (cam in FlxG.cameras.list) {
					if (cam != null && cam.filters != null) {
						resetSpriteCache(cam.flashSprite);
					}
				}
			}

			if (FlxG.game != null) {
				resetSpriteCache(FlxG.game);
			}
		});
	}
	private function init(?E:Event):Void
	{
		
		setupGame();
	}

	private function setupGame():Void
	{

		FlxG.signals.gameResized.add(fixCameraShaders);

		
	}


	public static inline function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}
	public static inline function toggleDarkMode(enabled:Bool):Void {
		#if sys
		var setDarkMode:Dynamic = CFFI.load(PolymodAssets.getPath('assets/ndll/darkheader.ndll'), "darkheader_set_windows_darkmode", 0);
		if(setDarkMode == null) setDarkMode = function() {}; // anti crash
		setDarkMode();
		#end
	}

	public static inline function toggleFPS(fpsEnabled:Bool):Void {
		display.infoDisplayed[0] = fpsEnabled;
	}

	public static inline function toggleMem(memEnabled:Bool):Void {
		display.infoDisplayed[1] = memEnabled;
	}

	public static inline function toggleVers(versEnabled:Bool):Void {
		display.infoDisplayed[2] = versEnabled;
	}

	public static inline function toggleLogs(logsEnabled:Bool):Void {
		display.infoDisplayed[3] = logsEnabled;
	}

	public static inline function toggleCommitHash(commitHashEnabled:Bool):Void {
		display.infoDisplayed[4] = commitHashEnabled;
	}
	public static inline function toggleDiscord(discordUser:Bool):Void {
		display.infoDisplayed[5] = discordUser;
	}
	public static inline function changeFont(font:String):Void {
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);
	}



	public static function fixCameraShaders(w:Int, h:Int) //fixes shaders after resizing the window / fullscreening
	{
		if (FlxG.cameras.list.length > 0)
		{
			for (cam in FlxG.cameras.list)
			{
				if (cam.flashSprite != null)
				{
					@:privateAccess 
					{
						cam.flashSprite.__cacheBitmap = null;
						cam.flashSprite.__cacheBitmapData = null;
						cam.flashSprite.__cacheBitmapData2 = null;
						cam.flashSprite.__cacheBitmapData3 = null;
						cam.flashSprite.__cacheBitmapColorTransform = null;
					}
				}
			}
		}
		
	}

	#if sys
	/**
	 * Shoutout to @gedehari for making the crash logging code
	 * They make some cool stuff check them out!
	 * @see https://github.com/gedehari/IzzyEngine/blob/master/source/Main.hx
	 * @param e
	 */
	private function _onCrash(e:UncaughtErrorEvent):Void {
		onCrash.dispatch(e);
		var error:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var date:String = Date.now().toString();

		date = StringTools.replace(date, " ", "_");
		date = StringTools.replace(date, ":", "'");

		for (stackItem in callStack) {
			switch (stackItem) {
				case FilePos(s, file, line, column):
					error += file + ":" + line + "\n";
				default:
					Sys.println(stackItem);
			}
		}

		// see the docs for e.error to see why we do this
		// since i guess it can sometimes be an issue???
		// /shrug - what-is-a-git 2024
		var errorData:String = "";
		if (e.error is Error) {
			errorData = cast(e.error, Error).message;
		} else if (e.error is ErrorEvent) {
			errorData = cast(e.error, ErrorEvent).text;
		} else {
			errorData = Std.string(e.error);
		}

		error += "\nUncaught Error: " + errorData;
		path = Sys.getCwd() + "crash/" + "crash-" + errorData + '-on-' + date + ".txt";

		if (!FileSystem.exists("./crash/")) {
			FileSystem.createDirectory("./crash/");
		}

		File.saveContent(path, error + "\n");

		Sys.println(error);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		var crashPath:String = "Crash" #if linux + '.x86_64' #end#if windows + ".exe" #end;

		if (FileSystem.exists("./" + crashPath)) {
			Sys.println("Found crash dialog: " + crashPath);

			#if linux
			crashPath = "./" + crashPath;
			new Process('chmod', ['+x', crashPath]); // make sure we can run the file lol
			#end
			FlxG.stage.window.visible = false;
			new Process(crashPath, ['--crash_path="' + path + '"']);
			// trace(process.exitCode());
		} else {
			Sys.println("No crash dialog found! Making a simple alert instead...");
			FlxG.stage.window.alert(error, "Error!");
		}

		Sys.exit(1);
	}
	#end
	
}