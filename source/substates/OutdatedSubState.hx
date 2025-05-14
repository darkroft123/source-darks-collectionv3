package substates;


import states.MainMenuState;
import states.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OutdatedSubState extends MusicBeatState {
	private var version:String = 'vnull';

	public function new(?version:String = 'vnull') {
		this.version = version;
		super();
	}

	override function create() {
		super.create();

		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running an outdated version of the game!\nCurrent version is "
			+ CoolUtil.getCurrentVersion()
			+ " while the most recent version is "
			+ version
			+ "! Press Enter to go to the GitHub Page, or ESCAPE to ignore this!! (Probably shouldn't, but you can.)",
			32);
		txt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.ACCEPT) {
			FlxG.openURL("https://github.com/Vortex2Oblivion/LeatherEngine");
		}

		if (controls.BACK) {
			FlxG.switchState(() -> new MainMenuState());
		}
	}
}
