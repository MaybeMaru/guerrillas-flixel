package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Person extends FlxSprite
{
	var jumpForce = 500;
	var moveSpeed = 300;

	var inFloor:Bool = false;
	var life:Float = 100;

	public function new()
	{
		super();

		// loadGraphic("assets/images/characters/test.png", true, 15, 30);
		loadGraphic("assets/images/characters/soldier.png", true, 50, 50);

		animation.add("idle", [0, 1], 6);
		animation.add("jump", [2, 3], 6);
		animation.add("punch", [4, 5], 6);
		animation.add("walk", [6, 7, 8, 7], 6);
		// animation.add("punch2", [3]);
		// animation.add("shield", [4]);

		playAnim("idle", true);
		updateHitbox();

		setGraphicSize(120, 120);
		updateHitbox();

		y = 301;
		screenCenter(X);

		acceleration.y = 1000;
		maxVelocity.y = jumpForce;
		maxVelocity.x = moveSpeed;

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		attackTmr.start(0.1);
	}

	override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
	{
		var pnt = super.getScreenPosition(result, camera);
		if (flipX)
			pnt.x -= width / 2;
		return pnt;
	}

	var lastInFloor:Bool = false;
	var moving:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (y >= 300)
			y = 300;

		inFloor = (y >= 300);
		inShield = false;
		moving = false;

		if (lastInFloor != inFloor)
		{
			lastInFloor = inFloor;
			if (inFloor)
				hitFloor();
		}
	}

	function hitFloor() {}

	var inShield:Bool = false;

	function shield():Void
	{
		playAnim("shield", true);
		inShield = true;
	}

	var weakness:Float = 3.333;

	function hit():Void
	{
		life -= weakness;
	}

	var animTmr:FlxTimer = new FlxTimer();

	function playAnim(anim:String, ?forced:Bool, ?wait:Float, ?callback:Void->Void)
	{
		animation.play(anim, forced ?? false);
		animTmr.cancel();

		if (wait != null)
			animTmr.start(wait, (tmr) -> callback());
	}

	var attackTmr:FlxTimer = new FlxTimer();

	function attack(hit:Bool)
	{
		attackTmr.start(0.333);
		playAnim("punch", true, 0.333, () -> playAnim("idle"));
		FlxG.sound.play("assets/sounds/" + (hit ? "hit" : "swipe") + FlxG.random.int(1, 3) + ".ogg").pitch = FlxG.random.float(0.9, 1.1);

		if (hit)
			FlxG.camera.shake(0.01, 0.05);
	}

	var accelSpeed:Float = 20;
	var slipResistance:Float = 20;

	function move(dir:Int)
	{
		var canAnim = !inShield && inFloor && attackTmr.finished;

		switch (dir)
		{
			case 1 | -1:
				velocity.x += moveSpeed * FlxG.elapsed * accelSpeed * dir;
				facing = (dir == 1) ? RIGHT : LEFT;
				if (canAnim)
					playAnim("walk");
			case 0:
				velocity.x = FlxMath.lerp(velocity.x, 0, FlxG.elapsed * slipResistance);
				if (canAnim)
					playAnim("idle");
		}
	}

	function jump()
	{
		y--;
		velocity.y = -jumpForce;
		inFloor = false;
		playAnim("jump", true);
	}
}
