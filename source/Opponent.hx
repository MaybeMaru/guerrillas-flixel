package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Opponent extends Person
{
	public function new()
	{
		super();
		color = FlxColor.RED;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.A)
			velocity.x -= moveSpeed * elapsed * 20;
		else if (FlxG.keys.pressed.D)
			velocity.x += moveSpeed * elapsed * 20;
		else
			velocity.x = FlxMath.lerp(velocity.x, 0, elapsed * 20);
	}
}
