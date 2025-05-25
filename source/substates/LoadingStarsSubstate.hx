
package substates;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utilities.StarLoader;
import substates.StarInfoSubState;

class LoadingStarsSubstate extends MusicBeatSubstate {
    var songs:Array<Dynamic>;
    var statusText:FlxText;

    public function new(songs:Array<Dynamic>) {
        super();
        this.songs = songs;
    }

    override function create() {
        super.create();

        statusText = new FlxText(0, 0, FlxG.width, "Calculando estrellas...", 24);
        statusText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
        statusText.screenCenter();
        add(statusText);

        var result = StarLoader.getTotalStars(songs);

        FlxG.state.openSubState(new StarInfoSubState(result, songs.length));
        close(); // cierra este substate ya que terminó la carga
    }
}
