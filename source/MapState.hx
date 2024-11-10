package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class MapState extends FlxState
{
	var points:FlxTypedGroup<MapPoint>;

	override function create()
	{
		super.create();
		var map = new FlxSprite(0, 0).loadGraphic("assets/images/spainMap.png");
		map.setGraphicSize(FlxG.width);
		map.updateHitbox();
		map.screenCenter();
		add(map);

		points = new FlxTypedGroup<MapPoint>();
		add(points);

		points.add(new MapPoint(275, 205, {
			name: "Madrid",
			year: 1808,
			player: "El Empecinado"
		}));

		points.add(new MapPoint(265, 115, {
			name: "Burgos",
			year: 1809,
			player: "El Cura Merino"
		}));

		points.add(new MapPoint(365, 95, {
			name: "Navarra",
			year: 1810,
			player: "Espoz y Mina"
		}));

		FlxG.sound.playMusic("assets/music/pepe-botellas.ogg");
		FlxG.sound.music.fadeIn(1, 0, 0.8);

		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!onTrans && FlxG.keys.justPressed.ESCAPE)
		{
			onTrans = true;
			FlxG.mouse.visible = false;
			FlxG.mouse.enabled = false;

			FlxG.sound.music.fadeOut(0.3);
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, () ->
			{
				FlxG.switchState(new TitleState());
			});
		}

		if (onTrans)
			return;

		FlxG.camera.scroll.x = (FlxG.mouse.screenX - (FlxG.width / 2)) / 100;
		FlxG.camera.scroll.y = (FlxG.mouse.screenY - (FlxG.height / 2)) / 100;

		points.members.sort((a, b) ->
		{
			return a.overlap ? 1 : -1;
		});
	}

	var onTrans:Bool = false;

	public function select(point:MapPoint)
	{
		onTrans = true;
		points.active = false;

		var mid = point.point.getMidpoint();
		FlxTween.tween(FlxG.camera.scroll, {x: mid.x - (FlxG.width / 2), y: mid.y - (FlxG.height / 2)}, 1, {ease: FlxEase.quadOut});
		FlxTween.tween(FlxG.camera, {zoom: 20}, 1, {ease: FlxEase.quadIn});
		FlxG.sound.music.fadeOut(0.8);
		FlxG.camera.fade(FlxColor.BLACK, 0.95, () ->
		{
			this.visible = false;
			new FlxTimer().start(0.333, (tmr) ->
			{
				FlxG.switchState(new PlayState());
			});
		});
	}
}

typedef PointData =
{
	name:String,
	year:Int,
	player:String
}

class MapPoint extends FlxGroup
{
	public var point:FlxSprite;

	var box:FlxSprite;
	var txt:FlxText;

	public function new(X:Float, Y:Float, data:PointData)
	{
		super();

		point = new FlxSprite(X, Y).makeGraphic(25, 25, FlxColor.WHITE);
		point.updateHitbox();
		point.x -= point.width / 2;
		point.y -= point.height / 2;
		add(point);

		box = new FlxSprite(X - (75 / 2), Y + point.height + 5).makeGraphic(75, 25);
		add(box);

		txt = new FlxText(box.x, box.y, 0, '${data.name}\n${data.year}');
		txt.color = FlxColor.BLACK;
		add(txt);
	}

	public var overlap:Bool = false;

	var last:Bool = false;
	var lerp:Float = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		overlap = FlxG.mouse.overlaps(point);
		point.color = overlap ? FlxColor.RED : FlxColor.WHITE;
		lerp = FlxMath.lerp(lerp, overlap ? 1 : 0, elapsed * 20);

		box.offset.y = 0;
		txt.alpha = box.alpha = lerp;
		txt.scale.x = box.scale.x = lerp;

		var scl = Math.max(0.5, lerp);
		point.scale.set(scl, scl);

		if (overlap != last)
		{
			last = overlap;
			overlap ? onSelect() : onDeselect();
		}

		if (overlap && FlxG.mouse.justPressed)
		{
			cast(FlxG.state, MapState).select(this);
		}
	}

	function onSelect()
	{
		FlxG.sound.play("assets/sounds/click.ogg");
	}

	function onDeselect()
	{
		FlxG.sound.play("assets/sounds/click.ogg", 0.6).pitch = 0.6;
	}
}
