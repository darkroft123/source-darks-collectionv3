package substates;

import game.StrumNote;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import flixel.text.FlxText;
import game.Note;
import flixel.tweens.FlxEase;
import utilities.NoteVariables;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class UISkinSelect extends MusicBeatSubstate
{
    public var keyCount:Int = 4;
    public var uiGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public var ui_Skin:String = Options.getData("uiSkin");

    public var ui_settings:Array<String> = CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/config"));
    public var ui_Skins:Array<String> = CoolUtil.coolTextFile(Paths.txt("uiSkinList"));

    public var mania_gap:Array<String>;
    public var mania_size:Array<String>;
    public var mania_offset:Array<String>;

    public var currentSkin:FlxText;
    public var selectedSkin:FlxText;
    public var defaultText:FlxText;
    public var notMultiText:FlxText;
    public var bg:FlxSprite;

    public var leaving:Bool = false;

    public var curSelected:Int = 0;

    public function new()
    {
        super();
        
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.scrollFactor.set();
        add(bg);

        currentSkin = new FlxText(0, 0, 0, "", 32, true);
        currentSkin.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        // selectedSkin.screenCenter(X);
        add(currentSkin);

        selectedSkin = new FlxText(0, 75, 0, "", 32, true);
        selectedSkin.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        // selectedSkin.screenCenter(X);
        add(selectedSkin);

        defaultText = new FlxText(0, 150, 0, "Noteskin will change depending on song.\nMust exit and re-enter song to take effect.", 32, true);
        defaultText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.YELLOW, CENTER, OUTLINE, FlxColor.BLACK);
        defaultText.screenCenter(X);
        defaultText.alpha = 1;
        add(defaultText);

        notMultiText = new FlxText(0, 150, 0, "This noteskin does NOT support multikey!\nOnly designed for 4K charts!", 32, true);
        notMultiText.setFormat(Paths.font("vcr.ttf"), 24, 0xFF6183, CENTER, OUTLINE, FlxColor.BLACK);
        notMultiText.screenCenter(X);
        notMultiText.alpha = 1;
        add(notMultiText);

        FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.circOut, startDelay: 0});

        if(!ui_Skins.contains(ui_Skin))
        {
            Options.setData("default", "uiSkin");
            ui_Skin = "default";
        }

        currentSkin.text = "Current Skin: [ " + Options.getData("uiSkin") + " ]";
        currentSkin.screenCenter(X);

        selectedSkin.text = "Selected Skin:\n> " + ui_Skin + " <";
        selectedSkin.screenCenter(X);

        #if PRELOAD_ALL
        create_Arrows();

        add(uiGroup);

        curSelected = ui_Skins.indexOf(ui_Skin);
        #else
        leaving = true;

        Assets.loadLibrary("shared").onComplete(function (_) {
            leaving = false;

            create_Arrows();
            add(uiGroup);
            curSelected = ui_Skins.indexOf(ui_Skin);
        });
        #end
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var left = controls.LEFT_P;
		var right = controls.RIGHT_P;
		var accepted = controls.ACCEPT;
        var back = controls.BACK;

        if(back && !leaving)
        {
            leaving = true;

            FlxG.save.flush();

            FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.circOut, startDelay: 0,
                onUpdate: function(tween:FlxTween) {
                    for(x in uiGroup.members)
                    {
                        x.alpha = bg.alpha;
                    }

                    currentSkin.alpha = bg.alpha;
                    selectedSkin.alpha = bg.alpha;
                    defaultText.alpha = 0;
                },
                onComplete: function(tween:FlxTween) {
                    close();
                }
            });
        }

        if(left || right && !leaving)
        {
            if(left)
                curSelected--;
            if(right)
                curSelected++;

            if (curSelected < 0)
                curSelected = ui_Skins.length - 1;

            if (curSelected >= ui_Skins.length)
                curSelected = 0;

            ui_Skin = ui_Skins[curSelected];

            create_Arrows();

            selectedSkin.text = "Selected Skin:\n> " + ui_Skin + " <";
            selectedSkin.screenCenter(X);
        }

        defaultText.alpha = (ui_Skin == "default") ? 1 : 0;
        notMultiText.alpha = (ui_Skin == "Corrupted") ? 1 : 0;

        if(accepted && !leaving)
            Options.setData(ui_Skin, "uiSkin");
            currentSkin.text = "Current Skin: [ " + Options.getData("uiSkin") + " ]";
            currentSkin.screenCenter(X);
    }

    function create_Arrows(?new_keyCount = 4)
    {
        ui_settings = CoolUtil.coolTextFile(Paths.txt("ui skins/" + ui_Skin + "/config"));
        mania_size = CoolUtil.coolTextFile(Paths.txt("ui skins/" + ui_Skin + "/maniasize"));
		mania_offset = CoolUtil.coolTextFile(Paths.txt("ui skins/" + ui_Skin + "/maniaoffset"));

        if(Assets.exists(Paths.txt("ui skins/" + ui_Skin + "/maniagap")))
			mania_gap = CoolUtil.coolTextFile(Paths.txt("ui skins/" + ui_Skin + "/maniagap"));
		else
			mania_gap = CoolUtil.coolTextFile(Paths.txt("ui skins/default/maniagap"));

        if(new_keyCount != null)
            keyCount = new_keyCount;

        for(x in uiGroup.members)
        {
            x.kill();
            x.destroy();
        }

        uiGroup.clear();

        Note.swagWidth = 160 * 0.7;

		for (i in 0...keyCount)
        {
            var babyArrow:StrumNote = new StrumNote(0, FlxG.height / 2, i, ui_Skin, ui_settings, mania_size, keyCount, 0.5);
            babyArrow.screenCenter(X);
            babyArrow.x += (babyArrow.width + (2 + Std.parseFloat(mania_gap[4 - 1]))) * Math.abs(i) + Std.parseFloat(mania_offset[4 - 1]);
            babyArrow.scrollFactor.set();
            babyArrow.setPosition(babyArrow.x - (babyArrow.width * 1.4), babyArrow.y - (10 + (babyArrow.height / 2)));
            babyArrow.alpha = 0;
            FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.2});
            babyArrow.ID = i;
            babyArrow.animation.play('static');
            uiGroup.add(babyArrow);
        }

        var rating_List:Array<String> = ['marvelous', 'sick', 'good', 'bad', 'shit'];

        for(i in 0...rating_List.length)
        {
            var rating = new FlxSprite(50, 180 + (i * 100));

            rating.loadGraphic(Paths.gpuBitmap("ui skins/" + ui_Skin + "/ratings/" + rating_List[i], 'shared'));

            rating.y -= 10;
            rating.alpha = 0;
            FlxTween.tween(rating, {y: rating.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.2});

            rating.setGraphicSize(rating.width * Std.parseFloat(ui_settings[0]) * Std.parseFloat(ui_settings[4]));
            rating.antialiasing = ui_settings[3] == "true" && Options.getData("antialiasing");
            rating.updateHitbox();

            uiGroup.add(rating);
        }

        var combo = new FlxSprite(900, 180);

        combo.loadGraphic(Paths.gpuBitmap("ui skins/" + ui_Skin + "/ratings/combo", 'shared'));

        combo.y -= 10;
        combo.alpha = 0;
        FlxTween.tween(combo, {y: combo.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.2});

        combo.setGraphicSize(combo.width * Std.parseFloat(ui_settings[0]) * Std.parseFloat(ui_settings[4]));
        combo.antialiasing = ui_settings[3] == "true" && Options.getData("antialiasing");
        combo.updateHitbox();

        uiGroup.add(combo);

        for(i in 0...10)
        {
            var number = new FlxSprite(930 + ((i % 3) * 60), 330 + ((Math.floor(i / 3)) * 75));

            number.loadGraphic(Paths.gpuBitmap("ui skins/" + ui_Skin + "/numbers/num" + i, 'shared'));

            number.setGraphicSize(number.width * Std.parseFloat(ui_settings[1]));
			number.antialiasing = ui_settings[3] == "true" && Options.getData("antialiasing");
			number.updateHitbox();

            number.y -= 10;
            number.alpha = 0;
            FlxTween.tween(number, {y: number.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.2});

            uiGroup.add(number);
        }
    }
}