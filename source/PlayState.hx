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
import flixel.util.FlxStringUtil;

// lime test hl
class PlayState extends FlxState
{
	public var player:Player;
	public var opponent:Opponent;

	var objects:FlxGroup;
	var scene:Scene;

	var pause:PauseSubstate;
	var pointData:PointData;
	var levelID:Int;

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
		FlxG.mouse.visible = false;

		var overlay:FlxGroup = new FlxGroup();

		levelID = switch (pointData.year)
		{
			case 1809: 1;
			case 1810: 2;
			default: 0;
		}

		player = new Player(levelID);
		opponent = new Opponent(levelID, player);
		player.opponent = opponent;

		scene = new Scene(levelID, overlay);
		add(scene);

		objects = new FlxGroup();
		add(objects);
		add(overlay);

		objects.add(opponent);
		objects.add(player);

		persistentDraw = false;

		this.destroySubStates = false;

		pause = new PauseSubstate();
		pause.camera = cam;

		@:privateAccess // thanks flixel
		pause._bgSprite.camera = cam;

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

		var back = new FlxSprite(0, 60).makeGraphic(1, 1, FlxColor.BLACK);
		back.scale.set(60, 30);
		back.updateHitbox();
		back.screenCenter(X);
		back.camera = cam;
		back.alpha = 0.8;
		add(back);

		timer = new FlxText(0, 0, 0, "0:00", 16);
		timer.updateHitbox();
		timer.y = (back.y) + (back.height - timer.height) / 2;
		timer.screenCenter(X);
		timer.camera = cam;
		add(timer);

		music = "assets/music/" + (switch (levelID)
		{
			case 1: "jesus";
			case 2: "aurresku";
			default: "seguidillas";
		}) + ".ogg";

		FlxG.sound.cache(music);
	}

	var music:String;

	public function startFight()
	{
		FlxG.sound.playMusic(music);
		FlxG.sound.music.fadeIn();
	}

	var timer:FlxText;

	var playerBar:FlxBar;
	var opponentBar:FlxBar;

	public function win()
	{
		FlxG.switchState(new ResultState(true));
	}

	public function lose()
	{
		FlxG.switchState(new ResultState(false));
	}

	override function destroy()
	{
		// Im tired.
		members.remove(playerBar);
		members.remove(opponentBar);
		super.destroy();
	}

	var elp:Float = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		zoomCamera();
		FlxG.collide(objects, scene.collision);

		elp += elapsed;
		timer.text = FlxStringUtil.formatTime(elp);

		if (FlxG.keys.justPressed.ENTER)
			openSubState(pause);

		// if (FlxG.keys.justPressed.R)
		//	FlxG.resetGame();
	}

	function zoomCamera()
	{
		var dist = player.getMidpoint(FlxPoint.weak()).distanceTo(opponent.getMidpoint(FlxPoint.weak()));

		var minDist = 800;
		var minZoom = 0.35;
		var maxZoom = 0.9;

		var zoom = FlxMath.bound(FlxMath.remapToRange(dist, 0, minDist, maxZoom, minZoom), minZoom, maxZoom);
		FlxG.camera.zoom = Math.max(0.6, zoom);

		var playerOff = (player.x - (FlxG.width - player.width) / 2) / 4;
		var isNeg = playerOff <= 0;

		if (playerOff != 0)
			playerOff = Math.pow(Math.abs(playerOff), 1.25) * (isNeg ? -1 : 1);

		var camX = (FlxG.width / 2) + (playerOff * zoom);
		var camY = (FlxG.height / 2) * zoom;

		FlxG.camera.focusOn(FlxPoint.weak(camX, camY));
	}
}
