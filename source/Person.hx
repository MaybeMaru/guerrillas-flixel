package;

import flixel.FlxSprite;

class Person extends FlxSprite
{
	var jumpForce = 500;
	var moveSpeed = 300;

	var inFloor:Bool = false;

	public function new()
	{
		super();

		makeGraphic(60, 120);
		updateHitbox();
		screenCenter();

		acceleration.y = 1000;
		maxVelocity.y = jumpForce;
		maxVelocity.x = moveSpeed;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		inFloor = (y >= 300);
	}

	function jump()
	{
		y--;
		velocity.y = -jumpForce;
		inFloor = false;
	}
}
