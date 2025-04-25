package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Player extends Person
{
	public var opponent:Opponent;
	public var score:Int = 0;

	public function new(levelID:Int)
	{
		super(levelID, true);
		x += 200;
		facing = LEFT;
	}

	override function set_life(v:Float):Float
	{
		if (v <= 1)
			cast(FlxG.state, PlayState).lose();
		return super.set_life(v);
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
				opponent.hitWithShield();
			}
		}
		else
		{
			opponent.hit();
			super.attack(true);
			score += 50;
		}
	}

	override function hit()
	{
		super.hit();
		score -= 25;
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

		if (FlxG.keys.justPressed.X)
			shield();
		else if (FlxG.keys.released.X)
			inShield = false;

		if (FlxG.keys.justPressed.Z && attackTmr.finished && !inShield)
			attack(false);

		if (inFloor && FlxG.keys.justPressed.UP)
			jump();
	}
}
