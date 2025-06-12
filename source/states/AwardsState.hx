package states;

import ui.Alphabet;
import flixel.math.FlxMath;
import game.Conductor;
import flixel.FlxObject;
#if DISCORD_ALLOWED
import utilities.DiscordClient;
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
        //godmodes or songs longs
        {name: "Rejected VIP", desc: "Clear Rejected VIP", saveData: "beat_rejected vip", awardImage: "RejectedVIP"},
        {name: "PURGATORY TRIPLE GOD", desc: "Clear Purgatory Imposible", saveData: "beat_purgatory imposible", awardImage: "Purgatory"},
        {name: "MULTIVERSE", desc: "Clear Multiverse Destination", saveData: "beat_multiverse destination", awardImage: "Multiverse"},
        {name: "DIVINE PARADOX?!?", desc: "Clear Divine Paradox God Mode", saveData: "beat_divine paradox", awardImage: "Divine"},
        {name: "AKWR V3", desc: "Clear AKWR FD God Mode", saveData: "beat_ak and wr fd", awardImage: "AKWR"},
        {name: "FD SIGMA", desc: "Clear Evolved Final Destination", saveData: "beat_evolved final destination end mix", awardImage: "Evolved"},
        {name: "UI OMG", desc: "Clear Unlimited Instinct Infinite Mode", saveData: "beat_unlimited instinct", awardImage: "UI"},
        //composers
        {name: "Antarkh", desc: "Clear All Antarkh Songs", saveData: "beat_harsh reality", awardImage: "Antarkh"},
        {name: "Armando", desc: "Clear All Armando The Anima Songs", saveData: "beat_god fury", awardImage: "Armando"},
        {name: "Aura", desc: "Clear All Kat Songs", saveData: "beat_hell usurper,beat_irreverence", awardImage: "Aura"},
        {name: "Bruhitscc", desc: "Clear All Bruhitscc Songs", saveData: "beat_galaxy demons", awardImage: "Bruhitscc"},
        {name: "Dex", desc: "Clear All Dex Songs", saveData: "beat_limitless remake,beat_final stand remix", awardImage: "Dex"},
        {name: "Dredre", desc: "Clear All Dredre Songs", saveData: "beat_vc intervention,beat_vc haven", awardImage: "Dre"},
        {name: "Feak", desc: "Clear All Feak Songs", saveData: "beat_haven,beat_divine paradox,beat_trip", awardImage: "Feak"},
        {name: "FerX", desc: "Clear All FerX Songs", saveData: "beat_reconciled", awardImage: "FerX"},
        {name: "Goofy", desc: "Clear All Goofy Goobert Songs", saveData: "beat_ds final destination", awardImage: "Goofy"},
        {name: "Invalid", desc: "Clear All Invalid Bruh Songs", saveData: "beat_dance party,beat_alarmiing,beat_priimunus,beat_mattpurgation", awardImage: "Invalid"},
        {name: "Paper", desc: "Clear All Paper Songs", saveData: "beat_veteran,beat_warriors,beat_old vc sporting,beat_king hit ps,beat_alter ego ps,beat_rejected ps,beat_final destination ps,beat_ak and wr fd", awardImage: "Paper"},
        {name: "Ivano", desc: "Clear All Ivano Drako Songs", saveData: "beat_vc veteran,beat_fs rejected", awardImage: "Ivano"},
        {name: "Leader", desc: "Clear All Leader Songs", saveData: "beat_super saiyan 3", awardImage: "Leader"},
        {name: "LordNudes", desc: "Clear All Lordv***d Songs", saveData: "beat_rejected vip,beat_wastelands,beat_zagreus,beat_remazed,beat_pandemonium,beat_defamation of reality,beat_final timeout,beat_radical showdown,beat_tko vip,beat_alter ego vip,beat_vc champion,beat_vc last combat,beat_vc disadvantage,beat_total bravery,beat_vc rejected,beat_vc cosmic memories,beat_vc galactic storm", awardImage: "Rejected"},
        {name: "LumiOff", desc: "Clear All LumiOff Songs", saveData: "beat_evolved destination end mix,beat_final destination,beat_unlimited instinct,beat_godified destruction double god,beat_andromeda devourer,beat_vc ultra instinct tomz,beat_vs final destination,beat_cheater suffering", awardImage: "Lumi"},
        {name: "Nerdy", desc: "Clear All Nerdy Songs", saveData: "beat_galactic conqueror,beat_mystery terrors", awardImage: "Nerdy"},
        {name: "NK", desc: "Clear All NK Songs", saveData: "beat_final round,beat_final boss,beat_wind up,beat_haxchi", awardImage: "NK"},
        {name: "OmarJotaro", desc: "Clear All OmarJotaro Songs", saveData: "beat_god mode instinct", awardImage: "Nerdy"},
        {name: "Dodo", desc: "Clear All Real Dodo Songs", saveData: "beat_frenetic,beat_cleverness,beat_gunpowder,beat_vc harsh reality,beat_vc eruption,beat_vc kaioken,beat_vc dojo,beat_vc blast,beat_vc astral calamity,beat_vc mild mania,beat_vc ahp", awardImage: "Dodo"},
        {name: "Rev", desc: "Clear All Revilo Songs", saveData: "beat_rev sporting,beat_fight it up,beat_rev ballin,beat_calamiity", awardImage: "Rev"},
        {name: "ShaggyFan23", desc: "Clear All ShaggyFan23 Songs", saveData: "beat_spiral dismay", awardImage: "Shaggy"},
        {name: "Simpie", desc: "Clear All Simpie Songs", saveData: "beat_zeniith,beat_vc cosmic truth,beat_sedate,beat_above and beyond", awardImage: "Simpie"},
        {name: "Tbizzle", desc: "Clear All TB Songs", saveData: "beat_colsfoot catastrophe,beat_final mashup destination,beat_hyper destination 3,beat_hyper destination x,beat_immortaly hatred,beat_mighty gods,beat_universe invaders", awardImage: "TB"},
        {name: "TheViDuelty", desc: "Clear All TheViDuelty Songs", saveData: "beat_sxm target practice,beat_sxm synergy,beat_multiverse destination", awardImage: "TVD"},
        {name: "Tomz", desc: "Clear All Tomz Songs", saveData: "beat_game over", awardImage: "Tomz"},
        {name: "Delta", desc: "Clear All Delta Songs", saveData: "beat_your personal hell,beat_hatarii,beat_last resort,beat_final destination moai", awardImage: "Delta"},
        {name: "EXTRAS?!?", desc: "Clear All Extras Songs", saveData: "beat_vc final destination,beat_ayuda no puedo parar de escuchar esta parte", awardImage: "Extras"},
        // logos clears
        {name: "VC Clears", desc: "Clear All Voiid Chronicles Songs", saveData: "beat_vc final destination,beat_vc rejected,beat_vc cosmic memories,beat_vc galactic storm,beat_vc disadvantage,beat_vc champion,beat_vc last combat,beat_alter ego vip,beat_tko vip,beat_radical showdown,beat_defamation of reality,beat_rejected vip,beat_vc veteran,beat_old vc sporting,beat_mattpurgation,beat_wastelands", awardImage: "VC"},
        {name: "PS Clears", desc: "Clear All Paper Stories Songs", saveData: "beat_king hit ps,beat_alter ego ps,beat_rejected ps,beat_final destination ps", awardImage: "PS"},
        {name: "Rev Clears", desc: "Clear Rev Mixed Songs", saveData: "beat_rev sporting,beat_fight it up,beat_rev ballin", awardImage: "Rev"},
        {name: "Corruption Clears", desc: "Clear Corruption Reborn Songs", saveData: "beat_alarmiing,beat_haxchi,beat_your personal hell,beat_zeniith,beat_calamiity,beat_hatarii,beat_last resort", awardImage: "CR"},
        {name: "Shaggy's Story", desc: "Clear Shaggys's Story Songs", saveData: "beat_vc eruption,beat_vc kaioken,beat_vc dojo,beat_vc blast,beat_vc astral calamity,beat_vc mild mania,beat_vc ahp", awardImage: "ShaggyVC"},
        // fcs
        {name: "Mattpurgation FC", desc: "", saveData: "fc_mattpurgation", awardImage: "GodMatt"},
        {name: "Godly Rejected FC", desc: "", saveData: "fc_vc rejected", awardImage: "Rejected"},
        {name: "Rejected UNT0LD FC", desc: "", saveData: "fc_rejected ps", awardImage: "Unt0ld"},
        {name: "FS Rejected FC", desc: "", saveData: "fc_fs rejected", awardImage: "FS Rejected"},
        {name: "The Best FD", desc: "Make FC VC Final Destination", saveData: "fc_vc final destination", awardImage: "fdgodvip"},
        {name: "Rejected VIP PROS", desc: "Make FC Rejected VIP", saveData: "fc_rejected vip", awardImage: "RejectedVIP"},
        {name: "Alter Ego VIP PROS", desc: "Make FC Alter Ego VIP", saveData: "fc_alter ego vip", awardImage: "Wiik2"},
        {name: "TKO VIP PROS", desc: "Make FC TKO VIP", saveData: "fc_tko vip", awardImage: "Wiik3"},

    ];

   public static function onBeatWiik(instance:PlayState) {
        var saveStr = "beatComposer_" + PlayState.SONG.song.toLowerCase(); // o storyWeekName 
        onUnlock(saveStr);
        Options.setData(true, saveStr, "progress");
    }


   public static function onBeatSong(instance:PlayState) {
        if (PlayState.SONG.validScore) {
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
        if (PlayState.SONG.validScore) {
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
        #if DISCORD_ALLOWED
        // Updating Discord Rich Presence
        MusicBeatState.windowNameSuffix = " Awards Menu";
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
             

            listHeight = Math.max(listHeight, display.y);
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