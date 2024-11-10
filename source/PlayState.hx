package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

// lime test hl
class PlayState extends FlxState
{
	var player:Player;
	var opponent:Opponent;

	var objects:FlxGroup;
	var scene:Scene;

	override public function create()
	{
		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 0.333, true);

		var sky = new FlxSprite().loadGraphic("assets/images/spainMap.png");
		sky.setGraphicSize(FlxG.width, FlxG.height);
		sky.updateHitbox();
		sky.scrollFactor.set(0.4, 0.4);
		sky.color = 0xff5e5e5e;
		add(sky);

		FlxG.mouse.visible = false;

		objects = new FlxGroup();
		add(objects);

		player = new Player();
		opponent = new Opponent(player);

		objects.add(opponent);
		objects.add(player);

		scene = new Scene();
		add(scene);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		zoomCamera();
		FlxG.collide(objects, scene);

		if (FlxG.keys.justPressed.R)
			FlxG.resetGame();
	}

	function zoomCamera()
	{
		var dist = player.getMidpoint(FlxPoint.weak()).distanceTo(opponent.getMidpoint(FlxPoint.weak()));

		var minDist = 800;
		var minZoom = 0.35;
		var maxZoom = 0.9;

		var zoom = FlxMath.bound(FlxMath.remapToRange(dist, 0, minDist, maxZoom, minZoom), minZoom, maxZoom);
		FlxG.camera.zoom = zoom;

		var playerOff = (player.x - (FlxG.width - player.width) / 2) / 4;
		var isNeg = playerOff <= 0;

		if (playerOff != 0)
			playerOff = Math.pow(Math.abs(playerOff), 1.25) * (isNeg ? -1 : 1);

		var camX = (FlxG.width / 2) + (playerOff * zoom);
		var camY = (FlxG.height / 2) * zoom;

		FlxG.camera.focusOn(FlxPoint.weak(camX, camY));
	}
}
