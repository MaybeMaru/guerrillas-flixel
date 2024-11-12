package;

import MapState.PointData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

// lime test hl
class PlayState extends FlxState
{
	public var player:Player;
	public var opponent:Opponent;

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
				playerName: "Juan Martín Díez",
				playerDescription: '"El Empecinado"\nMilitar español\n1775-1825',
				enemy: "frances1",
				enemyName: "Soldado francés #003",
				enemyDescription: '"Baguette Baguette Cruasán"',
			}
		}

		var cam = FlxG.cameras.add(new FlxCamera(), false);
		cam.bgColor = FlxColor.TRANSPARENT;

		FlxG.camera.bgColor = FlxColor.GRAY;
		FlxG.mouse.visible = false;

		var overlay:FlxGroup = new FlxGroup();

		player = new Player();
		opponent = new Opponent(player);
		player.opponent = opponent;

		scene = new Scene(switch (pointData.year)
		{
			case 1809: 1;
			case 1810: 2;
			default: 0;
		}, overlay);
		add(scene);

		objects = new FlxGroup();
		add(objects);
		add(overlay);

		objects.add(opponent);
		objects.add(player);

		persistentDraw = false;

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

		var nameOpp = new FlxText(opponentBar.x, opponentBar.y, pointData.present.enemyName, 16);
		nameOpp.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 0);
		nameOpp.camera = cam;
		add(nameOpp);

		playerBar = new FlxBar(FlxG.width - barWidth - 23, 25, RIGHT_TO_LEFT, barWidth, 25, player, "life");
		playerBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
		playerBar.camera = cam;

		var playerBack = new FlxSprite(playerBar.x - 4,
			playerBar.y - 4).makeGraphic(Std.int(playerBar.width + 8), Std.int(playerBar.height + 8), FlxColor.BLACK);
		playerBack.camera = cam;
		add(playerBack);
		add(playerBar);

		var namePlayer = new FlxText(playerBar.x, playerBar.y, pointData.present.playerName, 16);
		namePlayer.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 0);
		namePlayer.camera = cam;
		namePlayer.x += playerBar.width - namePlayer.width;
		add(namePlayer);
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
		FlxG.collide(objects, scene.collision);

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
