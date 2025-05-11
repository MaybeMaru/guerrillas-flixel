package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.geom.ColorTransform;

using flixel.util.FlxColorTransformUtil;

class Scene extends FlxGroup
{
	public var collision:FlxTypedGroup<FlxObject>;

	public var overlay:FlxGroup;

	var floorY:Float = 0;

	public var wall1:FlxSprite;
	public var wall2:FlxSprite;

	public function new(sceneID:Int, overlay:FlxGroup)
	{
		super();

		this.overlay = overlay;

		collision = new FlxTypedGroup<FlxObject>();

		floorY = FlxG.height - 60;

		wall1 = new FlxSprite(-600, -800).makeGraphic(1, 1, FlxColor.LIME);
		wall1.setGraphicSize(100, FlxG.height * 4);
		wall1.updateHitbox();
		wall1.x -= wall1.width;
		collision.add(wall1);

		wall2 = new FlxSprite(FlxG.width + 600, -800, wall1.graphic);
		wall2.setGraphicSize(wall1.width, wall1.height);
		wall2.updateHitbox();
		collision.add(wall2);

		// wall1.visible = wall2.visible = false;

		FlxG.worldBounds.set(-4000, -4000, 8000, 8000);

		loadMap(sceneID);

		for (i in collision.members)
			i.immovable = true;

		collision.visible = false;
		add(collision);
	}

	function loadMap(id:Int)
	{
		switch (id)
		{
			case 0: // Area Rural
				var sky = FlxGradient.createGradientFlxSprite(1, FlxG.height, [0xff8bb1ff, 0xff4c85f8], 1);
				sky.scale.set(FlxG.width * 4, 1.5);
				sky.scrollFactor.set(0, 0.1);
				sky.y -= 100;
				add(sky);

				var clouds = new FlxBackdrop("assets/images/stage/clouds.png", X, 50);
				clouds.setPosition(200, 150);
				clouds.scale.set(1.5, 1.5);
				clouds.updateHitbox();
				clouds.scrollFactor.set(0.08, 0.08);
				clouds.blend = SCREEN;
				clouds.alpha = 0.3;
				clouds.velocity.x = 3;
				clouds.color = 0xff407CD4;
				clouds.flipX = true;
				add(clouds);

				var clouds = new FlxBackdrop("assets/images/stage/clouds.png", X, 150);
				clouds.setPosition(-150, 0);
				clouds.scale.set(3, 3);
				clouds.updateHitbox();
				clouds.scrollFactor.set(0.12, 0.12);
				clouds.blend = SCREEN;
				clouds.alpha = 0.6;
				clouds.velocity.x = 5;
				add(clouds);

				var mountains = new FlxBackdrop("assets/images/stage/mountains.png", X);
				mountains.setPosition(200, 175);
				mountains.scale.set(3, 3);
				mountains.updateHitbox();
				mountains.scrollFactor.set(0.2, 0.2);
				mountains.color = 0xff88a6e1;
				add(mountains);

				var hills = new FlxBackdrop("assets/images/stage/hills.png", X);
				hills.setPosition(200, 200);
				hills.scale.set(3, 3);
				hills.updateHitbox();
				hills.scrollFactor.set(0.35, 0.35);
				hills.color = 0xff88a6e1;
				add(hills);

				var house = new FlxSprite(-300, 150, "assets/images/stage/house.png");
				house.scale.set(3, 3);
				house.updateHitbox();
				house.scrollFactor.set(0.45, 0.45);
				house.color = 0xffdee4ef;
				add(house);

				var hills = new FlxBackdrop("assets/images/stage/hills.png", X);
				hills.setPosition(-50, 275);
				hills.flipX = true;
				hills.scale.set(4, 5);
				hills.updateHitbox();
				hills.scrollFactor.set(0.5, 0.5);
				add(hills);

				var house = new FlxSprite(500, 170, "assets/images/stage/house.png");
				house.scale.set(4.5, 4.5);
				house.updateHitbox();
				house.scrollFactor.set(0.7, 0.7);
				add(house);

				var floor = new FlxBackdrop("assets/images/stage/grass.png", X);
				floor.y = floorY - 35;
				floor.scale.set(3, 4);
				floor.updateHitbox();
				floor.screenCenter(X);
				add(floor);

				var glow = new FlxSprite("assets/images/stage/veolaluz.png");
				glow.setGraphicSize(FlxG.width * 1.2, FlxG.height * 1.2);
				glow.updateHitbox();
				glow.screenCenter();
				glow.blend = ADD;
				glow.scrollFactor.set(0.05, 0.05);
				glow.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
				glow.alpha = 0.6;
				overlay.add(glow);

			case 1: // Iglesia

				var back = new FlxSprite(0, 0, "assets/images/stage/church.png");
				back.scale.set(3, 3);
				back.updateHitbox();
				back.scrollFactor.set(0.15, 0.35);
				back.screenCenter();
				add(back);

				back.y -= 50;
				back.color = 0xffa59494;

				var floor = new FlxBackdrop("assets/images/stage/floor.png", X);
				floor.y = floorY - 5;
				floor.scale.set(3, 3);
				floor.updateHitbox();
				floor.screenCenter(X);

				var ceiling = new FlxBackdrop("assets/images/stage/floor.png", X);
				ceiling.y = -300;
				ceiling.flipY = true;
				ceiling.scale.set(3, 3);
				ceiling.updateHitbox();
				ceiling.screenCenter(X);
				ceiling.color = 0xffa59494;
				ceiling.scrollFactor.set(0.78, 0.78);
				add(ceiling);

				for (i in 0...8)
				{
					var mini = new FlxSprite((i * FlxG.width * 0.6) - FlxG.width * 1.1, -275, "assets/images/stage/columnajonica.png");
					mini.color = 0xffa59494;
					mini.scale.set(1.5, 1.5);
					mini.updateHitbox();
					mini.scrollFactor.set(0.8, 0.8);
					add(mini);
				}

				add(floor);

				var light = new FlxSprite(-600, 0, "assets/images/stage/light.png");
				light.scale.set(6, 6);
				light.updateHitbox();
				light.y = floorY - light.height;
				light.blend = ADD;
				overlay.add(light);

				for (i in 0...4)
				{
					var column = new FlxSprite((i * (FlxG.width * 1.2)) - FlxG.width * 1.4, -250, "assets/images/stage/columnajonica.png");
					column.color = 0xffd1c6c6;
					column.scale.set(2.25, 2.25);
					column.updateHitbox();
					column.scrollFactor.set(1.5, 1.5);
					overlay.add(column);
				}

			case 2: // Pirineos

				var sky = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xff051431, 0xff09021a], 1);
				sky.scrollFactor.set(0, 0.05);
				sky.scale.set(3, 2.5);
				add(sky);

