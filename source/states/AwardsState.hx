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
import utilities.StarLoader;
import shaders.VCR;
import substates.StarInfoSubState;
typedef Award = {
    var name:String;
    var desc:String;
    var saveData:String;
    var ?awardImage:Null<String>;
}

class AwardManager {
    public static final awards:Array<Award> = [
        { name: "First Gold", desc: "Earn at least 1 gold star", saveData: "get_1_gold_star", awardImage: "Gold Star Total" },
        { name: "Blue Collection", desc: "Earn at least 3 blue stars", saveData: "get_3_blue_star", awardImage: "Blue Star Total" },
        { name: "Pinky Rose", desc: "Earn at least 5 rose stars", saveData: "get_5_rose_star", awardImage: "Rose Star Total" },
        { name: "Gold Fan", desc: "Earn 10 gold stars", saveData: "get_10_gold_star", awardImage: "Gold Star Total" },
        { name: "Blue Fan", desc: "Earn 15 blue stars", saveData: "get_15_blue_star", awardImage: "Blue Star Total" },
        { name: "Rose Fan2", desc: "Earn 20 rose stars", saveData: "beat_pandemonium", awardImage: "Rose Star Total" },
        { name: "Rose Fan3", desc: "Earn 20 rose stars", saveData: "beat_pandemonium,beat_king hit ps", awardImage: "Rose Star Total" },
         { name: "Rose Fan", desc: "Earn 20 rose stars", saveData: "beat_vc galactic storm,beat_frenetic", awardImage: "Rose Star Total" },
        {name: "PURGATORY TRIPLE GOD", desc: "Clear Purgatory Imposible", saveData: "beat_purgatory imposible", awardImage: "Purgatory"},
        {name: "DIVINE PARADOX?!?", desc: "Clear Divine Paradox God Mode", saveData: "beat_divine paradox", awardImage: "Divine"},
        {name: "AKWR V3", desc: "Clear AKWR FD God Mode", saveData: "beat_ak wr fd", awardImage: "AKWR"},
        {name: "FD SIGMA", desc: "Clear Evolved Final Destination", saveData: "beat_evolved final destination end mix", awardImage: "Evolved"},
        {name: "Ivano", desc: "Clear All Ivano Drako Songs", saveData: "beat_vc veteran,beat_fs rejected", awardImage: "Ivano"},
        {name: "VC Clears", desc: "Clear All Songs That Begin With VC", saveData: "beat_zagreus,beat_wastelands", awardImage: "VC"},
        {name: "PS Clears", desc: "Clear All Songs That Begin With PS", saveData: "beat_zagreus,beat_wastelands", awardImage: "VC"},

        {name: "Godly Rejected FC", desc: "", saveData: "fc_vc rejected", awardImage: "Rejected"},
        {name: "Rejected UNT0LD FC", desc: "", saveData: "fc_rejected ps", awardImage: "Unt0ld"},
        {name: "FS Rejected FC", desc: "", saveData: "fc_fs rejected", awardImage: "FS Rejected"},

        {name: "Rejected VIP PROS", desc: "Make FC Rejected VIP", saveData: "fc_rejected vip", awardImage: "RejectedVIP"},
        {name: "Alter Ego VIP PROS", desc: "Make FC Alter Ego VIP", saveData: "fc_alter ego vip", awardImage: "Wiik2"},
        {name: "TKO VIP PROS", desc: "Make FC TKO VIP", saveData: "fc_tko vip", awardImage: "Wiik3"},

        {name: "LordNudes", desc: "Clear All Lordv***d Songs", saveData: "beat_rejected vip,beat_wastelands,beat_zagreus,beat_remazed,beat_pandemonium,beat_defamation of reality,beat_final timeout,beat_radical showdown,beat_tko vip,beat_alter ego vip,beat_vc champion,beat_vc last combat,beat_vc disadvantage,beat_total bravery,beat_vc rejected,beat_vc cosmic memories,beat_vc galactic storm", awardImage: "Rejected"},
        {name: "EXTRAS?!?", desc: "Clear All Extras Songs", saveData: "beat_vc final destination,beat_ayuda no puedo parar de escuchar esta parte", awardImage: "Rejected"},
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

    public static function addStars(instance:PlayState) {
        if (!PlayState.botUsed) {
            if (instance.accuracy >= 95) {
                var roseStr = 'rose_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                var blueStr = 'blue_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                var goldStr = 'gold_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                trace(roseStr);
                trace(blueStr);
                trace(goldStr);
                Options.setData(true, roseStr, "progress");
                Options.setData(true, blueStr, "progress");
                Options.setData(true, goldStr, "progress");
                // checkStarAwards();
            } else if (instance.accuracy >= 90) {
                var roseStr = 'rose_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                var blueStr = 'blue_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                trace(roseStr);
                trace(blueStr);
                Options.setData(true, roseStr, "progress");
                Options.setData(true, blueStr, "progress");
                // checkStarAwards();
            } else if (instance.accuracy >= 80) {
                var roseStr = 'rose_' + PlayState.SONG.song.toLowerCase() + "_" + PlayState.storyDifficultyStr.toLowerCase();
                trace(roseStr);
                Options.setData(true, roseStr, "progress");
                // checkStarAwards();
            }
        }
    }
    public static function checkMultiClears(instance:PlayState) {
        for (award in awards) {
            if (award.saveData.indexOf(",") != -1) { 
                var saves = award.saveData.split(",");
                var allCleared = true;
                for (s in saves) {
                    var save = s.trim();
                    var cleared = Options.getData(save, "progress");
                   // if (cleared) {
                        //trace('Completado: ' + save);
                    //} else {
                        //trace('Faltante: ' + save);
                        //allCleared = false;
                    //}
                }
                if (allCleared && !isUnlocked(award)) {
                    //trace('Premio desbloqueado: ' + award.name);
                    Options.setData(true, "award_" + award.name, "progress");
                    onUnlock(award.saveData);
                } //else if (allCleared) {
                   // trace('Ya estaba desbloqueado: ' + award.name);
                //}
            }
        }
    }


    public static function getAwardFromSaveDataString(saveStr:String):Award {
        for (award in awards) {
            var parts = award.saveData.split(',');
            for (part in parts) {
                if (part.trim() == saveStr) {
                    return award;
                }
            }
        }
        return null;
    }


    public static function getAwardImageName(award:Award):String {
        if (award != null && award.awardImage != null)
            return award.awardImage;
        return "default";
    }

   public static function onUnlock(saveStr:String) {
        var award = getAwardFromSaveDataString(saveStr);
        if (award != null) {
            if (award.saveData.indexOf(",") != -1) {
                var saves = award.saveData.split(",");
                var allCleared = true;
                for (s in saves) {
                    if (!Options.getData(s.trim(), "progress")) {
                        allCleared = false;
                        break;
                    }
                }
                if (allCleared && !Options.getData("award_" + award.name, "progress")) {
                    Options.setData(true, "award_" + award.name, "progress");
                    Main.popupManager.addPopup(new AwardPopup(6, 400, 120, award));
                }
            } else {
                //individual
                if (!Options.getData(award.saveData, "progress")) {
                    Options.setData(true, award.saveData, "progress");
                    Main.popupManager.addPopup(new AwardPopup(6, 400, 120, award));
                }
            }
        }
    }


        
    

    public static function isUnlocked(award:Award):Bool {
        if (award != null) {
            if (award.saveData.indexOf(",") != -1) {
                return Options.getData("award_" + award.name, "progress") != null;
            }

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
    public var VCRSHADER:VCR;
    override public function create()
    {
        #if discord_rpc
        // Updating Discord Rich Presence
        MusicBeatState.windowNameSuffix = "Awards Menu";
        DiscordClient.changePresence("In the Awards Menu", null);
        #end
        if (FlxG.sound.music == null || FlxG.sound.music.playing != true)
            TitleState.playTitleMusic();


        VCRSHADER = new VCR();
        var bg = new FlxSprite().loadGraphic(Paths.image('Credits/Credits-BG'));
        bg.setGraphicSize(Std.int(1280));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        bg.scrollFactor.set();
        bg.shader = VCRSHADER.shader;
        add(bg);

        FlxG.mouse.visible = true;

        camPos.screenCenter();
        FlxG.camera.follow(camPos, LOCKON, 1);

   

        for (i in 0...AwardManager.awards.length)
        {
            var display:AwardDisplay = new AwardDisplay(AwardManager.awards[i]);

            var columna = i % 2; 
            var fila = Std.int(i / 2); 

            display.x = 180 + (columna * 500);
            display.y = 200 + (fila * 200);

            add(display);
            awardDisplays.push(display);
            listHeight += 200;

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
        var time:Float = 0;
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
                i.setBorderColor(0xFF00FF00);
            else 
                i.setBorderColor(0xFFFFFFFF);
        }

        

        super.update(elapsed);

        VCRSHADER.time += elapsed;
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