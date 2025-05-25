package states;

import ui.Alphabet;
import flixel.math.FlxMath;
import game.Conductor;
import flixel.FlxObject;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import shaders.Shaders.GreyscaleEffect;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import utilities.Options;
import Popup.AwardPopup;
import flixel.FlxG;

typedef Award = {
    var name:String;
    var desc:String;
    var saveData:String;
    var ?awardImage:Null<String>;
}

class AwardManager {
    public static final awards:Array<Award> = [
        {name: "Rose Stars", desc: "Get A Rose Star", saveData: "beat_wiik 1", awardImage: "RoseStar"},
        {name: "Gold Stars", desc: "Get a Gold Star", saveData: "fc_light it up", awardImage: "GoldStar"},
        {name: "Ruckus FC", desc: "", saveData: "fc_ruckus", awardImage: "Wiik1FC"},
        {name: "Target Practice FC", desc: "", saveData: "fc_target practice", awardImage: "Wiik1FC"},

        {name: "Wiik 2", desc: "Beat Wiik 2", saveData: "beat_wiik 2", awardImage: "Wiik2"},
        {name: "Burnout FC", desc: "", saveData: "fc_burnout", awardImage: "Wiik2FC"},
        {name: "Sporting FC", desc: "", saveData: "fc_sporting", awardImage: "Wiik2FC"},
        {name: "Boxing Match FC", desc: "", saveData: "fc_boxing match", awardImage: "Wiik2FC"},

        {name: "Wiik 3", desc: "Beat Wiik 3", saveData: "beat_wiik 3", awardImage: "Wiik3"},
        {name: "Fisticuffs FC", desc: "", saveData: "fc_fisticuffs", awardImage: "Wiik3FC"},
        {name: "Blastout FC", desc: "", saveData: "fc_blastout", awardImage: "Wiik3FC"},
        {name: "Immortal FC", desc: "", saveData: "fc_immortal", awardImage: "Wiik3FC"},
        {name: "King Hit FC", desc: "", saveData: "fc_king hit", awardImage: "Wiik3FC"},
        {name: "TKO FC", desc: "", saveData: "fc_tko", awardImage: "Wiik3FC"},

        {name: "Wiik 100", desc: "Beat Wiik 100", saveData: "beat_wiik 100", awardImage: "Wiik100"},
        {name: "Mat FC", desc: "", saveData: "fc_mat", awardImage: "Wiik100FC"},
        {name: "Banger FC", desc: "", saveData: "fc_banger", awardImage: "Wiik100FC"},
        {name: "Edgy FC", desc: "", saveData: "fc_edgy", awardImage: "Wiik100FC"},

        {name: "Alter Ego FC", desc: "", saveData: "fc_alter ego", awardImage: "AlterEgo"},
        {name: "Rejected FC", desc: "", saveData: "fc_rejected", awardImage: "Rejected"},
        {name: "Rejected VIP", desc: "perroxd", saveData: "beat_rejected vip", awardImage: "Rejected"},
        {name: "Hatarii", desc: "Clear Hatarii", saveData: "beat_hatarii", awardImage: "Rejected"},
    ];

   public static function onBeatWiik(instance:PlayState) {
        var saveStr = "beatComposer_" + PlayState.SONG.song.toLowerCase(); // o storyWeekName 
        onUnlock(saveStr);
        Options.setData(true, saveStr, "progress");
    }


   public static function onBeatSong(instance:PlayState) {
        if (!PlayState.botUsed) {
            var saveStr = 'beat_' + PlayState.SONG.song.toLowerCase();
            onUnlock(saveStr);
            Options.setData(true, saveStr, "progress");

            if (instance.misses == 0) {
                var saveStrFC = 'fc_' + PlayState.SONG.song.toLowerCase();
                trace(saveStrFC);
                onUnlock(saveStrFC);
                Options.setData(true, saveStrFC, "progress");
            }
        }
    }


    public static function getAwardFromSaveDataString(saveStr:String):Award {
        for (award in awards)
            if (award.saveData == saveStr)
                return award;
        return null;
    }

    public static function getAwardImageName(award:Award):String {
        if (award != null && award.awardImage != null)
            return award.awardImage;
        return "default";
    }

    public static function onUnlock(saveStr:String) {
        var award = getAwardFromSaveDataString(saveStr);
        // if (award != null) {
        //     if (Options.getData(award.saveData, "progress") == null)
        //         Main.popupManager.addPopup(new AwardPopup(6, 400, 120, award));
        // }
    }

