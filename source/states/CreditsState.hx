package states;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import openfl.display.BlendMode;
import game.Conductor;
import utilities.DiscordClient;
import ui.HealthIcon;
import ui.FreeplayTxt;
import flixel.sound.FlxSound;
#if (target.threaded)
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
using utilities.BackgroundUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import shaders.VCR;
class CreditsState extends MusicBeatState {
    var rightArrow:FlxSprite;
    public var curSelected:Int = 0;
    public var splashes:FlxSprite; 
    public var songTextBG:FlxSprite; 
    public var ajedrez:FlxBackdrop;
    public var colorTween:FlxTween;
    public var bg:FlxSprite;
    public var vocals:FlxSound = new FlxSound();
    public var menuBG:FlxSprite;
    public var credits:Array<CreditMetadata> = [];
    public var descriptionText:FlxText;
    public var VCRSHADER:VCR; 

    private var creditBackgrounds:Array<{bg:FlxSprite, text:FreeplayTxt}> = [];
    public var grpCredits:FlxTypedGroup<FreeplayTxt>;
    private var iconArray:Array<HealthIcon> = [];
	public var infoText:FlxText;
    #if (target.threaded)
    private var loading_credits:Thread;
    public var stop_loading_credits:Bool = false;
    #end
    
    private var initSonglist:Array<String> = [];
    override public function create():Void {
        MusicBeatState.windowNameSuffix = "Credits Menu";
        var creditsList:Array<String>;

        if (sys.FileSystem.exists("mods/" + Options.getData("curMod") + "/data/creditsList.txt"))
            creditsList = CoolUtil.coolTextFileSys("mods/" + Options.getData("curMod") + "/data/creditsList.txt");
        else if (sys.FileSystem.exists("mods/" + Options.getData("curMod") + "/_append/data/creditsList.txt"))
            creditsList = CoolUtil.coolTextFileSys("mods/" + Options.getData("curMod") + "/_append/data/creditsList.txt");
        else
            creditsList = CoolUtil.coolTextFile(Paths.txt("creditsList"));

        menuBG = new FlxSprite().makeBackground(0xFFea71fd);
        menuBG.scale.set(1.1, 1.1);
        menuBG.updateHitbox();
        menuBG.screenCenter();
        add(menuBG);
        splashes = new FlxSprite().loadGraphic(Paths.gpuBitmap('freeplay/Splashes')); 
        splashes.antialiasing = Options.getData("Multisampling");
        splashes.setGraphicSize(Std.int(splashes.width * 0.34));
        splashes.updateHitbox();

        grpCredits = new FlxTypedGroup<FreeplayTxt>();
        
        bg = new FlxSprite(-80, 0).makeGraphic(FlxG.width + 160, FlxG.height, 0xFDE871);
        bg.scrollFactor.x = 0;
        bg.scrollFactor.y = 0.18;
        bg.scale.set(1.3, 1.3);
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        ajedrez = new FlxBackdrop(FlxGridOverlay.createGrid(30, 30, FlxG.width, FlxG.height, true, FlxColor.BLACK, FlxColor.WHITE));
        ajedrez.blend = BlendMode.ADD;
        ajedrez.scale.set(3, 3);
        ajedrez.alpha = 0.1;
        ajedrez.velocity.set(Conductor.crochet);

        songTextBG = new FlxSprite().loadGraphic(Paths.gpuBitmap('credits/BG')); 
        songTextBG.antialiasing = Options.getData("Multisampling");
        songTextBG.scrollFactor.set();
        songTextBG.updateHitbox();




        add(ajedrez);
        add(splashes);
        add(songTextBG);

   
        add(grpCredits);
  
        
        rightArrow = new FlxSprite(0, 0).loadGraphic(Paths.gpuBitmap("credits/rightArrow")); 
        rightArrow.setGraphicSize(Std.int(rightArrow.width * 1.5));
        rightArrow.updateHitbox();
        rightArrow.scrollFactor.set();
        rightArrow.antialiasing = true;
        add(rightArrow);

        for (i in 0...creditsList.length) {
            if (creditsList[i].trim() != "") {
                var listArray = creditsList[i].split(":");
                var name = listArray[0];  
                var icon = listArray[1];   
                var url = listArray[2]; 
                var des = listArray[3]; 
                credits.push(new CreditMetadata(name, icon, url,des));
            }
        }

        super.create();

        #if (target.threaded)
        if (!Options.getData("loadAsynchronously") || !Options.getData("healthIcons")) {
            for (i in 0...credits.length) {
                var creditMeta = credits[i];
                var creditText:FreeplayTxt = new FreeplayTxt(FlxG.width / 8, (70 * i) + 30, creditMeta.name, true, false);
                //creditText.screenCenter(FlxAxes.X);
                creditText.scrollFactor.set();
                creditText.isMenuItem = true;
                creditText.targetY = i;

                var creditBg = new FlxSprite(0, creditText.y).makeGraphic(FlxG.width, 70, FlxColor.TRANSPARENT);
                creditBg.alpha = 0.5;
                creditBackgrounds.push({ bg: creditBg, text: creditText });
                insert(2, creditBg);

                grpCredits.add(creditText);

                descriptionText = new FlxText(songTextBG.x + 900, songTextBG.y + 250, 300, "", 12);
                descriptionText.setFormat(Paths.font("Mii.ttf"), 48, FlxColor.BLACK, LEFT);
                descriptionText.wordWrap = true;
                descriptionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 2);
                descriptionText.autoSize = false;
                descriptionText.scrollFactor.set();
                add(descriptionText);

                
                if (Options.getData("healthIcons")) {
                    var icon:HealthIcon = new HealthIcon(creditMeta.icon);
                    icon.setGraphicSize(Std.int(icon.width * 1.5));
                    icon.updateHitbox();
                    icon.antialiasing = true;
                    icon.setPosition(900,10);
                    icon.scrollFactor.set();
                    icon.alpha = 0;
                    iconArray.push(icon);
                    add(icon);
                }
            }
        }
        #else
        loading_credits = Thread.create(function() {
            var i:Int = 0;
            while (!stop_loading_credits && i < credits.length) {
                var creditMeta = credits[i];
                var creditText:FreeplayTxt = new FreeplayTxt(FlxG.width / 8, (70 * i) + 30, creditMeta.name, true, false);
                creditText.scrollFactor.set();
                creditText.isMenuItem = true;
                creditText.targetY = i;

                var creditBg = new FlxSprite(0, creditText.y).makeGraphic(FlxG.width, 80, FlxColor.TRANSPARENT);
                creditBg.alpha = 0.8;
                creditBackgrounds.push({ bg: creditBg, text: creditText });
                insert(2, creditBg);

                grpCredits.add(creditText);

                var icon:HealthIcon = new HealthIcon(creditMeta.icon);
                icon.setGraphicSize(Std.int(icon.width * 1.5));
                icon.updateHitbox();
                icon.scrollFactor.set();
                icon.alpha = 0;
                icon.antialiasing = true;
                icon.setPosition(850,10);
                iconArray.push(icon);
                add(icon);

                i++;
            }
        });
        #end

