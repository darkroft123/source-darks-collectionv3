package states;

import utilities.MusicUtilities;
import ui.Option;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets;

using utilities.BackgroundUtil;

class OptionsMenu extends MusicBeatState {
	public var curSelected:Int = 0;

	public var inMenu = false;

	public var pages:Map<String, Array<Option>> = [
		"Categories" => [
			new PageOption("Mod Options", "Mod Options"),
			new PageOption("Gameplay", "Gameplay", "Test Description"),
			new PageOption("Graphics", "Graphics"),
			new PageOption("Misc", "Misc"),
			new PageOption("Developer Options", "Developer Options")
		],
		"Gameplay" => [
			new PageOption("Back", "Categories"),
			new GameSubStateOption("Binds", substates.ControlMenuSubstate),
			new BoolOption("Key Bind Reminders", "extraKeyReminders"),
			new GameSubStateOption("Song Offset", substates.SongOffsetMenu),
			new PageOption("Judgements", "Judgements"),
			new PageOption("Input Options", "Input Options"),
			new BoolOption("Downscroll", "downscroll"),
			new BoolOption("Middlescroll", "middlescroll"),
			new BoolOption("Bot", "botplay"),
			new BoolOption("Quick Restart", "quickRestart"),
			new BoolOption("No Death", "noDeath"),
			new BoolOption("Freeplay Black BG", "FreeplayBlackBG"),
			new BoolOption("Use Custom Scrollspeed", "useCustomScrollSpeed"),
			new GameSubStateOption("Custom Scroll Speed", substates.ScrollSpeedMenu),
			new StringSaveOption("Hitsound", CoolUtil.coolTextFile(Paths.txt("hitsoundList")), "hitsound")
		],
		"Graphics" => [
			new PageOption("Back", "Categories"),
			new PageOption("Note Options", "Note Options"),
			new PageOption("Info Display", "Info Display"),
			new PageOption("Optimizations", "Optimizations"),
			new GameSubStateOption("Max FPS", substates.MaxFPSMenu),
			new BoolOption("VSync", "vSync"),
			new BoolOption("Bigger Score Text", "biggerScoreInfo"),
			new BoolOption("Bigger Info Text", "biggerInfoText"),
			new StringSaveOption("Time Bar Style", ["leather engine", "psych engine", "old kade engine"], "timeBarStyle"),
			new PageOption("Screen Effects", "Screen Effects"),
			new GameStateOption("Change Hud Settings", () -> new ui.HUDAdjustment())
		],
		"Misc" => [
			new PageOption("Back", "Categories"),
			new BoolOption("Prototype Title Screen", "oldTitle"),
			new BoolOption("Friday Night Title Music", "nightMusic"),
			new BoolOption("Freeplay Music", "freeplayMusic"),
			#if DISCORD_ALLOWED
			new BoolOption("Discord RPC", "discordRPC"),
			#end
			new StringSaveOption("Cutscenes Play On", ["story", "freeplay", "both"], "cutscenePlaysOn"),
			new StringSaveOption("Play As", ["bf", "opponent"], "playAs"),
			new BoolOption("Disable Debug Menus", "disableDebugMenus"),
			new BoolOption("Invisible Notes", "invisibleNotes"),
			new BoolOption("Auto Pause", "autoPause"),
			new BoolOption("Load Asynchronously", "loadAsynchronously"),
			new BoolOption("Flixel Splash Screen", "flixelStartupScreen"),
			new BoolOption("Skip Results", "skipResultsScreen"),
			#if CHECK_FOR_UPDATES
			new BoolOption("Check For Updates", "checkForUpdates"),
			#end
			new BoolOption("Show Score", "showScore"),
			new BoolOption("Dinnerbone Mode", "dinnerbone"),
			new GameSubStateOption("Import Old Scores", substates.ImportHighscoresSubstate)
		],
		"Optimizations" => [
			new PageOption("Back", "Graphics"),
			new BoolOption("Antialiasing", "antialiasing"),
			new BoolOption("Low Quality", "lowQuality"),
			new BoolOption("Health Icons", "healthIcons"),
			new BoolOption("Health Bar", "healthBar"),
			new BoolOption("Ratings and Combo", "ratingsAndCombo"),
			new BoolOption("Chars And BGs", "charsAndBGs"),
			new BoolOption("Menu Backgrounds", "menuBGs"),
			new BoolOption("Optimized Characters", "optimizedChars"),
			new BoolOption("Animated Backgrounds", "animatedBGs"),
			new BoolOption("Preload Stage Events", "preloadChangeBGs"),
			new BoolOption("Persistent Cached Data", "memoryLeaks"),
			new BoolOption("VRAM Sprites", "gpuCaching"),
			#if MODCHARTING_TOOLS
			new BoolOption("Optimized Modcharts", "optimizedModcharts"),
			#end
		],
		"Info Display" => [
			new PageOption("Back", "Graphics"),
			new DisplayFontOption("Display Font", [
				"_sans",
				Assets.getFont(Paths.font("vcr.ttf")).fontName,
				Assets.getFont(Paths.font("pixel.otf")).fontName
			],
				"infoDisplayFont"),
			new BoolOption("FPS Counter", "fpsCounter"),
			new BoolOption("Memory Counter", "memoryCounter"),
			new BoolOption("Version Display", "versionDisplay"),
			new BoolOption("Commit Hash", "showCommitHash"),
			#if DISCORD_ALLOWED
			new BoolOption("Discord", "showDiscord")
			#end
		],
		"Judgements" => [
			new PageOption("Back", "Gameplay"),
			new GameSubStateOption("Timings", substates.JudgementMenu),
			new StringSaveOption("Rating Mode", ["psych", "simple", "complex"], "ratingType"),
			new BoolOption("Marvelous Ratings", "marvelousRatings"),
			new BoolOption("Show Rating Count", "sideRatings")
		],
		"Input Options" => [
			new PageOption("Back", "Gameplay"),
			new StringSaveOption("Input Mode", ["standard", "rhythm"], "inputSystem"),
			new BoolOption("Anti Mash", "antiMash"),
			new BoolOption("Shit gives Miss", "missOnShit"),
			new BoolOption("Ghost Tapping", "ghostTapping"),
			new BoolOption("Gain Misses on Sustains", "missOnHeldNotes"),
			new BoolOption("No Miss", "noHit"),
			new BoolOption("Reset Button", "resetButton")
		],
		"Note Options" => [
			new PageOption("Back", "Graphics"),
			new GameSubStateOption("Note BG Alpha", substates.NoteBGAlphaMenu),
			new BoolOption("Enemy Note Glow When Hit", "enemyStrumsGlow"),
			new BoolOption("Player Note Splashes", "playerNoteSplashes"),
			new BoolOption("Enemy Note Splashes", "opponentNoteSplashes"),
			new BoolOption("Note Accuracy Text", "displayMs"),
			new GameSubStateOption("Note Colors", substates.NoteColorSubstate),
			new BoolOption("Color Quantization", "colorQuantization"),
			new GameSubStateOption("UI Skin", substates.UISkinSelect)
		],
		"Screen Effects" => [
			new PageOption("Back", "Graphics"),
			new BoolOption("Camera Tracks Direction", "cameraTracksDirections"),
			new BoolOption("Camera Bounce", "cameraZooms"),
			new BoolOption("Flashing Lights", "flashingLights"),
			new BoolOption("Screen Shake", "screenShakes"),
		],
		"Developer Options" => [
			new PageOption("Back", "Categories"),
			new BoolOption("Developer Mode", "developer")
		],
		"Mod Options" => [
			new PageOption("Back", "Categories"),
			//new BoolOption("Mechanics", "mechanics"),
			new BoolOption("Disclaimer", "showDisclaimer"),
			new BoolOption("DarkHeader (WIP)", "darkHeader"),
			new BoolOption("Shaders", "shaders"),
			new BoolOption("Gradient TimeBar", "gradientTimeBar"),
			new BoolOption("BG Renders", "renderBGs"),
			new BoolOption("Renders", "renders")
		]
	];

