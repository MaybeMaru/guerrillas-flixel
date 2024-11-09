package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
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
		var map = new FlxSprite().loadGraphic("assets/images/spainMap.png");
		map.color = 0xff5e5e5e;
		map.setGraphicSize(FlxG.width, FlxG.height);
		map.updateHitbox();
		add(map);

		points = new FlxTypedGroup<MapPoint>();
		add(points);

		points.add(new MapPoint(260, 200, {
			name: "Madrid"
		}));

		points.add(new MapPoint(255, 115, {
			name: "Burgos"
		}));

		points.add(new MapPoint(365, 85, {
			name: "Pirienos"
		}));

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

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
	name:String
}

class MapPoint extends FlxGroup
{
	public var point:FlxSprite;

	public function new(X:Float, Y:Float, data:PointData)
	{
		super();

		point = new FlxSprite(X, Y).makeGraphic(25, 25, FlxColor.WHITE);
		point.updateHitbox();
		point.x -= point.width / 2;
		point.y -= point.height / 2;
		add(point);
	}

	public var overlap:Bool = false;

	var last:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		overlap = FlxG.mouse.overlaps(point);
		point.color = overlap ? FlxColor.RED : FlxColor.WHITE;

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
