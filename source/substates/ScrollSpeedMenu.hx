package substates;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class ScrollSpeedMenu extends MusicBeatSubstate {
	var alpha_Value:Float = 0.0;
	var offsetText:FlxText = new FlxText(0, 0, 0, "Scrollspeed: 0", 64).setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);

	public function new() {
		super();

		alpha_Value = Options.getData("customScrollSpeed");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.circOut, startDelay: 0});

		offsetText.text = "Scrollspeed: " + alpha_Value;
		offsetText.screenCenter();
		add(offsetText);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;

		var back = controls.BACK;

		if (back) {
			Options.setData(alpha_Value, "customScrollSpeed");
			FlxG.state.closeSubState();
		}

		if (leftP)
			alpha_Value -= 0.1;
		if (rightP)
			alpha_Value += 0.1;

		alpha_Value = FlxMath.roundDecimal(alpha_Value, 1);

		if (alpha_Value > 10)
			alpha_Value = 10;

		if (alpha_Value < 0.1)
			alpha_Value = 0.1;

		offsetText.text = "Scrollspeed: " + alpha_Value;
		offsetText.screenCenter();
	}
}
