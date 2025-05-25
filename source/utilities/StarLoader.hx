package utilities;

import utilities.Controls;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxSignal;
import game.SongLoader;
import game.Highscore;

class StarLoader {
  
  public static function getTotalStars(songs:Array<Dynamic>):{ rose:Int, blue:Int, gold:Int, marks:Int, totalDifficulties:Int } {
    var totalRose = 0;
    var totalBlue = 0;
    var totalGold = 0;
    var greenMarks = 0;

    var difficulties = [
      "voiid", "standard", "sported out", "corrupted", "god", "godly", "double god", "canon", "old", "easier",
      "100%", "goodles 100%", "infinite", "voiid god", "nogod", "double god 8k", "godly 6k", "godly 9k", "hard",
      "paper", "unt0ld", "food styles", "4k mania", "double infinite", "wtf", "infinite 10", "new infinite 10k",
      "unknown", "8k god", "double godly", "swole", "triple god", "triple god no modchart", "god new", "god new 9k",
      "remix"
    ];

    for (i in 1...22) difficulties.push(i + "k");
    for (i in 1...22) difficulties.push("god " + i + "k");

    for (song in songs) {
      var hasScore = false;

      for (diff in difficulties) {
        var accuracy = Highscore.getSongAccuracy(song.songName, diff);
        var score = Highscore.getScore(song.songName, diff);

        if (!hasScore && score > 0) {
          hasScore = true;
        }

        if (accuracy >= 95) {
          totalGold++;
          totalBlue++;
          totalRose++;
        } else if (accuracy >= 90) {
          totalBlue++;
          totalRose++;
        } else if (accuracy >= 80) {
          totalRose++;
        }
      }

      if (hasScore) {
        greenMarks++;
      }
    }

    return {
      rose: totalRose,
      blue: totalBlue,
      gold: totalGold,
      marks: greenMarks,
      totalDifficulties: difficulties.length
    };
  }
}
