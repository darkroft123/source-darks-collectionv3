package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.SongLoader;
import states.PlayState;

class TimeBar extends FlxSpriteGroup {

    public var bg:FlxSprite = new FlxSprite();
    public var bar:FlxBar;
    public var text:FlxText;
    public var time:Float = 0;

    public var barColorLeft:FlxColor = FlxColor.BLACK;
    public var barColorRight:FlxColor = FlxColor.WHITE;
    public var divisions:Int = 400;

    override public function new(song:SongData, difficulty:String = "NORMAL") {
        super();

        text = new FlxText(0, 0, 0, '${song.song} ~ $difficulty${Options.getData("botplay") ? " (BOT)" : ""}');
        text.setFormat(Paths.font("vcr.ttf"), Options.getData("biggerInfoText") ? 20 : 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
        text.screenCenter(X);
        text.scrollFactor.set();

        switch (Options.getData("timeBarStyle").toLowerCase()) {
            default:
                bg.loadGraphic(Paths.gpuBitmap('ui skins/${song.ui_Skin}/other/healthBar'));
                text.y = bg.y = Options.getData("downscroll") ? FlxG.height - (bg.height + 1) : 1;

            case "psych engine":
                bg.makeGraphic(400, 19, FlxColor.BLACK);
                bg.y = Options.getData("downscroll") ? FlxG.height - 36 : 10;
                divisions = 800;
                text.borderSize = Options.getData("biggerInfoText") ? 2 : 1.5;
                text.size = Options.getData("biggerInfoText") ? 32 : 20;
                text.y = bg.y - (text.height / 4);

            case "old kade engine":
                bg.loadGraphic(Paths.gpuBitmap('ui skins/${song.ui_Skin}/other/healthBar'));
                barColorLeft = FlxColor.GRAY;
                barColorRight = FlxColor.LIME;
                text.y = bg.y = Options.getData("downscroll") ? FlxG.height * 0.9 + 45 : 10;
        }

        bg.screenCenter(X);
        bg.scrollFactor.set();

        bar = new FlxBar(0, bg.y + 4, LEFT_TO_RIGHT, Std.int(bg.width - 8), Std.int(bg.height - 8), this, 'time', 0, FlxG.sound.music.length);
        bar.numDivisions = divisions;
        bar.screenCenter(X);
        bar.scrollFactor.set();

        if (Options.getData("gradientTimeBar")) {
            bar.createGradientBar([FlxColor.TRANSPARENT], [PlayState.boyfriend.barColor, PlayState.dad.barColor]);
        } else {
            bar.createFilledBar(barColorLeft, barColorRight);
        }

        add(bg);
        add(bar);
        add(text);
    }

    public function turnChange() {
        if (Options.getData("gradientTimeBar")) {
            PlayState.instance.timeBar.bar.createGradientBar(
                [FlxColor.TRANSPARENT],
                [PlayState.boyfriend.barColor, PlayState.dad.barColor]
            );
        } else {
            PlayState.instance.timeBar.bar.createFilledBar(
                PlayState.instance.timeBar.barColorLeft,
                PlayState.instance.timeBar.barColorRight
            );
        }
        PlayState.instance.timeBar.bar.updateFilledBar();
        PlayState.instance.timeBar.bar.color = FlxColor.WHITE;
    }

    public function onEvent() {
        if (PlayState.instance.timeBar != null) {
            if (Options.getData("gradientTimeBar")) {
                PlayState.instance.timeBar.bar.createGradientBar(
                    [FlxColor.TRANSPARENT],
                    [PlayState.boyfriend.barColor, PlayState.dad.barColor]
                );
            } else {
                PlayState.instance.timeBar.bar.createFilledBar(
                    PlayState.instance.timeBar.barColorLeft,
                    PlayState.instance.timeBar.barColorRight
                );
            }
            PlayState.instance.timeBar.bar.updateFilledBar();
            PlayState.instance.timeBar.bar.color = FlxColor.WHITE;
        }
    }
}
