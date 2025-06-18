package substates;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import states.FreeplayState;

class RejectedVipSubState extends MusicBeatSubstate {
    var parent:FreeplayState;
    var songName:String;
    var difficulty:String;

    var blackBG:FlxSprite;

    public function new(parent:FreeplayState, songName:String, difficulty:String) {
        super();
        this.parent = parent;
        this.songName = songName;
        this.difficulty = difficulty;
    }

    override public function create():Void {
        super.create();

        blackBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackBG.alpha = 0;
        blackBG.scrollFactor.set(0, 0);
        add(blackBG);
        FlxTween.tween(blackBG, {alpha: 0.5}, 0.5, {ease: FlxEase.quadOut});

        var warningTitle = new FlxText(0, 100, FlxG.width, "WARNING");
        warningTitle.setFormat("freeplaytext.ttf", 72, FlxColor.RED, "center");
        add(warningTitle);

        var text1 = new FlxText(0, 300, FlxG.width,
            "This song may lag and stutter frequently throughout your gameplay.");
        text1.setFormat("vcr.ttf", 36, FlxColor.WHITE, "center");
        add(text1);
        
        var text2 = new FlxText(0, 400, FlxG.width,
            "Please be cautious if your computer cannot handle heavy usage of shaders and other effects.");
        text2.setFormat("vcr.ttf", 36, FlxColor.WHITE, "center");
        add(text2);

        var enterText = new FlxText(0, FlxG.height - 80, FlxG.width, "Press ENTER to play song");
        enterText.setFormat("vcr.ttf", 28, FlxColor.CYAN, "center");
        add(enterText);

        var escText = new FlxText(0, FlxG.height - 50, FlxG.width, "Press ESC to return to the menu");
        escText.setFormat("vcr.ttf", 28, FlxColor.ORANGE, "center");
        add(escText);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER) {
            close();
            parent.playSong(songName, difficulty);
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            close();
        }
    }
}
