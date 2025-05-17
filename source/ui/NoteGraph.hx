package ui;

import openfl.utils.ByteArray;
import openfl.geom.Rectangle;
import states.PlayState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class NoteGraph extends FlxGroup {
	public function new(replay:PlayState, startX:Float = 0.0, ?startY:Float = 0.0) {
		super();

		var judgeArray:Array<Float> = utilities.Options.getData("judgementTimings");

		var bg = new FlxSprite(startX, startY).makeGraphic(500, 332, FlxColor.BLACK);
		bg.alpha = 0.3;
		add(bg);

		var missLine1 = new FlxSprite(startX, startY).makeGraphic(500, 4, FlxColor.RED); // top line
		missLine1.alpha = 0.5;
		add(missLine1);

		var shitLine1 = new FlxSprite(startX, startY + 166 - judgeArray[3]).makeGraphic(500, 4, FlxColor.MAGENTA);
		shitLine1.alpha = 0.5;
		add(shitLine1);

		var badLine1 = new FlxSprite(startX, startY + 166 - judgeArray[2]).makeGraphic(500, 4, FlxColor.BLUE);
		badLine1.alpha = 0.5;
		add(badLine1);

		var goodLine1 = new FlxSprite(startX, startY + 166 - judgeArray[1]).makeGraphic(500, 4, FlxColor.LIME);
		goodLine1.alpha = 0.5;
		add(goodLine1);

		var sickLine1 = new FlxSprite(startX, startY + 166 - judgeArray[0]).makeGraphic(500, 4, FlxColor.YELLOW);
		sickLine1.alpha = 0.5;
		add(sickLine1);

		var marvLine = new FlxSprite(startX, startY + 166).makeGraphic(500, 4, 0xFF78FAFF); // center line
		marvLine.alpha = 0.5;
		add(marvLine);

		var sickLine2 = new FlxSprite(startX, startY + 166 + judgeArray[0]).makeGraphic(500, 4, FlxColor.YELLOW);
		sickLine2.alpha = 0.5;
		add(sickLine2);

		var goodLine2 = new FlxSprite(startX, startY + 166 + judgeArray[1]).makeGraphic(500, 4, FlxColor.LIME);
		goodLine2.alpha = 0.5;
		add(goodLine2);

		var badLine2 = new FlxSprite(startX, startY + 166 + judgeArray[2]).makeGraphic(500, 4, FlxColor.BLUE);
		badLine2.alpha = 0.5;
		add(badLine2);

		var shitLine2 = new FlxSprite(startX, startY + 166 + judgeArray[3]).makeGraphic(500, 4, FlxColor.MAGENTA);
		shitLine2.alpha = 0.5;
		add(shitLine2);

		var missLine1 = new FlxSprite(startX, startY + 332).makeGraphic(500, 4, FlxColor.RED); // bottom line
		missLine1.alpha = 0.5;
		add(missLine1);

		var dots:FlxSprite = new FlxSprite(startX, startY).makeGraphic(500, 332);

		dots.graphic.bitmap.lock();
        dots.graphic.bitmap.floodFill(0, 0, 0x00000000);

		for (i in 0...replay.inputs.length) {
			var input = replay.inputs[i];

			if (input[2] == 2) {
				var dif = input[3];
				var strumTime = input[1];

				dots.graphic.bitmap.fillRect(new Rectangle(500 * (strumTime / FlxG.sound.music.length), 166 + (dif / PlayState.songMultiplier), 4, 4),
					rgbToInt(Math.floor(255 * (Math.abs(dif) / 166)), 255, 0));
			}
		}

		dots.graphic.bitmap.unlock();
		add(dots);

		add(new FlxText(startX, startY - 16, 0, "+166ms (Late)", 16).setFormat(Paths.font("vcr.ttf"), 16, FlxColor.ORANGE, LEFT, OUTLINE, FlxColor.BLACK));
		add(new FlxText(startX, startY + 336, 0, "-166ms (Early)", 16).setFormat(Paths.font("vcr.ttf"), 16, FlxColor.CYAN, LEFT, OUTLINE, FlxColor.BLACK));
	}

	function rgbToInt(r:Int, g:Int, b:Int):Int {
		return (255 << 24) | (r << 16) | (g << 8) | b;
	}
}