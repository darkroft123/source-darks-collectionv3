package substates;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utilities.StarLoader;
import substates.StarInfoSubState;
import openfl.utils.Assets;
class LoadingStarsSubstate extends MusicBeatSubstate {
    var songs:Array<Dynamic>;
    var statusText:FlxText;

    public function new(songs:Array<Dynamic>) {
        super();
        this.songs = songs;
    }

    override function create() {
        super.create();

        var validSongs = songs.filter(function(song) {
            return song.song != '---';
        });

        

        statusText = new FlxText(0, 0, FlxG.width, "loading stars...", 24);
        statusText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
        statusText.screenCenter();
        add(statusText);

        var result = StarLoader.getTotalStars(validSongs);
        FlxG.state.openSubState(new StarInfoSubState(result, validSongs.length));
        close();
    }

}
