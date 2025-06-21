package states;

#if (target.threaded)
import sys.thread.Thread;
#end
#if DISCORD_ALLOWED
import utilities.DiscordClient;
#end
import modding.scripts.languages.HScript;
import modding.ModList;
import game.Conductor;
import utilities.Options;
import flixel.util.FlxTimer;
import substates.ResetScoreSubstate;
import substates.StarInfoSubState;
import utilities.StarLoader;
import substates.LoadingStarsSubstate;
import flixel.sound.FlxSound;
import lime.app.Application;
import flixel.tweens.FlxTween;
import game.SongLoader;
import game.Highscore;
import ui.HealthIcon;
import ui.FreeplayTxt;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;
import shaders.VCR;
import utilities.Ratings;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import openfl.display.BlendMode;
import substates.RejectedVipSubState;

using StringTools;
using utilities.BackgroundUtil;

class FreeplayState extends MusicBeatState {
	public var songs:Array<SongMetadata> = [];
	var currentSongIcon:FlxSprite = null;
	var currentStarIcon:FlxSprite = null;
		var tercerStarIcon:FlxSprite = null;
	var secondStarIcon:FlxSprite = null;
	public var selector:FlxText;
	
	public var songBackgrounds:Array<{ bg:FlxSprite, text:FlxSprite }> = [];
	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 1;
	public static var curSpeed:Float = 1;
	public static var selectedCharacter:String = "";
	public var scoreText:FlxText;
	public var diffText:FlxText;
	public var speedText:FlxText;
	public var lerpScore:Int = 0;
	public var intendedScore:Int = 0;
	public var lastRenderSong:String = "";

	public var grpSongs:FlxTypedGroup<FreeplayTxt>;
	public var curPlaying:Bool = false;

	public var iconArray:Array<HealthIcon> = [];

	public static var songsReady:Bool = false;

	public static var coolColors:Array<Int> = [
		0xFF7F1833,
		0xFF7C689E,
		-14535868,
		0xFFA8E060,
		0xFFFF87FF,
		0xFF8EE8FF,
		0xFFFF8CCD,
		0xFFFF9900,
		0xFF735EB0
	];
	var bestAccuracy:Float = 0;
	var totalRoseStars = 0;
	var totalBlueStars = 0;
	var totalGoldStars = 0;

	public var bg:FlxSprite;
	public var selectedColor:Int = 0xFF7F1833;
	public var ajedrez:FlxBackdrop;
	
	public var vignettelol:FlxSprite;
	public var scoreBG:FlxSprite;
	public var verified:FlxText;
	public var splashes:FlxSprite; 

	public var curRank:String = "N/A";

	public var curDiffString:String = "normal";
	public var curDiffArray:Array<String> = ["easy", "normal", "hard"];
	public var posters:Array<FlxSprite> = [];
	public var vocals:FlxSound = new FlxSound();

	public var canEnterSong:Bool = true;
	public var godEffectDone:Map<String, Bool> = new Map();

	// thx psych engine devs
	public var colorTween:FlxTween;
	var myMisses:Int = 0;
	#if (target.threaded)
	public var loading_songs:Thread;
	public var stop_loading_songs:Bool = false;
	#end
	public static var iconRPC:String = "";

	public var lastSelectedSong:Int = -1;

	/**
		Current instance of `FreeplayState`.
	**/
	public static var instance:FreeplayState = null;

	public var VCRSHADER:VCR;  

	 var up:FlxSprite;
    var down:FlxSprite;
    var ports:Map<String, FlxSprite> = new Map();
    var songPortMap:Map<String, String> = new Map();

    public static var render:Map<String, FlxSprite> = new Map();
    public static var songRender:Map<String, String> = new Map();
		

	override public function call(func:String, ?args:Array<Any>, ?executeOn:Dynamic):Void {
		if (stateScript != null)
			stateScript.call(func, args);
	}
	

	private var initSonglist:Array<String> = [];

