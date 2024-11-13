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
		var inDistance:Bool = (distX <= 90 && distY <= 20);

		if (!inDistance || opponent.inShield)
		{
			super.attack(false);

			if (inDistance && opponent.inShield)
			{
				FlxG.camera.shake(0.005, 0.03);
				FlxG.sound.play("assets/sounds/shield.ogg").pitch = FlxG.random.float(0.9, 1.1);
			}
		}
		else
		{
			opponent.hit();
			super.attack(true);
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

		if (FlxG.keys.pressed.X)
			shield();

		if (FlxG.keys.justPressed.Z && attackTmr.finished && !inShield)
			attack(false);

		if (inFloor && FlxG.keys.justPressed.UP)
			jump();

		animCheck();
	}
}
