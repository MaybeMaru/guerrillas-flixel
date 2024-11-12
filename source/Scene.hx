package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;

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
		var floor = new FlxSprite(0, floorY).makeGraphic((FlxG.width * 4), 60, FlxColor.BLUE);
		floor.screenCenter(X);
		floor.updateHitbox();
		collision.add(floor);

		var wall1 = new FlxSprite(-600, -800).makeGraphic(5, FlxG.height * 4, FlxColor.LIME);
		collision.add(wall1);

		var wall2 = new FlxSprite(FlxG.width + 600, -800, wall1.graphic);
		collision.add(wall2);

		wall1.visible = wall2.visible = floor.visible = false;

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
				snow.y = floorY;
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

				// pregen some particles
				emmiter.update(10);

				emmiter.memberAdded.add((snow) ->
				{
					snow.scrollFactor.set(FlxG.random.float(1.55, 1.6), FlxG.random.float(1.55, 1.6));
				});
		}
	}
}
