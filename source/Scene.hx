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

	public function new(sceneID:Int, overlay:FlxGroup)
	{
		super();

		this.overlay = overlay;

		collision = new FlxTypedGroup<FlxObject>();
		add(collision);

		floorY = FlxG.height - 60;

		var wall1 = new FlxSprite(-600, -800).makeGraphic(5, FlxG.height * 4, FlxColor.LIME);
		collision.add(wall1);

		var wall2 = new FlxSprite(FlxG.width + 600, -800, wall1.graphic);
		collision.add(wall2);

		wall1.visible = wall2.visible = false;

		FlxG.worldBounds.set(-4000, -4000, 8000, 8000);
		for (i in collision.members)
			i.immovable = true;

		loadMap(sceneID);
	}

	function loadMap(id:Int)
	{
		switch (id)
		{
			case 0: // Area Rural

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
