package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Player extends Person
{
	public var opponent:Opponent;

	public function new()
	{
		super();
		x += 200;
	}

	override function attack(hit:Bool)
	{
		var playerMidpoint = this.getMidpoint();
		var oppMidpoint = opponent.getMidpoint();

		var distX = Math.abs(playerMidpoint.x - oppMidpoint.x);
		var distY = Math.abs(playerMidpoint.y - oppMidpoint.y);

		if (!opponent.inShield && distX <= 90 && distY <= 20)
		{
			opponent.hit();
			super.attack(true);
		}
		else
		{
			super.attack(false);
		}
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

		if (FlxG.keys.justPressed.Z)
			attack(false);

		if (FlxG.keys.pressed.X)
			shield();

		if (inFloor && FlxG.keys.justPressed.UP)
			jump();
	}
}
