package ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

using StringTools;

class FreeplayTxt extends FlxSpriteGroup {
    public var delay:Float = 0.05;
    public var paused:Bool = false;
    public var targetY:Float = 0;
    public var isMenuItem:Bool = false;
    public var text:String = "";
    private var _finalText:String = "";
    private var _curText:String = "";
    public var widthOfWords:Float = FlxG.width;
    private var yMulti:Float = 1;
    private var lastWasSpace:Bool = false;
    private var splitWords:Array<String> = [];
    private var isBold:Bool = false;
    private var isTyped:Bool = false;
    
    public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false) {
        super(x, y);
        _finalText = text;
        this.text = text;
        isBold = bold;
        isTyped = typed;

        if (text != "") {
            if (typed) {
                startTypedText();
            } else {
                addText();
            }
        }
    }

    public function addText() {
        doSplitWords();
        var xPos:Float = 0;

        for (i in 0...splitWords.length) {
            var character = splitWords[i];
            if (character == " ") lastWasSpace = true;

            var fontSize:Int = isBold ? 64 : 48;
            if (character.length > 15) {
                fontSize = isBold ? 48 : 48;
            }


            var letter:FlxText = new FlxText(xPos, 0, 0, character, fontSize);
            letter.setFormat(Paths.font("EurostileExtendedBlack.ttf"), fontSize, 0xFF000000, "left");
            letter.borderStyle = FlxTextBorderStyle.OUTLINE;
            letter.borderColor = 0xFFFFFFFF; // blanco
            letter.borderSize = 2;
            letter.alpha = 1;

            if (lastWasSpace) {
                xPos += 40;
                lastWasSpace = false;
            }

            add(letter);
            xPos += letter.width;
        }
    }

	
	
	

    function doSplitWords():Void
        splitWords = _finalText.split("");

    public function startTypedText():Void {
        _finalText = text;
        doSplitWords();
        var xPos:Float = 0;
        var curRow:Int = 0;

        for (loopNum in 0..._finalText.length) {
            new FlxTimer().start(0.05 + (0.05 * loopNum), function(tmr:FlxTimer) {
                if (this != null && this.active && this.visible && this.alpha != 0) {
                    var letter:FlxText = new FlxText(xPos, 55 * yMulti, 0, splitWords[loopNum], isBold ? 24 : 18);
                    letter.setFormat(null, isBold ? 24 : 18, 0xFFFFFFFF, "left");
                    add(letter);
                    xPos += letter.width + 3;
                }
            });
        }
    }

    override function update(elapsed:Float) {
        if (isMenuItem) {
            var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
            var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
            y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), lerpVal);
            x = FlxMath.lerp(x, (targetY * 20) + 90, lerpVal);
        }
        super.update(elapsed);
    }
}