				var bg = new FlxBackdrop("assets/images/stage/pirineos.png", X);
				bg.y = 150;
				bg.scrollFactor.set(0.1, 0.1);
				bg.color = 0xff405293;
				bg.scale.set(3, 3);
				add(bg);

				var bg = new FlxBackdrop("assets/images/stage/pirineos.png", X);
				bg.y = 200;
				bg.flipX = true;
				bg.x += 300;
				bg.scrollFactor.set(0.2, 0.2);
				bg.color = 0xff67a1c7;
				bg.scale.set(3, 3);
				add(bg);

				var trees = new FlxBackdrop("assets/images/stage/trees.png", X);
				trees.y = 350;
				trees.scrollFactor.set(0.23, 0.23);
				trees.scale.set(3, 3);
				trees.color = 0xff67a1c7;
				add(trees);

				var trees = new FlxBackdrop("assets/images/stage/trees.png", X);
				trees.y = 400;
				trees.flipX = true;
				trees.x += 300;
				trees.scrollFactor.set(0.35, 0.35);
				trees.scale.set(4.5, 4.5);
				add(trees);

				var snow = new FlxBackdrop("assets/images/stage/snow.png", X);
				snow.x = -200;
				snow.y = floorY - 5;
				snow.scale.set(3, 3);
				snow.updateHitbox();
				add(snow);

				var emmiter = new FlxEmitter();
				emmiter.setPosition(-FlxG.width * 2, -200);
				emmiter.setSize(FlxG.width * 4, FlxG.height * 1.5);
				emmiter.makeParticles(6, 6, FlxColor.WHITE, 100);
				emmiter.emitting = true;
				emmiter.start(false);
				emmiter.acceleration.set(0, 40);
				overlay.add(emmiter);

				for (i in 0...25)
					emmiter.emitParticle();

				emmiter.memberAdded.add((snow) ->
				{
					snow.scrollFactor.set(FlxG.random.float(1.55, 1.6), FlxG.random.float(1.55, 1.6));
				});

				var frozen = new FlxSprite(0, 0, "assets/images/stage/frozen.png");
				frozen.setGraphicSize(FlxG.width, FlxG.height);
				frozen.updateHitbox();
				frozen.scale.scale(1.25, 1.25);
				frozen.blend = ADD;
				frozen.scrollFactor.set();
				frozen.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
				frozen.alpha = 0.75;
				overlay.add(frozen);

				tint(0xffadd2eb);
		}
	}

	function tint(color:FlxColor)
	{
		var instance:PlayState = cast FlxG.state;
		instance.player.colorTransform.concat(transform(color));
		instance.opponent.colorTransform.concat(transform(color));
	}

	function transform(color:FlxColor)
	{
		return new ColorTransform(color.redFloat, color.greenFloat, color.blueFloat);
	}
}
