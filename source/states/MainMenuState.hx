package states;

#if DISCORD_ALLOWED
import utilities.DiscordClient;
#end
#if MODDING_ALLOWED
import modding.PolymodHandler;
#end
import modding.scripts.languages.HScript;
import flixel.system.debug.interaction.tools.Tool;
import utilities.Options;
import flixel.util.FlxTimer;
import utilities.MusicUtilities;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import game.Conductor;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import openfl.display.BlendMode;
import states.AwardsState;

using utilities.BackgroundUtil;
import states.AwardsState.AwardDisplay;
import states.AwardsState.AwardManager;
class MainMenuState extends MusicBeatState {
	/**
		Current instance of `MainMenuState`.
	**/
	public static var instance:MainMenuState = null;

	static var curSelected:Int = 0;

	public var menuItems:FlxTypedGroup<FlxSprite>; 
	public var textItems:FlxTypedGroup<FlxText>;  
	public var BG2:FlxSprite; 
	public var ajedrez:FlxBackdrop;
	public var optionShit:Array<String> = ['FREEPLAY', 'OPTIONS', 'CREDITS','AWARDS'];

	public var bfsItems:Array<FlxSprite> = []; 
	public var selectedImage:FlxSprite;

	public var logolol:FlxSprite; 
	public var camFollow:FlxObject;

	//public var perroxd:FlxSprite;
	//public var bfs:FlxSprite;
	override public function call(func:String, ?args:Array<Any>, ?executeOn:Dynamic):Void {
		if (stateScript != null)
			stateScript.call(func, args);
	}
	public function loadButtons(type:String) {
		selectedImage = new FlxSprite(0, 0);
	  
		switch (type) {
			case "bg":
				var list:Array<String> = ["1", "2", "3", "4"];
				var suffix:String = "_" + list[FlxG.random.int(0, list.length - 1)];
				selectedImage.loadGraphic(Paths.gpuBitmap('mainmenu/' + type.toUpperCase() + suffix));
		}
	
		selectedImage.setGraphicSize(FlxG.width, FlxG.height);
		selectedImage.scrollFactor.set(0, 0);
		selectedImage.updateHitbox();
		add(selectedImage);
	}
	
	public override function create() {
		super.create();
		instance = this;

		#if MODDING_ALLOWED
		if (PolymodHandler.metadataArrays.length > 0)
			optionShit.push('MODS');
		#end

		if (Options.getData("developer"))
			optionShit.push('TOOLBOX');

		call("buttonsAdded");

		MusicBeatState.windowNameSuffix = "";

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music == null || !FlxG.sound.music.playing || OptionsMenu.playing) {
			OptionsMenu.playing = false;
			TitleState.playTitleMusic();
		}

		persistentUpdate = persistentDraw = true;



		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		loadButtons("bg");
		


	
		ajedrez = new FlxBackdrop(FlxGridOverlay.createGrid(30, 30, FlxG.width, FlxG.height, true, FlxColor.BLACK, FlxColor.WHITE));
        ajedrez.blend = BlendMode.ADD;
        ajedrez.scale.set(3, 3);
        ajedrez.alpha = 0.1;
        ajedrez.velocity.set(Conductor.crochet);
		add(ajedrez);

		BG2 = new FlxSprite().loadGraphic(Paths.gpuBitmap('mainmenu/BG2')); 
		BG2.antialiasing = Options.getData("Multisampling ");
		BG2.setGraphicSize(FlxG.width, FlxG.height);
		BG2.scrollFactor.set(0, 0);
		BG2.updateHitbox();
		add(BG2);


		var barraarriba = new FlxSprite(0, 0).makeGraphic(FlxG.width, 50, 0xB0000000); 
		barraarriba.scrollFactor.set(0, 0);
		add(barraarriba);
		
		var barraabajo = new FlxSprite(0, FlxG.height - 50).makeGraphic(FlxG.width, 50, 0xB0000000); 
		barraabajo.scrollFactor.set(0, 0);
		add(barraabajo);
		


	
		logolol = new FlxSprite();
		logolol.frames = Paths.getSparrowAtlas('title/logoBumpin');
		logolol.animation.addByPrefix("logo bumpin", "logo bumpin", 24, true);
		logolol.animation.play("logo bumpin");
		logolol.scrollFactor.set(0, 0);
		logolol.antialiasing = Options.getData("Multisampling ");
		logolol.setGraphicSize(Std.int(logolol.width * 0.6));
		logolol.updateHitbox();
		logolol.x = 100;  
		logolol.y = 100;
		
	
		add(logolol);


		menuItems = new FlxTypedGroup<FlxSprite>();
		textItems = new FlxTypedGroup<FlxText>();
		
	

