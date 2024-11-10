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

		loadGraphic("assets/images/characters/test.png", true, 15, 30);

		animation.add("idle", [0]);
		animation.add("jump", [1]);
		animation.add("punch1", [2]);
		animation.add("punch2", [3]);
		animation.add("shield", [4]);

		animation.play("idle");
		updateHitbox();

		setGraphicSize(60, 120);
		updateHitbox();

		y = 301;
		screenCenter(X);

		acceleration.y = 1000;
		maxVelocity.y = jumpForce;
		maxVelocity.x = moveSpeed;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
	}

	var lastInFloor:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		inFloor = (y >= 300);

		if (lastInFloor != inFloor)
		{
			lastInFloor = inFloor;

			if (inFloor)
				animation.play("idle");
		}
	}

	function shield()
	{
		animation.play("shield", true);
	}

	var attc:Int = 0;

	function attack()
	{
		attc++;
		attc %= 2;

		animation.play("punch" + (attc + 1), true);
		FlxG.sound.play("assets/sounds/hit" + FlxG.random.int(1, 3) + ".ogg").pitch = FlxG.random.float(0.9, 1.1);
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
		animation.play("jump", true);
	}
}