    public static function isUnlocked(award:Award):Bool {
        if (award != null)
        {
            return Options.getData(award.saveData, "progress") != null;
        }
        return false;
    }

    public static function isAllUnlocked():Bool {
        for (award in awards) {
            if (Options.getData(award.saveData, "progress") == null)
                return false;
        }
        return true;
    }
}

class AwardDisplay extends FlxTypedSpriteGroup<FlxSprite> {
    var border:Array<FlxSprite> = [];

    public function new(award:Award, w:Int = 400, h:Int = 120) {
        super();
        var bg = new FlxSprite().makeGraphic(w, h, FlxColor.BLACK);
        var borderLeft = new FlxSprite(5, 5).makeGraphic(1, h - 10);
        var borderRight = new FlxSprite(w - 5, 5).makeGraphic(1, h - 10);
        var borderUp = new FlxSprite(5, 5).makeGraphic(w - 10, 1);
        var borderDown = new FlxSprite(5, h - 5).makeGraphic(w - 9, 1);
        border.push(borderLeft);
        border.push(borderRight);
        border.push(borderUp);
        border.push(borderDown);

        var name = new FlxText(5, 5, w - 10, award.name);
        name.setFormat(Paths.font("Contb___.ttf"), 32, FlxColor.WHITE, LEFT);
        var desc = new FlxText(5, 45, w - 100, award.desc);
        desc.setFormat(Paths.font("Contb___.ttf"), 16, FlxColor.WHITE, LEFT);

        var imagePath = Paths.image("awards/" + AwardManager.getAwardImageName(award));
        if (!lime.utils.Assets.exists(imagePath))
            imagePath = Paths.image("awards/default");

        var spriteImage = new FlxSprite(0, 10);
        spriteImage.loadGraphic(imagePath);
        spriteImage.setGraphicSize(100, 100);
        spriteImage.updateHitbox();
        spriteImage.x = w - 105;
        spriteImage.antialiasing = true;

        add(bg);
        add(borderLeft); add(borderRight); add(borderUp); add(borderDown);
        add(name);
        add(desc);
        add(spriteImage);

        if (!AwardManager.isUnlocked(award)) {
            var grey = new GreyscaleEffect();
            grey.strength = 1.0;
            grey.update(0);
            spriteImage.shader = grey.shader;
        }
    }

  


    public function setBorderColor(color:FlxColor) {
        for (b in border)
            b.color = color;
    }
}
class AwardsState extends MusicBeatState
{
    var awardDisplays:Array<AwardDisplay> = [];
    var camPos:FlxObject = new FlxObject(0, 0, 1, 1);
    var listHeight:Float = -400;

    var unlockedCount:Int = 0;

