package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class DisclaimerMenu extends MusicBeatState {
    public var text:FlxText;
    public var canInput:Bool = true;
    public var atencion:FlxSprite;

    public var perroxd:FlxSprite;
    public var timer:Float = 0;
    public var interval:Float = 2; 
    public var text1:FlxText;
    public var text2:FlxText;
    public var text3:FlxText;

    override public function create() {
        super.create();

        atencion = new FlxSprite(50, 0).loadGraphic(Paths.gpuBitmap('title/attention_'));
        atencion.scale.set(0.8, 0.8);
        atencion.updateHitbox();
        add(atencion);

       text1 = new FlxText(0, 0, 0,
        'There was no time to port and fix the awards,\n they may be broken but other awards will continue to work.',
        24);

        text1.font = Paths.font('vcr.ttf');
        text1.alignment = CENTER;
        text1.screenCenter(X);
        text1.y = 350;
        add(text1);

        text2 = new FlxText(0, 0, 0,
               'If you find any bugs related to the added content in the menu,\n' +
               'please report them to darkroft on Discord.\n',
            24);
        text2.font = Paths.font('vcr.ttf');
        text2.alignment = CENTER;
        text2.screenCenter(X);
        text2.y = text1.y + text1.height + 40;
        add(text2);

        text3 = new FlxText(0, 0, 0,
            'Press Enter to continue',
            24);
        text3.font = Paths.font('vcr.ttf');
        text3.alignment = CENTER;
        text3.screenCenter(X);
        text3.color = FlxColor.CYAN;
        text3.y = text2.y + text2.height + 60;
        add(text3);


        perroxd = new FlxSprite().loadGraphic(Paths.image('title/perroxd'));
        perroxd.scale.set(0.6, 0.6);
        perroxd.updateHitbox();
        perroxd.alpha = 0;
        perroxd.scrollFactor.set();
        perroxd.x = FlxG.width - perroxd.width - 10;
        perroxd.y = FlxG.height - perroxd.height - 10;
        add(perroxd);
    }

   override function update(elapsed:Float) {
        super.update(elapsed);

        timer += elapsed;
        if (timer >= interval) {
            timer = 0;

            if (FlxG.random.bool(25)) {
                perroxd.visible = true;
                FlxTween.tween(perroxd, {alpha: 1}, 0.3);
            } else {
                FlxTween.tween(perroxd, {alpha: 0}, 0.3, {
                    onComplete: (_) -> perroxd.visible = false
                });
            }
        }

        if (!canInput) return;

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            FlxTween.tween(atencion, {alpha: 0}, 2.0, {ease: FlxEase.cubeInOut});
            FlxTween.tween(perroxd,  {alpha: 0}, 2.0, {ease: FlxEase.cubeInOut});
            FlxTween.tween(text1,    {alpha: 0}, 2.0, {ease: FlxEase.cubeInOut});
            FlxTween.tween(text2,    {alpha: 0}, 2.0, {ease: FlxEase.cubeInOut});
            FlxTween.tween(text3,    {alpha: 0}, 2.0, {
                ease: FlxEase.cubeInOut,
                onComplete: (_) -> FlxG.switchState(() -> new MainMenuState())
            });

            canInput = false;
        }
    }

}
