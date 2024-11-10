package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Person extends FlxSprite
{
	var jumpForce = 500;
	var moveSpeed = 300;

	var inFloor:Bool = false;
	var life:Float = 100;

	public function new()
	{
		super();

		makeGraphic(60, 120);
		updateHitbox();

		y = 301;
		screenCenter(X);

		acceleration.y = 1000;
		maxVelocity.y = jumpForce;
		maxVelocity.x = moveSpeed;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		inFloor = (y >= 300);
	}

	function shield()
	{
		trace("OH FUCK");
	}

	function attack()
	{
		trace("PUNCH");
	}

	var accelSpeed:Float = 20;
	var slipResistance:Float = 20;

	function move(dir:Int)
	{
		switch (dir)
		{
			case 1 | -1:
				velocity.x += moveSpeed * FlxG.elapsed * accelSpeed * dir;
				facing = (dir == 1) ? RIGHT : LEFT;
			case 0:
				velocity.x = FlxMath.lerp(velocity.x, 0, FlxG.elapsed * slipResistance);
		}
	}

	function jump()
	{
		y--;
		velocity.y = -jumpForce;
		inFloor = false;
	}
}
