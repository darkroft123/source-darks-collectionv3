package game;

import flixel.FlxG;
import flixel.math.FlxMath;
import game.Tallies;

class Highscore {
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRanks:Map<String, String> = new Map<String, String>();
	public static var songAccuracies:Map<String, Float> = new Map<String, Float>();

	public static function resetSong(song:String, ?diff:String = "easy"):Void {
		var daSong:String = formatSong(song, diff);

		setScore(daSong, 0);
		setRank(daSong, "N/A");
		setAccuracy(daSong, 0);
	}

	public static inline function resetWeek(week:Int = 1, ?diff:String = "easy", ?weekName:String = 'week'):Void {
		setScore(formatSong(weekName + week, diff), 0);
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:String = "easy"):Void {
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		} else
			setScore(daSong, score);
	}

	public static function saveRank(song:String, rank:String = "N/A", diff:String = "easy", accuracy:Float = 0):Void {
		var daSong:String = formatSong(song, diff);

		if (songRanks.exists(daSong)) {
			if (accuracy > getSongAccuracy(song, diff)) {
				setRank(daSong, rank);
				setAccuracy(daSong, accuracy);
			}
		} else {
			setRank(daSong, rank);
			setAccuracy(daSong, accuracy);
		}
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:String = "easy", ?weekName:String = 'week'):Void {
		var daWeek:String = formatSong(weekName + week, diff);

		if (songScores.exists(daWeek)) {
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		} else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);

		Options.setData(songScores, "songScores", "scores");
	}

	static function setRank(song:String, rank:String):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		songRanks.set(song, rank);

		Options.setData(songRanks, "songRanks", "scores");
	}

	static function setAccuracy(song:String, accuracy:Float):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		songAccuracies.set(song, accuracy);

		Options.setData(songAccuracies, "songAccuracies", "scores");
	}

	public static function formatSong(song:String, diff:String, ?mix:String):String {
		var returnSong:String = song.toLowerCase();

		if (diff.toLowerCase() != "normal")
			returnSong += "-" + diff.toLowerCase();

		if (mix != null)
			returnSong += "-" + mix.toLowerCase();

		return returnSong;
	}

	public static function getScore(song:String, diff:String, ?mix:String, ?formatted:Bool = false):Int {
		if (!songScores.exists(formatSong(song, diff)))
			setScore((!formatted ? formatSong(song, diff) : song), 0);

		return songScores.get((!formatted ? formatSong(song, diff) : song));
	}

	public static function getWeekScore(week:Int, diff:String, ?weekName:String = 'week', ?formatted:Bool = false):Int {
		if (!songScores.exists(formatSong(weekName + week, diff)))
			setScore(formatSong(weekName + week, diff), 0);

		return songScores.get(formatSong(weekName + week, diff));
	}

	public static function getSongRank(song:String, diff:String, ?formatted:Bool = false):String {
		if (!songRanks.exists((!formatted ? formatSong(song, diff) : song)))
			setRank((!formatted ? formatSong(song, diff) : song), "N/A");

		return songRanks.get((!formatted ? formatSong(song, diff) : song));
	}

	public static function getSongAccuracy(song:String, diff:String, ?formatted:Bool = false):Float {
		if (!songAccuracies.exists((!formatted ? formatSong(song, diff) : song)))
			setAccuracy((!formatted ? formatSong(song, diff) : song), 0);

		return FlxMath.roundDecimal(songAccuracies.get((!formatted ? formatSong(song, diff) : song)), 2);
	}



	public static function load():Void {
		if (Options.getData("songScores", "scores") != null)
			songScores = Options.getData("songScores", "scores");

		if (Options.getData("songRanks", "scores") != null)
			songRanks = Options.getData("songRanks", "scores");

		if (Options.getData("songAccuracies", "scores") != null)
			songAccuracies = Options.getData("songAccuracies", "scores");
	}

	public static function importOldData() {
		FlxG.save.bind('leathersfunkinengine', 'leather128');

		var funnyScores = songScores;
		var funnyRanks = songRanks;
		var funnyAccuracies = songAccuracies;

		if (FlxG.save.data.songScores != null)
			funnyScores = FlxG.save.data.songScores;

		if (FlxG.save.data.songRanks != null)
			funnyRanks = FlxG.save.data.songRanks;

		if (FlxG.save.data.songAccuracies != null)
			funnyAccuracies = FlxG.save.data.songAccuracies;

		for (key in funnyScores.keys()) {
			if (key != null) {
				if (getScore(key, "", true) < funnyScores.get(key)) {
					setScore(key, funnyScores.get(key));

					if (funnyAccuracies.exists(key))
						setAccuracy(key, funnyAccuracies.get(key));

					if (funnyRanks.exists(key))
						setRank(key, funnyRanks.get(key));
				}
			}
		}

		FlxG.save.close();
	}
}