        DiscordClient.changePresence("In the Credits Menu", null);

		
        VCRSHADER = new VCR();
        var vignettelol = new FlxSprite(0,0);
        vignettelol.makeGraphic(FlxG.width, FlxG.height); 
        vignettelol.blend = "multiply"; 
        //vignettelol.alpha = 0.3;
        vignettelol.shader = VCRSHADER.shader;
        vignettelol.scrollFactor.set();
        add(vignettelol);
        

        var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, FlxColor.BLACK);
		textBG.alpha = 0.6;
		add(textBG);


		var leText:String = "Press ENTER to the page of the people who helped in the collection";

		infoText = new FlxText(textBG.x - 1, textBG.y + 4, FlxG.width, leText, 18);
		infoText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		infoText.scrollFactor.set();
		infoText.screenCenter(X);
		add(infoText);


    }
    var time:Float = 0;
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
       
        VCRSHADER.time += elapsed;

        if (FlxG.keys.justPressed.TAB) {
			openSubState(new modding.SwitchModSubstate());
			persistentUpdate = false;
		}
    
        if (controls.BACK) {
            FlxG.switchState(new MainMenuState());
        }
    
        if (controls.UP_P || FlxG.mouse.wheel > 0) {
            curSelected = FlxMath.wrap(curSelected - 1, 0, grpCredits.length - 1);
            updateCreditPositions();
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        }
    
        if (controls.DOWN_P || FlxG.mouse.wheel < 0) {
            curSelected = FlxMath.wrap(curSelected + 1, 0, grpCredits.length - 1);
            updateCreditPositions();
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        }
    
        var bullShit:Int = 0;
        for (item in grpCredits.members) {
            if (bullShit == curSelected) {

                rightArrow.y = FlxMath.lerp(rightArrow.y, item.y - 15, 0.1); 
            }
        
            item.targetY = FlxMath.lerp(item.targetY, bullShit - curSelected, 0.1);
            item.alpha = FlxMath.lerp(item.alpha, bullShit == curSelected ? 1 : 0.35, 0.1);
        
            bullShit++;
        }
        
        
    
        for (i in 0...creditBackgrounds.length) {
            var credit = creditBackgrounds[i];
            var txt = credit.text;
            var bg = credit.bg;
    
            bg.y = FlxMath.lerp(bg.y, 360 + (txt.targetY * 100), 0.1);
            txt.y = FlxMath.lerp(txt.y, bg.y + 10, 0.1);
        }

        for (i in 0...iconArray.length) {
            if (i == curSelected) {
              
                if (credits[curSelected].des != null && credits[curSelected].des != "") {
                    var description = credits[curSelected].des.split(","); 
                    descriptionText.text = description.join("\n\n"); 
                } else {
                    descriptionText.text = "Is a Perroxd";
                }
        
                iconArray[i].alpha = FlxMath.lerp(iconArray[i].alpha, 1, 0.1); // Icono visible
            } else {
                iconArray[i].alpha = FlxMath.lerp(iconArray[i].alpha, 0, 0.1); // Iconos ocultos
            }
        }
        
        
    
        if (controls.ACCEPT) {
            var selectedCredit = credits[curSelected];
            if (selectedCredit.url != null && selectedCredit.url != "") {
                #if desktop
                lime.system.System.openURL(selectedCredit.url);
                #end
            }
        }
    } 
    
    
    private function updateCreditPositions():Void {
        var alpha:Float = 0.1; 
    
        var bullShit:Int = 0;
        for (item in grpCredits.members) {
            var targetYPos:Int = Std.int(FlxMath.wrap(bullShit - curSelected, 0, grpCredits.length - 1));
            item.targetY = FlxMath.lerp(item.targetY, targetYPos, alpha);

            bullShit++;
        }
    }
    
    
    
    
    
}

class CreditMetadata {
    public var name:String = "";
    public var icon:String = "";  
    public var url:String = "";   
    public var des:String = "";   

    public function new(name:String, icon:String, url:String, des:String) {
        this.name = name;
        this.icon = icon;
        this.url = url;
        this.des = des;
    }
}

