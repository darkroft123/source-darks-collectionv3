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
		bottomText.setPosition(FlxG.width - bottomText.width - 2, FlxG.height - 32);
		bottomText.scrollFactor.set();
		add(bottomText);

		var clearedText:FlxText = new FlxText(FlxG.width - 550, 0, 0, "");
		clearedText.y = bottomText.y - 256;
		clearedText.scrollFactor.set();

		if (PlayState.SONG.validScore) {
			clearedText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.LIME, LEFT, OUTLINE, FlxColor.BLACK);
			clearedText.text = "Score saved!";
		} else {
			clearedText.setFormat(Paths.font("vcr.ttf"), 24, 0xFF6183, LEFT, OUTLINE, FlxColor.BLACK);
			clearedText.text = 'Score NOT saved\n${PlayState.botUsed ? '• Botplay was enabled\n' : ''}${PlayState.noDeathUsed ? '• No Death was enabled\n' : ''}${PlayState.characterPlayingAs != 0 ? '• Opponent Play was enabled\n' : ''}${PlayState.chartingMode ? '• Chart Editor was used\n' : ''}${PlayState.modchartingMode ? '• Modchart Editor was used\n' : ''}';
		}
		add(clearedText);
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