	override function create() {
		instance = this;
		super.create();
		MusicBeatState.windowNameSuffix = " Freeplay";

		var black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		


		#if NO_PRELOAD_ALL

		
		if (!songsReady) {
			Assets.loadLibrary("songs").onComplete(function(_) {
				FlxTween.tween(black, {alpha: 0}, 0.5, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween) {
						remove(black);
						black.kill();
						black.destroy();
					}
				});

				songsReady = true;
			});
		}
		#else
		songsReady = true;
		#end

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			TitleState.playTitleMusic();
		#if MODDING_ALLOWED
		if (!ModList.modList.get(Options.getData("curMod"))) {
			Options.setData("Friday Night Funkin'", "curMod");
			CoolUtil.coolError("Hmmm... I couldnt find the mod you are trying to switch to.\nIt is either disabled or not in the files.\nI switched the mod to base game to avoid a crash!",
				"Leather Engine's No Crash, We Help Fix Stuff Tool");
			CoolUtil.setWindowIcon("mods/" + Options.getData("curMod") + "/_polymod_icon.png");
		}
		if (sys.FileSystem.exists("mods/" + Options.getData("curMod") + "/data/freeplaySonglist.txt"))
			initSonglist = CoolUtil.coolTextFileSys("mods/" + Options.getData("curMod") + "/data/freeplaySonglist.txt");
		else if (sys.FileSystem.exists("mods/" + Options.getData("curMod") + "/_append/data/freeplaySongList.txt"))
			initSonglist = CoolUtil.coolTextFileSys("mods/" + Options.getData("curMod") + "/_append/data/freeplaySongList.txt");
		else if (sys.FileSystem.exists("mods/" + Options.getData("curMod") + "/_append/data/freeplaySonglist.txt"))
			initSonglist = CoolUtil.coolTextFileSys("mods/" + Options.getData("curMod") + "/_append/data/freeplaySonglist.txt");
		#else
		initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		#end

		if (curSelected > initSonglist.length)
			curSelected = 0;

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		// Loops through all songs in freeplaySonglist.txt
		for (i in 0...initSonglist.length) {
			if (initSonglist[i].trim() != "") {
				// Creates an array of their strings
				var listArray = initSonglist[i].split(":");

				// Variables I like yes mmmm tasty
				var week = Std.parseInt(listArray[2]);
				var icon = listArray[1];
				var song = listArray[0];

				var diffsStr = listArray[3];
				var diffs = ["Dont Press"];

				var color = listArray[4];
				var actualColor:Null<FlxColor> = null;

				if (color != null)
					actualColor = FlxColor.fromString(color);

				if (diffsStr != null)
					diffs = diffsStr.split(",");

				// Creates new song data accordingly
				
		
				songs.push(new SongMetadata(song, week, icon, diffs, actualColor));
			}
		}

	

		ajedrez = new FlxBackdrop(FlxGridOverlay.createGrid(30, 30, FlxG.width, FlxG.height, true, FlxColor.BLACK, FlxColor.WHITE));
        ajedrez.blend = BlendMode.ADD;
        ajedrez.scale.set(3, 3);
        ajedrez.alpha = 0.1;
        ajedrez.velocity.set(Conductor.crochet);
        
	
		add(bg = new FlxSprite().makeBackground(0xE1E1E1));
        add(ajedrez);

		splashes = new FlxSprite().loadGraphic(Paths.gpuBitmap('freeplay/Splashes')); 
		splashes.antialiasing = Options.getData("Multisampling ");
		splashes.setGraphicSize(Std.int(splashes.width * 0.34));
		splashes.updateHitbox();

	

		VCRSHADER = new VCR();
		vignettelol = new FlxSprite(0, 0);
        vignettelol.makeGraphic(FlxG.width, FlxG.height); 
        vignettelol.blend = "multiply"; 
        vignettelol.alpha = 0;
        vignettelol.shader = VCRSHADER.shader;
        vignettelol.scrollFactor.set();


		grpSongs = new FlxTypedGroup<FreeplayTxt>();


		var songTextBG:FlxSprite = new FlxSprite(Std.int(FlxG.width * 0.13), 10) 
    	.makeGraphic(Std.int(FlxG.width * 0.75), Std.int(FlxG.height - 20), FlxColor.BLACK);
		songTextBG.alpha = Options.getData("FreeplayBlackBG") ? 0.82: 0;

		
		add(songTextBG);
		add(splashes);
		add(grpSongs);
		add(vignettelol);
	

		scoreText = new FlxText(FlxG.width, 5, 0, "", 32);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 2, FlxColor.BLACK);
		scoreBG.alpha = 0.6;

		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		diffText = new FlxText(FlxG.width, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.alignment = RIGHT;

		speedText = new FlxText(FlxG.width, diffText.y + 36, 0, "", 24);
		speedText.font = scoreText.font;
		speedText.alignment = RIGHT;

		verified = new FlxText(FlxG.width, speedText.y + 36, 0, "CLEAR:", 24);
		verified.font = scoreText.font;
		verified.alignment = RIGHT;
		
		
		#if (target.threaded)
		if (!Options.getData("loadAsynchronously") || !Options.getData("healthIcons")) {
			#end
			for (i in 0...songs.length) {
				var songMeta = songs[i];
				
				var songText:FreeplayTxt = new FreeplayTxt(FlxG.width / 2, (70 * i) + 30, songMeta.songName, true, false);
				songText.screenCenter(FlxAxes.X); 
				songText.isMenuItem = true;
				songText.targetY = i;


				var composerIconPath = "icons/Composers/" + songMeta.songCharacter;
				if (songMeta.songName.contains("---") || Assets.exists(composerIconPath)) {
					var songBg = new FlxSprite(0, songText.y).makeGraphic(FlxG.width, 70, songMeta.color);
					songBg.alpha = 0.7; 
					songBackgrounds.push({ bg: songBg, text: songText });
					insert(members.indexOf(songTextBG) + 1, songBg);
				}

				
				grpSongs.add(songText);
				if (FlxG.keys.justPressed.ENTER) {
					selectedCharacter = songMeta.songCharacter; 
				}
				if (Options.getData("healthIcons")) {
					var icon:HealthIcon = new HealthIcon(songMeta.songCharacter);
					icon.sprTracker = songText;
					iconArray.push(icon);
					add(icon);
				}
			
			}
			#if (target.threaded)
		}
		else {
			loading_songs = Thread.create(function() {
				var i:Int = 0;
		
				while (!stop_loading_songs && i < songs.length) {
					var songMeta = songs[i]; 
					var songText:FreeplayTxt = new FreeplayTxt(FlxG.width / 2, (70 * i) + 30, songMeta.songName, true, false);
					songText.screenCenter(FlxAxes.X); 
					songText.isMenuItem = true;
					songText.targetY = i;

					var composerIconPath = "icons/Composers/" + songMeta.songCharacter;
					if (songMeta.songName.contains("---") || Assets.exists(composerIconPath)) {
						var songBg = new FlxSprite(0, songText.y).makeGraphic(FlxG.width, 70, songMeta.color);
						songBg.alpha = 0.7; 
						songBackgrounds.push({ bg: songBg, text: songText });
						insert(members.indexOf(songTextBG) + 1, songBg);
					} 

					
					grpSongs.add(songText);
					
				  
					if (FlxG.keys.justPressed.ENTER) {
						selectedCharacter = songMeta.songCharacter; 
					}
					var icon:HealthIcon = new HealthIcon(songMeta.songCharacter);
					icon.sprTracker = songText;
					iconArray.push(icon);
					add(icon);

					i++;
				}
			});
		}
		
		#end


		var portList = CoolUtil.coolTextFile(Paths.file('images/freeplay/ports/data.txt'));
		var imagesvip = CoolUtil.coolTextFile(Paths.file('images/freeplay/Renders/data.txt'));

		for (portName in portList) {
			if (Options.getData("renderBGs")) {
				var port = new FlxSprite().loadGraphic(Paths.image('freeplay/ports/' + portName));
				port.alpha = 0;
				port.antialiasing = Options.getData("antialiasing");
				insert(members.indexOf(bg) + 1, port);
				ports.set(portName, port);
			}
		}

		for (images in imagesvip) {
			if (Options.getData("renders")) {
				var png = new FlxSprite().loadGraphic(Paths.image('freeplay/Renders/' + images));
				png.alpha = 0;
				png.antialiasing = Options.getData("antialiasing");
				insert(members.indexOf(ajedrez) + 2, png);
				render.set(images, png);
			}
		}

		var songList = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...songList.length) {
			var listArray = songList[i].split(":");
			var q = listArray[0];

			if (listArray[5] != null) {
				songPortMap.set(q, listArray[5]);
			}

			if (listArray[6] != null) {
				var renderName = listArray[6];

				if (q == "REJECTED VIP") {
					renderName = FlxG.random.bool(50) ? "REJECTED VIP" : "REJECTED VIP 2";
				}

				songRender.set(q, renderName);
			}

			
		}

		up = new FlxSprite().loadGraphic(Paths.gpuBitmap('freeplay/Up_Arrow'));
		add(up);
		down = new FlxSprite().loadGraphic(Paths.gpuBitmap('freeplay/Down_Arrow'));
		add(down);


		// layering
		add(scoreBG);
		add(scoreText);
		add(diffText);
		add(speedText);
		add(verified);
		selector = new FlxText();

		selector.size = 40;
		selector.text = "<";

		if (!songsReady) {
			add(black);
		} else {
			remove(black);
			black.kill();
			black.destroy();

			songsReady = false;

			new FlxTimer().start(1, function(_) songsReady = true);
		}

		if (songs.length != 0 && curSelected >= 0 && curSelected < songs.length) {
			selectedColor = songs[curSelected].color;
			bg.color = selectedColor;
		} else {
			bg.color = 0xFF7C689E;
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, FlxColor.BLACK);
		textBG.alpha = 0.8;
		add(textBG);

		var topTextBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 26, FlxColor.BLACK);
		topTextBG.alpha = 0.8;
		insert(members.indexOf(scoreText) - 1, topTextBG);

		var topText:FlxText = new FlxText(0, 4, FlxG.width, "Press E to access the Stars menu", 18);
		topText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.LIME, CENTER);
		topText.scrollFactor.set();
		topText.screenCenter(X);
		add(topText);

		#if PRELOAD_ALL
		var leText:String = "Press R to reset song score and rank ~ Press SPACE to play Song Audio ~ Shift + LEFT and RIGHT to change song speed";
		#else
		var leText:String = "Press R to reset song score ~ Shift + LEFT and RIGHT to change song speed";
		#end

	
		infoText = new FlxText(textBG.x - 1, textBG.y + 4, FlxG.width, leText, 18);
		infoText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.ORANGE, CENTER);
		infoText.scrollFactor.set();
		infoText.screenCenter(X);
		add(infoText);




		call("createPost");
	}

	public var mix:String = null;

	public var infoText:FlxText;
    var time:Float = 0;
	public function addSong(songName:String, weekNum:Int, songCharacter:String) {
		call("addSong", [songName, weekNum, songCharacter]);
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
		call("addSongPost", [songName, weekNum, songCharacter]);
	}

	override function update(elapsed:Float) {
		call("update", [elapsed]);
		#if sys
		if (FlxG.keys.justPressed.TAB) {
			openSubState(new modding.SwitchModSubstate());
			persistentUpdate = false;
		}
		#end

		super.update(elapsed);

		VCRSHADER.time += elapsed;

		if (songs.length > 0) {
			var songName = songs[FreeplayState.curSelected].songName.toLowerCase(); 
			var songKey = songs[FreeplayState.curSelected].songName;
			var curDiff = curDiffString;
           

			if (songKey == "REJECTED VIP" && lastRenderSong != songKey) {
				lastRenderSong = songKey;
				songRender.set("REJECTED VIP", FlxG.random.bool(50) ? "REJECTED VIP" : "REJECTED VIP 2");
			}
			for (portName in ports.keys()) {
				var port = ports.get(portName);
				var alp = 0;
				if (songPortMap.exists(songKey) && songPortMap.get(songKey) == portName) {
					alp = 1;
				}
				port.alpha = FlxMath.lerp(port.alpha, alp, elapsed * 8);
			}

			for (images in render.keys()) {
				var png = render.get(images);
				var alp = 0;
				var xd = 600;
				if (songRender.exists(songKey) && songRender.get(songKey) == images) {
					alp = 1;
					xd = 0;
				}
				png.alpha = FlxMath.lerp(png.alpha, alp, elapsed * 8);
				png.x = FlxMath.lerp(png.x, xd, elapsed * 8);
			}
		}

		up.y = FlxMath.lerp(up.y, 0, elapsed * 8);
		down.y = FlxMath.lerp(down.y, 0, elapsed * 8);



		for (entry in songBackgrounds) {
			entry.bg.y = entry.text.y;
		}
		for (songText in grpSongs) {
			var targetX = Math.floor((FlxG.width - songText.width) / 2);
			if (songText.x != targetX) {
				songText.x = targetX;
			}
		}
		for (icon in iconArray) {
			if (icon.sprTracker != null) {
				var targetIconX = icon.sprTracker.x - icon.width - 10; 
		
				if (Math.abs(icon.x - targetIconX) > 1) { 
					icon.x = targetIconX;
				}
				//icon.y = icon.sprTracker.y - 50; 
				
			}
		}
		
		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

		for (i in 0...iconArray.length) {
			if (i == lastSelectedSong)
				continue;

			iconArray[i].scale.set(iconArray[i].startSize, iconArray[i].startSize);
		}

		if (lastSelectedSong != -1 && iconArray[lastSelectedSong] != null)
			iconArray[lastSelectedSong].scale.set(FlxMath.lerp(iconArray[lastSelectedSong].scale.x, iconArray[lastSelectedSong].startSize, elapsed * 9),
				FlxMath.lerp(iconArray[lastSelectedSong].scale.y, 1, elapsed * 9));

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		var funnyObject:FlxText = scoreText;

		if (speedText.width >= scoreText.width && speedText.width >= diffText.width)
			funnyObject = speedText;

		if (diffText.width >= scoreText.width && diffText.width >= speedText.width)
			funnyObject = diffText;

		scoreBG.x = funnyObject.x - 6;

		if (Std.int(scoreBG.width) != Std.int(funnyObject.width + 6))
			scoreBG.makeGraphic(Std.int(funnyObject.width + 6), 200, FlxColor.BLACK);

		scoreText.x = FlxG.width - scoreText.width;
		scoreText.text = "PERSONAL BEST:" + lerpScore;

		diffText.x = FlxG.width - diffText.width;

		curSpeed = FlxMath.roundDecimal(curSpeed, 2);

		if (curSpeed < 0.25)
			curSpeed = 0.25;

		speedText.text = "Speed: " + curSpeed + " (R+SHIFT)";
		speedText.x = FlxG.width - speedText.width;

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var shift = FlxG.keys.pressed.SHIFT;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;

		if (songsReady) {
			if (-1 * Math.floor(FlxG.mouse.wheel) != 0 && !shift)
				changeSelection(-1 * Math.floor(FlxG.mouse.wheel));
			else if (-1 * (Math.floor(FlxG.mouse.wheel) / 10) != 0 && shift)
				curSpeed += -1 * (Math.floor(FlxG.mouse.wheel) / 10);

			if (upP)
				changeSelection(-1);
			if (downP)
				changeSelection(1);

			if (leftP && !shift)
				changeDiff(-1);
			else if (leftP && shift)
				curSpeed -= 0.05;

			if (rightP && !shift)
				changeDiff(1);
			else if (rightP && shift)
				curSpeed += 0.05;

			if (FlxG.keys.justPressed.R && shift)
				curSpeed = 1;

			if (controls.BACK) {
				if (colorTween != null)
					colorTween.cancel();

				if (vocals.active && vocals.playing)
					destroyFreeplayVocals(false);
				if (FlxG.sound.music.active && FlxG.sound.music.playing)
					FlxG.sound.music.pitch = 1;

				#if (target.threaded)
				stop_loading_songs = true;
				#end

				FlxG.switchState(new MainMenuState());

			}

			if (FlxG.keys.justPressed.E) {
				openSubState(new LoadingStarsSubstate(songs));

			}


			#if PRELOAD_ALL
			if (FlxG.keys.justPressed.SPACE) {
				destroyFreeplayVocals();

				// TODO: maybe change this idrc actually it seems ok now
				if (Assets.exists(SongLoader.getPath(curDiffString, songs[curSelected].songName.toLowerCase(), mix))) {
					PlayState.SONG = SongLoader.loadFromJson(curDiffString, songs[curSelected].songName.toLowerCase(), mix);
					Conductor.changeBPM(PlayState.SONG.bpm, curSpeed);
				}

				vocals = new FlxSound();

				var voicesDiff:String = (PlayState.SONG != null ? (PlayState.SONG.specialAudioName ?? curDiffString.toLowerCase()) : curDiffString.toLowerCase());
				var voicesPath:String = Paths.voices(songs[curSelected].songName.toLowerCase(), voicesDiff, mix ?? '');

				if (Assets.exists(voicesPath))
					vocals.loadEmbedded(voicesPath);

				vocals.persist = false;
				vocals.looped = true;
				vocals.volume = 0.7;

				FlxG.sound.list.add(vocals);

				FlxG.sound.music = new FlxSound().loadEmbedded(Paths.inst(songs[curSelected].songName.toLowerCase(), curDiffString.toLowerCase(), mix));
				FlxG.sound.music.persist = true;
				FlxG.sound.music.looped = true;
				FlxG.sound.music.volume = 0.7;

				FlxG.sound.list.add(FlxG.sound.music);

				FlxG.sound.music.play();
				vocals.play();

				lastSelectedSong = curSelected;
			}
			#end

			if (FlxG.sound.music.active && FlxG.sound.music.playing && !FlxG.keys.justPressed.ENTER)
				FlxG.sound.music.pitch = curSpeed;
			if (vocals != null && vocals.active && vocals.playing && !FlxG.keys.justPressed.ENTER)
				vocals.pitch = curSpeed;

			if (controls.RESET && !shift) {
				openSubState(new ResetScoreSubstate(songs[curSelected].songName, curDiffString));
				changeSelection();
			}

			if (FlxG.keys.justPressed.ENTER && canEnterSong) {
				var selectedSong = songs[curSelected].songName.toLowerCase();

				if (selectedSong == "rejected vip") {
					openSubState(new RejectedVipSubState(this, selectedSong, curDiffString));
				} else {
					playSong(selectedSong, curDiffString);
				}
			}

		}
		call("updatePost", [elapsed]);
	}

	// TODO: Make less nested

	/**
		 * Plays a specific song
		 * @param songName
		 * @param diff
		 */
	public function playSong(songName:String, diff:String) {
		if (!CoolUtil.songExists(songName, diff, mix)) {
			CoolUtil.coolError(songName.toLowerCase() + " doesn't match with any song audio files!\nTry fixing it's name in freeplaySonglist.txt",
				"Leather Engine's No Crash, We Help Fix Stuff Tool");
			return;
		}
		PlayState.SONG = SongLoader.loadFromJson(diff, songName.toLowerCase(), mix);
		if (!Assets.exists(Paths.inst(PlayState.SONG.song, diff.toLowerCase(), mix))) {
			if (Assets.exists(Paths.inst(songName.toLowerCase(), diff.toLowerCase(), mix)))
				CoolUtil.coolError(PlayState.SONG.song.toLowerCase() + " (JSON) does not match " + songName + " (FREEPLAY)\nTry making them the same.",
					"Leather Engine's No Crash, We Help Fix Stuff Tool");
			else
				CoolUtil.coolError("Your song seems to not have an Inst.ogg, check the folder name in 'songs'!",
					"Leather Engine's No Crash, We Help Fix Stuff Tool");
			return;
		}
		PlayState.isStoryMode = false;
		PlayState.songMultiplier = curSpeed;
		PlayState.storyDifficultyStr = diff.toUpperCase();

		PlayState.storyWeek = songs[curSelected].week;

		#if (target.threaded)
		stop_loading_songs = true;
		#end

		colorTween?.cancel();

		PlayState.loadChartEvents = true;
		destroyFreeplayVocals();
		FlxG.switchState(() -> new PlayState());
	}

	override function closeSubState() {
		changeSelection();
		FlxG.mouse.visible = false;
		super.closeSubState();
	}

	function changeDiff(change:Int = 0) {
		call("changeDiff", [change]);
	
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, curDiffArray.length - 1);
		curDiffString = curDiffArray[curDifficulty].toUpperCase();
	
			if (songs.length != 0) {
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDiffString);
				curRank = Highscore.getSongRank(songs[curSelected].songName, curDiffString);

				
				
				var iconName = intendedScore > 0 ? "green mark" : "black mark";

				if (currentSongIcon != null && members.contains(currentSongIcon)) {
					remove(currentSongIcon);
					currentSongIcon.destroy();
					currentSongIcon = null;
				}

				if (Assets.exists(Paths.image(iconName))) {
					currentSongIcon = new FlxSprite(1025, -60);
					currentSongIcon.loadGraphic(Paths.image(iconName));
					currentSongIcon.scale.set(0.17, 0.17);
					currentSongIcon.antialiasing = true;
					add(currentSongIcon);
				}

				var curAccuracy:Float = Highscore.getSongAccuracy(songs[curSelected].songName, curDiffString);

					var starName = curAccuracy >= 90 ? "blue star" : "black star";
					var secondStar = curAccuracy >= 95 ? "gold star" : "black star";
					var thirdStar = curAccuracy >= 80 ? "rose star" : "black star";

					if (currentStarIcon != null && members.contains(currentStarIcon)) {
						remove(currentStarIcon);
						currentStarIcon.destroy();
						currentStarIcon = null;
					}
					if (secondStarIcon != null && members.contains(secondStarIcon)) {
						remove(secondStarIcon);
						secondStarIcon.destroy();
						secondStarIcon = null;
					}
					if (tercerStarIcon != null && members.contains(tercerStarIcon)) {
						remove(tercerStarIcon);
						tercerStarIcon.destroy();
						tercerStarIcon = null;
					}
					tercerStarIcon = addStar(thirdStar, 805, -60);      
					currentStarIcon = addStar(starName, 880, -60);     
					secondStarIcon  = addStar(secondStar, 955, -60); 
	        }


			
	
		if (curDiffArray.length > 1)
			diffText.text = "< " + curDiffString + " ~ " + curRank + " >";
		else
			diffText.text = curDiffString + " ~ " + curRank + "  ";
	
		if (songs.length > 0) {
			var songName = songs[curSelected].songName.toLowerCase();
			var baseIcon = songs[curSelected].songCharacter;
		
			if (~/^(?=.*\bgod\b)(?=.*\b(4k|8k|9k|12k|16k)\b)?/i.match(curDiffString)) {

				var godIcon = baseIcon + "-god";
				iconArray[curSelected].setupIcon(godIcon);
		
				if (!godEffectDone.exists(songName) || !godEffectDone.get(songName)) {
					FlxG.sound.play(Paths.sound('ssj_burst'), 0.6);
					FlxG.camera.flash(FlxColor.WHITE, 0.5);
					FlxG.camera.shake(0.009, 0.23);
					godEffectDone.set(songName, true);
					vignettelol.alpha = 1;
				}
			} else {
				iconArray[curSelected].setupIcon(baseIcon);
				vignettelol.alpha = 0;
				godEffectDone.set(songName, false); 
			}
		}
		
	
		call("changeDiffPost", [change]);
	}
	
	function addStar(iconPath:String, posX:Float, posY:Float):FlxSprite {
		var sprite:FlxSprite = null;
			if (Assets.exists(Paths.image(iconPath))) {
				sprite = new FlxSprite(posX, posY);
				sprite.loadGraphic(Paths.image(iconPath));
				sprite.scale.set(0.17, 0.17);
				sprite.antialiasing = true;
				add(sprite);
			}
			return sprite;
	}



	
	function changeSelection(change:Int = 0) {
		call("changeSelection", [change]);

			 if (change != 0)
				{
					if (change > 0)
						down.y += 20; 
					else 
						up.y -= 20;
				}


		if (grpSongs.length <= 0) return;

		var previousSelected = curSelected;
		 if (change != 0) {
     		var tries = 0;
			do {
				previousSelected = FlxMath.wrap(previousSelected + change, 0, grpSongs.length - 1);
				tries++;
				if (previousSelected == curSelected) break;
			} while (songs[previousSelected].songName.indexOf("---") != -1 && tries < grpSongs.length);

			curSelected = previousSelected;
		}
		//curSelected = FlxMath.wrap(curSelected + change, 0, grpSongs.length - 1);
		if (songs.length > 0 && iconArray.length > 0 && previousSelected < iconArray.length) {
			var prevBaseIcon = songs[previousSelected].songCharacter;
			iconArray[previousSelected].setupIcon(prevBaseIcon);

			var prevSongName = songs[previousSelected].songName.toLowerCase();
			godEffectDone.set(prevSongName, false);
		}

		if (songs.length > 0 && iconArray.length > 0 && curSelected < iconArray.length) {
			var baseIcon = songs[curSelected].songCharacter;
			iconArray[curSelected].setupIcon(baseIcon);

			var songName = songs[curSelected].songName.toLowerCase();
			godEffectDone.set(songName, false);
		}
		// Sounds

		// Scroll Sound
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		// Song Inst
		if (Options.getData("freeplayMusic") && curSelected <= 0) {
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName, curDiffString.toLowerCase()), 0.7);

			if (vocals.active && vocals.playing)
				destroyFreeplayVocals(false);
		}

		if (songs.length != 0) {

				var difficulties = ["voiid", "standard", "sported out", "corrupted", "god", "godly", "double god", "canon", "old", "easier", "100%", "goodles 100%", "infinite",
				"voiid god", "nogod","double god 8k", "godly 6k", "godly 9k","hard","paper","unt0ld","food styles","4k mania","double infinite", "wtf","infinite 10","new infinite 10k",
				"unknown","8k god","double godly","swole","triple god","triple god no modchart","god new","god new 9k","remix"];
			for (i in 1...22) {
				difficulties.push(i + "k");
			}
			for (i in 1...22) {
				difficulties.push("god " + i + "k");
			}

			var highestScore = 0;
			var bestRank = "";
			var bestAccuracy:Float = 0;

			for (diff in difficulties) {
				var score = Highscore.getScore(songs[curSelected].songName, diff);
				var accuracy = Highscore.getSongAccuracy(songs[curSelected].songName, diff);

				if (score > highestScore) {
					highestScore = score;
					bestRank = Highscore.getSongRank(songs[curSelected].songName, diff);
					bestAccuracy = accuracy;
				}
			}

			var iconName = highestScore > 0 ? "green mark" : "black mark";
			var starName = bestAccuracy >= 90 ? "blue star" : "black star";
			var seconStar = bestAccuracy >= 95 ? "gold star" : "black star";
			var tercerStar = bestAccuracy >= 80 ? "rose star" : "black star";

			if (currentSongIcon != null && members.contains(currentSongIcon)) {
				remove(currentSongIcon);
				currentSongIcon.destroy();
				currentSongIcon = null;
			}

			if (Assets.exists(Paths.image(iconName))) {
				currentSongIcon = new FlxSprite(1010, -60);
				currentSongIcon.loadGraphic(Paths.image(iconName));
				currentSongIcon.scale.set(0.17, 0.17);
				currentSongIcon.antialiasing = true;
				add(currentSongIcon);
			}

				if (currentStarIcon != null && members.contains(currentStarIcon)) {
					remove(currentStarIcon);
					currentStarIcon.destroy();
					currentStarIcon = null;
				}
				if (secondStarIcon != null && members.contains(secondStarIcon)) {
					remove(secondStarIcon);
					secondStarIcon.destroy();
					secondStarIcon = null;
				}
				tercerStarIcon = addStar(tercerStar, 805, -60);
				currentStarIcon = addStar(starName, 880, -60); 
				secondStarIcon = addStar(seconStar, 955, -60); 

		}

		if (songs.length != 0) {
			curDiffArray = songs[curSelected].difficulties;
			changeDiff();
		}

		var bullShit:Int = 0;

		if (iconArray.length > 0) {
			for (i in 0...iconArray.length) {
				iconArray[i].alpha = 0.6;

				if (iconArray[i].animation.curAnim != null)
					iconArray[i].animation.play("neutral");
			}

			if (iconArray != null && curSelected >= 0 && (curSelected <= iconArray.length) && iconArray.length != 0) {
				iconArray[curSelected].alpha = 1;
				iconArray[curSelected].animation.play("win");
			}
		}

		for (i in 0...grpSongs.length) {
			var item = grpSongs.members[i];
			item.targetY = i - curSelected;

			var songName = songs[i].songName.toLowerCase();

			if (item.targetY == 0 || songName.indexOf("---") != -1) {
				item.alpha = 1;
			} else {
				item.alpha = 0.5;
			}
		}

		if (change != 0 && songs.length != 0) {
			var newColor:FlxColor = songs[curSelected].color;

			if (newColor != selectedColor) {
				if (colorTween != null) {
					colorTween.cancel();
				}

				selectedColor = newColor;

				colorTween = FlxTween.color(bg, 0.25, bg.color, selectedColor, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
				});
			}
		} else {
			if (songs.length != 0) {
				bg.color = songs[curSelected].color;
			}
		}
		call("changeSelectionPost", [change]);
	}

	public function destroyFreeplayVocals(?destroyInst:Bool = true) {
		call("destroyFreeplayVocals", [destroyInst]);
		if (vocals != null) {
			vocals.stop();
			vocals.destroy();
		}

		vocals = null;

		if (!destroyInst)
			return;

		if (FlxG.sound.music != null) {
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();
		}

		FlxG.sound.music = null;
		call("destroyFreeplayVocalsPost", [destroyInst]);
	}

	override function beatHit() {
		call("beatHit");
		super.beatHit();

		if (lastSelectedSong != -1 && iconArray[lastSelectedSong] != null)
			iconArray[lastSelectedSong].scale.add(0.2, 0.2);
		call("beatHitPost");
	}
}

class SongMetadata {
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var difficulties:Array<String> = ["easy", "normal", "hard"];
	public var color:FlxColor = FlxColor.GREEN;
   // public var images:String = "";
	public function new(song:String, week:Int, songCharacter:String, ?difficulties:Array<String>, ?color:FlxColor) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		//this.images = (images != null && images.trim() != "") ? images : "";

		
		if (difficulties != null)
			this.difficulties = difficulties;

		if (color != null)
			this.color = color;
		else {
			if (FreeplayState.coolColors.length - 1 >= this.week)
				this.color = FreeplayState.coolColors[this.week];
			else
				this.color = FreeplayState.coolColors[0];
		}

	}
}