    override public function create()
    {
        #if discord_rpc
        // Updating Discord Rich Presence
        MusicBeatState.windowNameSuffix = "Awards Menu";
        DiscordClient.changePresence("In the Awards Menu", null, "empty", "logo");
        #end
        if (FlxG.sound.music == null || FlxG.sound.music.playing != true)
            TitleState.playTitleMusic();

        var bg = new FlxSprite().loadGraphic(Paths.image('Credits/Credits-BG'));
        bg.setGraphicSize(Std.int(1280));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        bg.scrollFactor.set();
        add(bg);

        FlxG.mouse.visible = true;

        camPos.screenCenter();
        FlxG.camera.follow(camPos, LOCKON, 1);

        for (i in 0...AwardManager.awards.length)
        {
            var display:AwardDisplay = new AwardDisplay(AwardManager.awards[i]);
            display.screenCenter(X);
            display.y = 200 + (i*160);
            add(display);
            awardDisplays.push(display);
            listHeight += 160;
            if (AwardManager.isUnlocked(AwardManager.awards[i]))
                unlockedCount++;
        }

        var pageTabsText = new Alphabet(450, 50, "Awards", true, false);
        //pageTabsText.screenCenter();
        var pageTabBG = new FlxSprite(0,0).loadGraphic(Paths.image("freeplay/thing"));
		pageTabBG.screenCenter();
		pageTabBG.y = 20;
		add(pageTabBG);
        add(pageTabsText);
        pageTabsText.scrollFactor.set();
        pageTabBG.scrollFactor.set();

        
        var perc:Float = unlockedCount/AwardManager.awards.length*100;
        perc = FlxMath.roundDecimal(perc, 2);

        var percentage = new FlxText(0, 0,0, perc+"% ("+unlockedCount+"/"+AwardManager.awards.length+")");
        percentage.x = 10;
        percentage.setFormat(Paths.font("Contb___.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        percentage.y = FlxG.height-percentage.height;
        percentage.scrollFactor.set();
        add(percentage);


        var scrollBar:ScrollBar = new ScrollBar(1200, 50, 20, 620, this, "scroll", listHeight);
        add(scrollBar);

        

        super.create();
    }
    var goingBack:Bool = false;
    var scroll:Float = 0.0;
    var grabbed:Bool = false;
    var grabY:Float = 0;
    override function update(elapsed:Float)
    {       
        if (FlxG.sound.music.volume < 0.8)
        {
            FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
        }
        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        if (controls.BACK && !goingBack)
        {
            goingBack = true;
            FlxG.switchState(new MainMenuState());
        }
        var mult:Float = 1.0;
        if (FlxG.keys.pressed.SHIFT)
            mult = 3.0;
        scroll -= FlxG.mouse.wheel*50*elapsed*480*mult;
        if (controls.DOWN)
            scroll += 800*elapsed*mult;
        if (controls.UP)
            scroll -= 800*elapsed*mult;
        camPos.y = FlxMath.lerp(camPos.y, scroll+(FlxG.height*0.5), elapsed*12); //lerp cam pos to scroll

        scroll = FlxMath.bound(scroll, 0, listHeight); //bound

        for (i in awardDisplays)
        {
            if (FlxG.mouse.overlaps(i)) //when hover
                i.setBorderColor(0xFF6E27CA);
            else 
                i.setBorderColor(0xFFFFFFFF);
        }

        

        super.update(elapsed);
    }
}


/**
 * Simple scroll bar that tracks and updates a value
 */
class ScrollBar extends FlxTypedSpriteGroup<FlxSprite>
{
    /**
	 * Object to track value from
	*/
	public var parent:Dynamic;

	/**
	 * Property of parent object to track.
	*/
	public var parentVariable:String;

    public var scrollBar:FlxSprite;
    public var scrollBG:FlxSprite;

    private var grabbed:Bool = false;
    private var grabY:Float = 0.0;
    public var limit:Float = 0.0;
    public function new(X:Float = 0, Y:Float = 0, w:Int = 20, h:Int = 620, ?parentRef:Dynamic, variable:String = "", limit:Float)
    {
        super(X,Y);
        scrollBG = new FlxSprite(0, 0).makeGraphic(w,h, FlxColor.BLACK);
        scrollBar = new FlxSprite(0, 0).makeGraphic(w, 80);
        add(scrollBG);
        add(scrollBar);
        scrollBG.scrollFactor.set();
        scrollBar.scrollFactor.set();
        this.limit = limit;
        if (parentRef != null)
        {
            parent = parentRef;
            parentVariable = variable;
        }
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (parent == null)
            return;

        var value:Float = Reflect.getProperty(parent, parentVariable);

        scrollBar.y = FlxMath.remapToRange(value, 0, limit, scrollBG.y, (scrollBG.y+scrollBG.height)-scrollBar.height); //set y from value

        if (scrollBar.overlapsPoint(FlxG.mouse.getPosition(), true) && FlxG.mouse.justPressed) //grab bar
        {
            grabbed = true;
            grabY = FlxG.mouse.screenY-scrollBar.y;
        }
            
        if (FlxG.mouse.released && grabbed) //ungrab bar
        {
            scrollBar.color = 0xFFFFFFFF;
            grabbed = false;
        }

        if (grabbed)
        {
            scrollBar.y = FlxG.mouse.screenY-grabY; //update bar position with mouse
            scrollBar.color = 0xFF828282;
            scrollBar.y = FlxMath.bound(scrollBar.y, scrollBG.y, (scrollBG.y+scrollBG.height)-scrollBar.height);
        }

        if (!grabbed && scrollBG.overlapsPoint(FlxG.mouse.getPosition(), true) && FlxG.mouse.justPressed) //when you click the black part
        {
            scrollBar.y = FlxG.mouse.screenY;
            scrollBar.y = FlxMath.bound(scrollBar.y, scrollBG.y, (scrollBG.y+scrollBG.height)-scrollBar.height);
        }
        
        value = FlxMath.remapToRange(scrollBar.y, scrollBG.y, (scrollBG.y+scrollBG.height)-scrollBar.height, 0, limit); //remap back after any changes to the bar

        Reflect.setProperty(parent, parentVariable, value); //reset back to parent
    }
    override public function destroy():Void
    {
        scrollBar = null;
        scrollBG = null;
        parent = null;
        super.destroy();
    }
}