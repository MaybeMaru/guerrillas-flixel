package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Player extends Person
{
	public function new()
	{
		super();
		x += 200;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT)
			move(-1);
		else if (FlxG.keys.pressed.RIGHT)
			move(1);
		else
			move(0);

		if (inFloor && FlxG.keys.justPressed.UP)
			jump();
	}
}
