package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import game.Conductor;
import utilities.DiscordClient;
import utilities.MusicUtilities;

class LolState extends MusicBeatState { // ????????????????? soon ☠️👀
    override public function create():Void {
        MusicBeatState.windowNameSuffix = " ???";
        DiscordClient.changePresence("???", null);
        var comingSoon:FlxText = new FlxText(0, 0, FlxG.width, "COMING SOON");
        comingSoon.setFormat(Paths.font("freeplaytext.ttf"), 48, FlxColor.WHITE, "center");
        comingSoon.screenCenter(FlxAxes.Y);
        add(comingSoon);

        var q:FlxText = new FlxText(0, 0, FlxG.width, "PRESS BACK to EXIT");
        q.setFormat(Paths.font("freeplaytext.ttf"), 28, FlxColor.GRAY, "center");
        q.y = comingSoon.y + comingSoon.height + 20;
        add(q);
        FlxG.sound.playMusic(MusicUtilities.getLolMusic(), 0.7, true);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (controls.BACK) {
            FlxG.switchState(new MainMenuState());
            FlxG.sound.playMusic(MusicUtilities.getTitleMusic(), 0.7, true);
        }
    }
}
