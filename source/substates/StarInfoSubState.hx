package substates;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;

class StarInfoSubState extends MusicBeatSubstate {

    
    public function new(totals:{rose:Int, blue:Int, gold:Int, marks:Int, totalDifficulties:Int}, totalSongs:Int){

        super();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
        add(bg);

        var title = new FlxText(0, 50, FlxG.width, "Obtained Stars", 40);
        title.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, "center");
        add(title);

        var starsData = [
            { name: "rose star", count: totals.rose },
            { name: "blue star", count: totals.blue },
            { name: "gold star", count: totals.gold }
        ];

        for (i in 0...3) {
            var starName = "black star";
            var countText = "0";

            if (i < starsData.length) {
                starName = starsData[i].name;
                countText = Std.string(starsData[i].count);
            }

            var xPos = (FlxG.width / 2) - 500 + i * 250;
            var star = new FlxSprite(xPos, 200);
            star.loadGraphic(Paths.image(starName));
            star.scale.set(0.5, 0.5);
            star.antialiasing = true;
            star.updateHitbox();
            add(star);

            var numberText = new FlxText(xPos + 60, 400, 100, countText);
            numberText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, "center");
            add(numberText);
        }

        var info = new FlxText(0, FlxG.height - 50, FlxG.width, "Press ESC or ENTER to exit", 24);
        info.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
        add(info);

       
        var mark = new FlxSprite(900, 200);
        mark.loadGraphic(Paths.image("green mark"));
        mark.scale.set(0.5, 0.5);
        mark.antialiasing = true;
        mark.updateHitbox();
        add(mark);

       var markCounterText = new FlxText(mark.x - 10, mark.y + 200, 0, totals.marks + " / " + (totalSongs + totals.totalDifficulties), 24);
        markCounterText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, LEFT);
        markCounterText.scrollFactor.set();
        trace(totalSongs);
        add(markCounterText);

    

        var red = new FlxText(0, 460, FlxG.width, "Rose Star : 80 % ACC", 24);
        red.setFormat(Paths.font("vcr.ttf"), 32, 0xFFFF69B4, "center");
        red.scrollFactor.set();
        add(red);

        var blue = new FlxText(0, red.y + 40, FlxG.width, "Blue Star : 90 % ACC", 24);
        blue.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.CYAN, "center");
        blue.scrollFactor.set();
        add(blue);

        var gold = new FlxText(0, blue.y + 40, FlxG.width, "Gold Star : 95 % ACC", 24);
        gold.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.ORANGE, "center");
        gold.scrollFactor.set();
        add(gold);

        var green = new FlxText(0, gold.y + 40, FlxG.width, "Green Mark : CLEAR", 24);
        green.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.LIME, "center");
        green.scrollFactor.set();
        add(green);


    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER) {
            FlxG.state.closeSubState();
        }
    }
}

