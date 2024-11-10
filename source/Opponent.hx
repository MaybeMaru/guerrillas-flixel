package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Opponent extends Person
{
	var player:Player;

	public function new(player:Player)
	{
		super();
		color = FlxColor.RED;
		this.player = player;
		slipResistance = 7.5;
		x -= 200;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		logic(elapsed);
	}

	var approachCooldown:Float = 0;
	var retreatCooldown:Float = 0;
	var attackCooldown:Float = 0;
	var jumpCooldown:Float = 0;

	function logic(elapsed:Float)
	{
		if (approachCooldown > 0)
			approachCooldown -= elapsed;

		if (retreatCooldown > 0)
			retreatCooldown -= elapsed;

		if (attackCooldown > 0)
			attackCooldown -= elapsed;

		if (jumpCooldown > 0)
			jumpCooldown -= elapsed;

		var dist = Math.abs(this.getMidpoint(FlxPoint.weak()).x - player.getMidpoint(FlxPoint.weak()).x);

		if (dist > 90)
		{
			// Approach player
			if (approachCooldown <= 0)
			{
				move((player.x < x) ? -1 : 1);
				approachCooldown = FlxG.random.float(0.2, 0.5);
			}

			// Random jump crap
			if (jumpCooldown <= 0 && FlxG.random.float() < 0.1)
			{
				jump();
				jumpCooldown = FlxG.random.float(3, 6);
			}
		}
		else if (life > 50 || FlxG.random.bool(10)) // Stop either because good life or be stupid
		{
			// Attack when close enough
			if (approachCooldown <= 0 && attackCooldown <= 0)
			{
				attack();
				attackCooldown = FlxG.random.float(0.5, 1.25);
			}

			move(0);
		}

		/*if (life < 50 && dist <= 150 && retreatCooldown <= 0)
			{
				move((player.x < x) ? 1 : -1);
				shield();
				retreatCooldown = 2;
			}
			else if (dist > 100 && approachCooldown <= 0)
			{
				move((player.x < x) ? -1 : 1);
				approachCooldown = 1.5;
			}
			else if (dist <= 50 && life > 50 && attackCooldown <= 0)
			{
				attack();
				attackCooldown = 1;
		}*/
	}
}
