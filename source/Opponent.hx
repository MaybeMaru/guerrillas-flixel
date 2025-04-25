package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Opponent extends Person
{
	var player:Player;

	public function new(levelID:Int, player:Player)
	{
		super(levelID, false);
		this.player = player;
		slipResistance = 7.5;

		x -= 200;
		facing = RIGHT;

		retreatCooldown = FlxG.random.float(3, 6);
	}

	override function set_life(v:Float):Float
	{
		if (v <= 1)
			cast(FlxG.state, PlayState).win();
		return super.set_life(v);
	}

	public var agro:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (agro)
			logic(elapsed);
	}

	var approachCooldown:Float = 0;
	var retreatCooldown:Float = 0;
	var attackCooldown:Float = 0;
	var jumpCooldown:Float = 0;
	var shieldCooldown:Float = 0;

	override function attack(hit:Bool)
	{
		var playerMidpoint = player.getMidpoint();
		var oppMidpoint = this.getMidpoint();

		var distX = Math.abs(playerMidpoint.x - oppMidpoint.x);
		var distY = Math.abs(playerMidpoint.y - oppMidpoint.y);
		var inDistance:Bool = (distX <= 90 && distY <= 20);

		if (!inDistance || player.inShield)
		{
			super.attack(false);

			if (inDistance && player.inShield)
			{
				player.hitWithShield();
			}
		}
		else
		{
			player.hit(oppMidpoint.x > playerMidpoint.x ? RIGHT : LEFT);
			super.attack(true);
		}
	}

	override function hit(dir)
	{
		super.hit(dir);
		retreatCooldown -= FlxG.random.float(0.1, 0.3); // Recommend the opponent to back up
	}

	var escapeTimer:Float = 0;

	function logic(elapsed:Float)
	{
		inShield = false;

		if (approachCooldown > 0)
			approachCooldown -= elapsed;

		if (retreatCooldown > 0 || retreatCooldown < 0)
		{
			retreatCooldown -= elapsed;

			if (retreatCooldown <= 0)
			{
				if (FlxG.random.bool(0.35))
				{
					var doEscape = FlxG.random.bool(Math.abs(100 - life));
					retreatCooldown = doEscape ? FlxG.random.float(0.2, 0.6) : FlxG.random.float(1, 2.5);

					if (doEscape)
						escapeTimer = FlxG.random.float(0.2, 0.4);
				}
				else
				{
					retreatCooldown = FlxG.random.float(1, 2.5);
				}
			}
		}

		if (attackCooldown > 0)
			attackCooldown -= elapsed;

		if (jumpCooldown > 0)
			jumpCooldown -= elapsed;

		if (shieldCooldown > 0)
			shieldCooldown -= elapsed;

		var dist = Math.abs(this.getMidpoint(FlxPoint.weak()).x - player.getMidpoint(FlxPoint.weak()).x);

		// shield if fucked
		if (shieldCooldown <= 0 && leftShieldHits > 0 && !inFloor && dist <= 90)
		{
			var shouldShield = (!player.attackTmr.finished && FlxG.random.bool(80)) // getting attacked
				|| (life < 50 && FlxG.random.bool(50)) // at low health
				|| (dist <= 90 && FlxG.random.bool(20)); // player is close

			if (shouldShield)
			{
				shield();
				shieldCooldown = FlxG.random.float(2, 4);
			}
		}

		// Escape from player
		if (escapeTimer > 0)
		{
			escapeTimer -= elapsed;
			move((player.x < x) ? 1 : -1);
		}
		else if (dist > 90)
		{
			// Approach player
			if (approachCooldown <= 0)
			{
				move(((player.x < x) ? -1 : 1));
				approachCooldown = FlxG.random.float(0.2, 0.5);
			}

			// Random jump crap
			if (jumpCooldown <= 0 && FlxG.random.bool(10))
			{
				jump();
				jumpCooldown = FlxG.random.float(3, 6);
			}
		}
		else if (life > 50 || FlxG.random.bool(10)) // Stop either because good life or be stupid
		{
			// Attack when close enough
			if (approachCooldown <= 0 && attackCooldown <= 0 && !inShield)
			{
				attack(false);
				attackCooldown = FlxG.random.float(0.5, 1.25);
			}

			move(0);
		}

		facing = ((player.x < x) && (escapeTimer <= 0)) ? LEFT : RIGHT;
	}
}
