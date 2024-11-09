package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Player extends Person
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT)
			velocity.x -= moveSpeed * elapsed * 20;
		else if (FlxG.keys.pressed.RIGHT)
			velocity.x += moveSpeed * elapsed * 20;
		else
			velocity.x = FlxMath.lerp(velocity.x, 0, elapsed * 20);

		if (inFloor && FlxG.keys.justPressed.UP)
			jump();
	}
}
