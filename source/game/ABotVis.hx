package game;

import lime.media.AudioSource;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
#if desktop
import funkin.vis.dsp.SpectralAnalyzer;
#end

using Lambda;

class ABotVis extends FlxSpriteGroup {
	#if desktop
	var analyzer:SpectralAnalyzer;
	#end

	public function new() {
		super();

		// The audio visualizer - Nex
		var visFrms:FlxAtlasFrames = Paths.getSparrowAtlas('aBotViz');

		// these are the differences in X position, from left to right
		var widths:Array<Float> = [68, 58, 58, 57, 61, 67, 70];
		var positionX:Array<Float> = [0, 59, 56, 66, 54, 52, 51];
		var positionY:Array<Float> = [0, -8, -3.5, -0.4, 0.5, 4.7, 7];

		var sum = function(num:Float, total:Float) return total += num;
		var totalWidth = Lambda.fold(widths, sum, 0);

		for (i in 1...8) {
			var posX:Float = Lambda.fold(positionX.slice(0, i), sum, 0);
			var posY:Float = Lambda.fold(positionY.slice(0, i), sum, 0);

			var viz:FlxSprite = new FlxSprite();
			viz.frames = visFrms;
			viz.width = totalWidth;
			// viz.height = FlxG.height;
			viz.x += posX;
			viz.y += posY;
			add(viz);

			viz.animation.addByPrefix('VIZ', 'viz' + i, 0);
			viz.animation.play('VIZ', false, false, 6);
		}

		#if desktop
		@:privateAccess
		analyzer = new SpectralAnalyzer(FlxG.sound.music._channel.__audioSource, 7, 0.1, 40);
		#end
		analyzer.fftN = 256;

		// analyzer.maxDb = -35;
	}

    static inline function min(x:Int, y:Int):Int
        {
          return x > y ? y : x;
        }
      

	override function update(elapsed:Float) {
		#if desktop
		if (FlxG.sound.music != null) {
			var levels = analyzer.getLevels();

			for (i in 0...min(group.members.length, levels.length)) {
				var animFrame:Int = Math.round(levels[i].value * 5);

				#if desktop
				// Web version scales with the Flixel volume level.
				// This line brings platform parity but looks worse.
				// animFrame = Math.round(animFrame * FlxG.sound.volume);
				#end

				animFrame = Math.floor(Math.min(5, animFrame));
				animFrame = Math.floor(Math.max(0, animFrame));

				animFrame = Std.int(Math.abs(animFrame - 5)); // shitty dumbass flip, cuz dave got da shit backwards lol!

				group.members[i].animation.curAnim.curFrame = animFrame;
			}
		}
		#end
		super.update(elapsed);
	}
}
