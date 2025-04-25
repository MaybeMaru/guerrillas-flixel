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
	var life(default, set):Float = 100;

	function set_life(v)
	{
		return life = v;
	}

	public function new(levelID:Int, isPlayer:Bool)
	{
		super();

		loadGraphic('assets/images/characters/${(isPlayer ? (switch (levelID) {
			case 1: "merino";
			case 2: "espoz";
			default: "soldier";
		}) : "frenchie")}.png', true, 50, 50);

		animation.add("idle", [0, 1], 6);
		animation.add("jump", [2, 3], 6);
		animation.add("punch", [4, 5], 6);
		animation.add("walk", [6, 7, 8, 7], 6);
		animation.add("shield", [9, 10, 10, 10, 10, 10, 10], 6, false);

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
		moving = false;

		if (lastInFloor != inFloor)
		{
			lastInFloor = inFloor;
			if (inFloor)
				hitFloor();
		}

		if (!inShield && leftShieldHits < 3)
		{
			regainShieldCooldown += elapsed;
			if (regainShieldCooldown >= regainShieldTime)
			{
				regainShieldCooldown -= regainShieldTime;
				leftShieldHits++;
			}
		}
	}

	var inShield:Bool = false;
	var regainShieldCooldown:Float = 0;
	var regainShieldTime:Float = 1.0;
	var leftShieldHits:Int = 3;

	function shield():Void
	{
		if (leftShieldHits <= 0)
			return;

		if (animation.curAnim.name != "shield")
		{
			FlxG.sound.play("assets/sounds/shield_equip.ogg").pitch = FlxG.random.float(0.9, 1);
			playAnim("shield");
		}
		inShield = true;
	}

	var weakness:Float = 3.333;

	function hit():Void
	{
		life -= weakness;
	}

	function hitWithShield()
	{
		FlxG.camera.shake(0.005, 0.03);
		FlxG.sound.play("assets/sounds/shield.ogg").pitch = FlxG.random.float(0.9, 1.1);

		leftShieldHits--;

		if (leftShieldHits == 0)
		{
			inShield = false;
			FlxG.sound.play("assets/sounds/shield_break.ogg").pitch = FlxG.random.float(0.9, 1.1);
		}
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
		playAnim("punch", true, 0.333, () -> playAnim(inFloor ? "idle" : "jump"));
		FlxG.sound.play("assets/sounds/" + (hit ? "hit" : "swipe") + FlxG.random.int(1, 3) + ".ogg", 0.7).pitch = FlxG.random.float(0.8, 1);

		if (hit)
			FlxG.camera.shake(0.01, 0.05);
	}

	var accelSpeed:Float = 20;
	var speedMult:Float = 1;
	var slipResistance:Float = 20;

	function move(dir:Int)
	{
		var canAnim = !inShield && inFloor && attackTmr.finished;
		speedMult = inShield ? 0.4 : 1;

		switch (dir)
		{
			case 1 | -1:
				velocity.x += moveSpeed * FlxG.elapsed * accelSpeed * dir * speedMult;
				velocity.x = FlxMath.bound(velocity.x, -maxVelocity.x * speedMult, maxVelocity.x * speedMult);
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
		if (!inShield)
			playAnim("jump", true);
		FlxG.sound.play("assets/sounds/jump.ogg").pitch = FlxG.random.float(0.9, 1.1);
	}

	function hitFloor()
	{
		FlxG.sound.play("assets/sounds/land.ogg").pitch = FlxG.random.float(0.9, 1.1);
	}
}
