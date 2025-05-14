package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DisclaimerMenu extends MusicBeatState {
    public var text:FlxText;
    public var canInput:Bool = true;

    override public function create() {
        super.create();

        text = new FlxText(0, 0, 0, 'This game contains strong perros xd\nPress Enter to continue.', 32);
        text.font = Paths.font('vcr.ttf');
        text.screenCenter();
        add(text);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!canInput) return;

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            FlxTween.tween(text, {alpha: 0}, 2.0, {
                ease: FlxEase.cubeInOut,
                onComplete: (_) -> FlxG.switchState(() -> new TitleState()) 
            });

            canInput = false;
        }
    }
}