	public var page:FlxTypedGroup<Option> = new FlxTypedGroup<Option>();
	public var pageName:String = "Categories";

	public static var instance:OptionsMenu;

	public var menuBG:FlxSprite;

	public static var playing:Bool = false;

	public override function create():Void {

		MusicBeatState.windowNameSuffix = " Options";
		instance = this;


		menuBG = new FlxSprite().makeBackground(0xFFea71fd);
		menuBG.scale.set(1.1, 1.1);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		super.create();

		add(page);

		loadPage("Categories");

		FlxG.sound.playMusic(MusicUtilities.getOptionsMusic(), 0.7, true);
		OptionsMenu.playing = true;
	}

	public function loadPage(loadedPageName:String, goingBack:Bool = false):Void {
		pageName = loadedPageName;

		inMenu = true;
		instance.curSelected = 0;

		var curPage:FlxTypedGroup<Option> = instance.page;
		curPage.clear();

		for (x in instance.pages.get(loadedPageName).copy()) {
			curPage.add(x);
		}

		inMenu = false;
		var bruh:Int = 0;
		var moveBackVal:Float = 1;
		if (goingBack)
			moveBackVal = -1;

		for (x in instance.page.members) {
			x.alphabetText.targetY = bruh - instance.curSelected;
			x.alphabetText.x = -1500 * moveBackVal; //move to the side
			bruh++;
		}
	}

	public function goBack() {
		if (pageName != "Categories") {
			loadPage(cast(page.members[0], PageOption).pageName);
			return;
		}

		FlxG.switchState(() -> new MainMenuState());
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!inMenu) {
			if (-1 * Math.floor(FlxG.mouse.wheel) != 0) {
				curSelected -= 1 * Math.floor(FlxG.mouse.wheel);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.UP_P) {
				curSelected--;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.DOWN_P) {
				curSelected++;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.BACK)
				goBack();
		} else {
			if (controls.BACK)
				inMenu = false;
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members) {
			x.alphabetText.targetY = bruh - curSelected;
			bruh++;
		}

		for (x in page.members) {
			if (x.alphabetText.targetY != 0) {
				for (item in x.members) {
					item.alpha = 0.5;
				}
			} else {
				for (item in x.members) {
					item.alpha = 1;
				}
			}
		}
	}
}