		for (i in 0...optionShit.length) {
			var baseX = 800; 
			var offsetX = - (i * 30); 
		
			var posX = baseX + offsetX; 
			var posY = 100 + (i * 90); 
			var offsetText = 20;
			var offsetTextX = 100;
		
			/*var bfs:FlxSprite = new FlxSprite(posX, 265 + (i * 90));
			bfs.loadGraphic(Paths.image("BF B-side"));
			bfs.setGraphicSize(Std.int(bfs.width * 0.6));
			bfs.updateHitbox();
			bfs.scrollFactor.set(0, 0);
			bfs.ID = i;
			bfsItems.push(bfs);
			menuItems.add(bfs);
			*/
		
			var menuItem:FlxText = new FlxText(posX + offsetTextX, posY + offsetText, 0, optionShit[i], 48);
			menuItem.setFormat(Paths.font("EurostileExtendedBlack.ttf"), 64, FlxColor.BLACK, LEFT);
			menuItem.borderStyle = FlxTextBorderStyle.OUTLINE;
			menuItem.borderColor = FlxColor.WHITE;
			menuItem.borderSize = 2;
			menuItem.ID = i;
			textItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0);
		}
		
		
		
		
		
		add(menuItems);
		add(textItems);
	
		


		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(0, FlxG.height - 18, 0, TitleState.version + " - Dark's Collection V3 ", 16);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		add(versionShit);

		#if MODDING_ALLOWED
		var switchInfo:FlxText = new FlxText(0, versionShit.y - versionShit.height, 0, 'Hit TAB to switch mods.', 16);
		switchInfo.scrollFactor.set();
		switchInfo.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		add(switchInfo);

		var modInfo:FlxText = new FlxText(0, switchInfo.y - switchInfo.height, 0,
			'${modding.PolymodHandler.metadataArrays.length} mods loaded, ${modding.ModList.getActiveMods(modding.PolymodHandler.metadataArrays).length} mods active.',
			16);
		modInfo.scrollFactor.set();
		modInfo.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		add(modInfo);
		#end

		changeItem();

		super.create();

		call("createPost");
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		for (txt in textItems) {
			var targetScale = (txt.ID == curSelected) ? 1.2 : 1.0; 
			var targetAlpha = (txt.ID == curSelected) ? 1.0 : 0.5;
		
			txt.scale.x += (targetScale - txt.scale.x) * 0.1;
			txt.scale.y += (targetScale - txt.scale.y) * 0.1;
			txt.alpha += (targetAlpha - txt.alpha) * 0.1; 
		}
		
		
	    /*
		for (bfs in bfsItems) {
			var targetX = (bfs.ID == curSelected) ? 20 : -100;
			bfs.x += (targetX - bfs.x) * 0.1; 
		}	*/
		#if sys
		if (!selectedSomethin && FlxG.keys.justPressed.TAB) {
			openSubState(new modding.SwitchModSubstate());
			persistentUpdate = false;
		}
		#end

		#if (flixel < "6.0.0")
		FlxG.camera.followLerp = elapsed * 3.6;
		#end

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!selectedSomethin) {
			if (-1 * Math.floor(FlxG.mouse.wheel) != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1 * Math.floor(FlxG.mouse.wheel));
			}

			if (controls.UP_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.camera.flash(FlxColor.WHITE, 0.5);
				
				/*if (curSelected >= 0 && curSelected < bfsItems.length) {
					//var bfs = bfsItems[curSelected]; 
					//bfs.loadGraphic(Paths.image("BF B-Side Lose"));
				    //	bfs.updateHitbox();
				
					if (Options.getData("flashingLights")) {
						FlxFlicker.flicker(bfs, 1, 0.06, false, false, (_) -> selectCurrent());
					} else {
						new FlxTimer().start(1, (_) -> selectCurrent(), 1);
					}
				}	*/
				
				
				textItems.forEach(function(txt:FlxText) {
					if (curSelected != txt.ID) {
						FlxTween.tween(txt, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: (_) -> txt.kill()
						});
					} else {
						if (Options.getData("flashingLights")) {
							FlxFlicker.flicker(txt, 1, 0.06, false, false, (_) -> selectCurrent());
						} else {
							new FlxTimer().start(1, (_) -> selectCurrent(), 1);
						}
					}
				});
				
			}

			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(() -> new TitleState());
			}
		}

		call("update", [elapsed]);



		call("updatePost", [elapsed]);

		
	}

	
	
	
	
	function selectCurrent() {
		var selectedButton:String = optionShit[curSelected];

		switch (selectedButton) {
			case 'story mode':
				FlxG.switchState(() -> new StoryMenuState());

			case 'FREEPLAY':
				FlxG.switchState(() -> new FreeplayState());

			case 'OPTIONS':
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(() -> new OptionsMenu());

			#if MODDING_ALLOWED
			case 'MODS':
				FlxG.switchState(() -> new ModsMenu());
			#end
			case 'CREDITS':
				FlxG.switchState(() -> new CreditsState());
			case 'AWARDS':
				FlxG.switchState(() -> new AwardsState());
			case 'TOOLBOX':
				FlxG.switchState(() -> new toolbox.ToolboxState());
		}
		call("changeState");
	}
	function changeItem(itemChange:Int = 0) {
		curSelected += itemChange;
	
		if (curSelected >= textItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = textItems.length - 1;
	
		call("changeItem", [itemChange]);
	}
	
}
