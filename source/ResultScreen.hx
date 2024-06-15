package;

import flixel.FlxG;
import flixel.FlxGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.FlxSprite;

class ResultScreen extends MusicBeatSubstate
{
    override function create():Void
    {
        
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

        var score:Float;
	var noteMissed:Float;
        var rank:FlxSprite;
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

}
//wip --diaz
