package substates;

import states.MusicBeatState;
import lime.app.Application;
import flixel.input.FlxInput.FlxInputState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import game.Conductor;
import utilities.PlayerSettings;
import utilities.Controls;
import game.Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import modding.scripts.languages.HScript;

class MusicBeatSubstate extends FlxSubState {
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	public var controls(get, never):Controls;

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

	override function update(elapsed:Float) {
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

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

		Application.current.window.title = MusicBeatState.windowNamePrefix + MusicBeatState.windowNameSuffix #if debug + ' (DEBUG)' #end;
	}

	public function updateCurStep():Void {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void {
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {
		// do literally nothing dumbass
	}
}
