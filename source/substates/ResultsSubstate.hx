package substates;

import flixel.FlxCamera;
import ui.NoteGraph;
import game.Song;
import states.LoadingState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;
/**
 * The substate for the results screen after a song or week is finished.
 */
class ResultsSubstate extends MusicBeatSubstate {
	var uiCamera:FlxCamera = new FlxCamera();

	public function new() {
		super();

        if (utilities.Options.getData("skipResultsScreen")) {
            PlayState.instance.finishSongStuffs();
            return;
        }

		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, false);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		bg.y -= 100;
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6, y: bg.y + 100}, 0.4, {ease: FlxEase.quartInOut});

		var topString = PlayState.SONG.song + " - " + PlayState.storyDifficultyStr.toUpperCase() + " complete! (" + Std.string(PlayState.songMultiplier) + "x)";

		var topText:FlxText = new FlxText(4, 4, 0, topString, 32);
		topText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		topText.scrollFactor.set();
		add(topText);

		var ratings:FlxText = new FlxText(0, FlxG.height, 0, PlayState.instance.getRatingText());
		ratings.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		ratings.screenCenter(Y);
		ratings.scrollFactor.set();
		add(ratings);

		@:privateAccess
		var bottomText:FlxText = new FlxText(FlxG.width, FlxG.height, 0,
			"Press ENTER to close this menu");
		bottomText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		bottomText.setPosition(FlxG.width - bottomText.width - 2, FlxG.height - 96);
		bottomText.scrollFactor.set();
		add(bottomText);

		if (PlayState.SONG.validScore) {
			var clearedText:FlxText = new FlxText(200, -50, 0, "CLEARED");
			clearedText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
			clearedText.screenCenter(X);
			clearedText.y = bottomText.y - 64;
			clearedText.scrollFactor.set();
			add(clearedText);
		}


		add(new NoteGraph(PlayState.instance, FlxG.width - 550, 75)); 

		cameras = [uiCamera];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			PlayState.instance.finishSongStuffs();
            return;
        }
	}
}