package utilities;

import lime.app.Application;
import haxe.Json;
import openfl.Assets;
import flixel.util.FlxSave;
import game.Conductor;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import openfl.events.Event;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import haxe.io.Path;
typedef DefaultOptions = {
	var options:Array<DefaultOption>;
}

typedef DefaultOption = {
	var option:String; // option name
	var value:Dynamic; // self explanatory

	var save:Null<String>; // the save (KEY NAME) to use, by default is 'main'
}

/**
 * Class for managing savedata.
 * 
 */
class Options {
	public inline static final bindNamePrefix:String = "darks_collection-";
	public static var bindPath:String;

	public static var saves:Map<String, FlxSave> = [];

	public static var defaultOptions:DefaultOptions;

	/**
	 * Inititaizes savedata when starting the game.
	 */
	public static function init() {

		#if sys //mid stuff
		var solName:String = "darks_collection-scores.sol";
		var appDataDir:String = Sys.getEnv("APPDATA");
		var targetDir = Path.join([appDataDir, "darkroft"]);
		var solAppDataPath = Path.join([targetDir, solName]);
		var solSourcePath = "assets/preload/data/" + solName;

		if (!FileSystem.exists(solAppDataPath) && FileSystem.exists(solSourcePath)) {
			var bytes = File.getBytes(solSourcePath);
			File.saveBytes(solAppDataPath, bytes);

		}
		#end

		bindPath = Application.current.meta.get('company');
		createSave("main", "options");
		createSave("binds", "binds");
		//createSave("scores", "scores");
		createSaveFullPath("scores", Path.withoutExtension(solName));
		createSave("arrowColors", "arrowColors");
		createSave("autosave", "autosave");
		createSave("modlist", "modlist");
        createSaveFullPath("progress", "darks_collection-progress");

		defaultOptions = Json.parse(Assets.getText(Paths.json("defaultOptions")));

		for (option in defaultOptions.options) {
			var saveKey = option.save ?? "main";
			var dataKey = option.option;

			if (Reflect.getProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey) == null)
				setData(option.value, option.option, saveKey);
		}

		Conductor.offset = getData("songOffset");

		if (getData("modlist", "modlist") == null)
			setData(new Map<String, Bool>(), "modlist", "modlist");

		/*if (getData("songScores", "scores") == null)
			setData(new Map<String, Int>(), "songScores", "scores");

		if (getData("songRanks", "scores") == null)
			setData(new Map<String, String>(), "songRanks", "scores");

		if (getData("songAccuracies", "scores") == null)
			setData(new Map<String, Float>(), "songAccuracies", "scores");*/

		if (getData("arrowColors", "arrowColors") == null)
			setData(new Map<String, Array<Int>>(), "arrowColors", "arrowColors");
	}

	/**
	 * Creates a new ``FlxSave`` instance.
	 * @param key The identifier for the newly created save.
	 * @param bindNameSuffix The suffix for the newly created save.
	 */
	public static function createSave(key:String, bindNameSuffix:String) {
		var save = new FlxSave();
		save.bind(bindNamePrefix + bindNameSuffix, bindPath);

		saves.set(key, save);
	}

	public static function createSaveFullPath(key:String, bindName:String)
    {
        var save = new FlxSave();
        save.bind(bindName, bindPath);

        saves.set(key, save);
    }

	/**
	 * Returns an option.
	 * @param dataKey 
	 * @param saveKey 
	 * @return Dynamic
	 */
	public static function getData(dataKey:String, ?saveKey:String = "main"):Dynamic {
		if (saves.exists(saveKey))
			return Reflect.getProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey);

		return null;
	}

	/**
	 * Sets a option.
	 * Automatically calls ``flush()`` on the save key.
	 * @param value 
	 * @param dataKey 
	 * @param saveKey 
	 */
	public static function setData(value:Dynamic, dataKey:String, ?saveKey:String = "main") {
		if (saves.exists(saveKey)) {
			Reflect.setProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey, value);

			saves.get(saveKey).flush();
		}
	}

	@:noCompletion public static function fixBinds() {
		if (getData("binds", "binds") == null)
			setData(NoteVariables.defaultBinds, "binds", "binds");
		else {
			var bindArray:Array<Dynamic> = getData("binds", "binds");

			if (bindArray.length < NoteVariables.defaultBinds.length) {
				for (i in Std.int(bindArray.length - 1)...NoteVariables.defaultBinds.length) {
					bindArray[i] = NoteVariables.defaultBinds[i];
				}

				setData(bindArray, "binds", "binds");
			}
		}
	}
}
