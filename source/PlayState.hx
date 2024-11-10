package;

import MapState.PointData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

// lime test hl
class PlayState extends FlxState
{
	var player:Player;
	var opponent:Opponent;

	var objects:FlxGroup;
	var scene:Scene;

	var pointData:PointData;

	public function new(pointData:PointData)
	{
		super();
		this.pointData = pointData;
	}

	override public function create()
	{
		super.create();

		pointData ??= {
			name: "Madrid",
			year: 1808,
			present: {
				player: "juan",
				playerDescription: 'Juan Martín Díez\n\n"El Empecinado"\nMilitar español\n1775-1825',
				enemy: "frances1",
				enemyDescription: 'Soldado francés #003\n\n"Baguette Baguette Cruasán"',
			}
		}

		var sky = new FlxSprite().loadGraphic("assets/images/spainMap.png");
		sky.setGraphicSize(FlxG.width, FlxG.height);
		sky.updateHitbox();
		sky.scrollFactor.set(0.4, 0.4);
		sky.color = 0xff5e5e5e;
		add(sky);

		FlxG.camera.bgColor = FlxColor.GRAY;

		FlxG.mouse.visible = false;

		objects = new FlxGroup();
		add(objects);

		player = new Player();
		opponent = new Opponent(player);

		objects.add(opponent);
		objects.add(player);

		scene = new Scene();
		add(scene);

		persistentDraw = false;
		var cam = FlxG.cameras.add(new FlxCamera(), false);
		cam.bgColor = FlxColor.TRANSPARENT;
		var sub = new PresentSubstate(pointData);
		sub.camera = cam;
		openSubState(sub);

		var barWidth:Int = Std.int(FlxG.width / 2) - 50;

		opponentBar = new FlxBar(27, 25, LEFT_TO_RIGHT, barWidth, 25, opponent, "life");
		opponentBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
		opponentBar.camera = cam;

		var oppBack = new FlxSprite(opponentBar.x - 4,
			opponentBar.y - 4).makeGraphic(Std.int(opponentBar.width + 8), Std.int(opponentBar.height + 8), FlxColor.BLACK);
		oppBack.camera = cam;
		add(oppBack);
		add(opponentBar);

		playerBar = new FlxBar(FlxG.width - barWidth - 23, 25, RIGHT_TO_LEFT, barWidth, 25, player, "life");
		playerBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
		playerBar.camera = cam;

		var playerBack = new FlxSprite(playerBar.x - 4,
			playerBar.y - 4).makeGraphic(Std.int(playerBar.width + 8), Std.int(playerBar.height + 8), FlxColor.BLACK);
		playerBack.camera = cam;
		add(playerBack);
		add(playerBar);
	}

	var playerBar:FlxBar;
	var opponentBar:FlxBar;

	override function destroy()
	{
		// Im tired.
		members.remove(playerBar);
		members.remove(opponentBar);
		super.destroy();
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
