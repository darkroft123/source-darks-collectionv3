package states;

import modding.scripts.ExecuteOn;
import modding.scripts.languages.HScript;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.input.FlxInput.FlxInputState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import lime.app.Application;
import game.Conductor;
import utilities.PlayerSettings;
import game.Conductor.BPMChangeEvent;
import utilities.Controls;
import flixel.FlxG;
import flixel.sound.FlxSound;

/**
 * The backend state all states will extend from.
 */
class MusicBeatState extends #if MODCHARTING_TOOLS modcharting.ModchartMusicBeatState #else flixel.addons.ui.FlxUIState #end {
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	private var controls(get, never):Controls;

	public static var windowNameSuffix:String = "";
	public static var windowNamePrefix:String = "Leather Engine";

	public static var fullscreenBind:String = "F11";

	#if HSCRIPT_ALLOWED
	public var stateScript:HScript;
	#end

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override public function create() {
		super.create();
		#if HSCRIPT_ALLOWED
		var statePath:String = Type.getClassName(Type.getClass(this)).replace(".", "/");
		if (sys.FileSystem.exists('mods/${Options.getData("curMod")}/classes/${statePath}.hx')) {
			stateScript = new HScript('mods/${Options.getData("curMod")}/classes/${statePath}.hx');
		}
		#end
	}

	public function call(func:String, ?args:Array<Any>, executeOn:ExecuteOn = BOTH) {
		#if HSCRIPT_ALLOWED
		stateScript?.call(func, args);
		#end
	}
	override function update(elapsed:Float) {
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);

		/*if (!Options.getData("antialiasing")) {
			forEachAlive(function(basic:FlxBasic) {
				if (!(basic is FlxSprite)) {
					return;
				}
				cast(basic, FlxSprite).antialiasing = false;
			}, true);
		}*/

		if (FlxG.keys.checkStatus(FlxKey.fromString(Options.getData("fullscreenBind", "binds")), FlxInputState.JUST_PRESSED))
			FlxG.fullscreen = !FlxG.fullscreen;

		if (FlxG.keys.justPressed.F5 && Options.getData("developer"))
			FlxG.resetState();

		FlxG.autoPause = Options.getData("autoPause");
		Application.current.window.title = windowNamePrefix + windowNameSuffix #if debug + ' (DEBUG)' #end;
	}

	public function updateBeat():Void {
		curBeat = Math.floor(curStep / Conductor.timeScale[1]);
	}

	public function updateCurStep():Void {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		var dumb:TimeScaleChangeEvent = {
			stepTime: 0,
			songTime: 0,
			timeScale: [4, 4]
		};

		var lastTimeChange:TimeScaleChangeEvent = dumb;

		for (i in 0...Conductor.timeScaleChangeMap.length) {
			if (Conductor.songPosition >= Conductor.timeScaleChangeMap[i].songTime)
				lastTimeChange = Conductor.timeScaleChangeMap[i];
		}

		if (lastTimeChange != dumb)
			Conductor.timeScale = lastTimeChange.timeScale;

		var multi:Float = 1;

		if (FlxG.state == PlayState.instance)
			multi = PlayState.songMultiplier;

		Conductor.recalculateStuff(multi);
		
		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);

		updateBeat();
	}

	public function stepHit():Void {
		if (curStep % Conductor.timeScale[0] == 0)
			beatHit();
	}

	public function beatHit():Void {/* do literally nothing dumbass */}
}
