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
		TitleState.wentBack = true;
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
			present: {
				player: "juan",
				playerDescription: 'Juan Martín Díez\n\n"El Empecinado"\nMilitar español\n1775-1825',
				enemy: "frances1",
				enemyDescription: 'Soldado francés #003\n\n"Baguette Baguette Cruasán"',
			}
		}));

		points.add(new MapPoint(265, 115, {
			name: "Burgos",
			year: 1809,
			present: {
				player: "jeronimo",
				playerDescription: 'Jerónimo Merino\n\n"El Cura Merino"\nSacerdote\n1769-1844',
				enemy: "frances2",
				enemyDescription: 'Soldado francés #069\n\n"Donemuah Torre Eiffel"',
			}
		}));

		points.add(new MapPoint(365, 95, {
			name: "Navarra",
			year: 1810,
			present: {
				player: "espoz",
				playerDescription: 'Francisco Espoz Illundáin\n\n"Espoz y Mina"\nMilitar español\n1781-1836',
				enemy: "frances3",
				enemyDescription: 'Soldado francés #007\n\n"Mon plus grand cauchemar, une brosse à dents."',
			}
		}));

		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
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
				this.visible = false;
				new FlxTimer().start(0.333, (tmr) ->
				{
					FlxG.switchState(new TitleState());
				});
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
				FlxG.switchState(new PlayState(point.data));
			});
		});
	}
}

typedef PointData =
{
	name:String,
	year:Int,
	present:PresentData
}

typedef PresentData =
{
	player:String,
	enemy:String,
	playerDescription:String,
	enemyDescription:String
}

class MapPoint extends FlxGroup
{
	public var point:FlxSprite;
	public var data:PointData;

	var box:FlxSprite;
	var txt:FlxText;

	public function new(X:Float, Y:Float, data:PointData)
	{
		super();

		this.data = data;

		point = new FlxSprite(X, Y);
		point.loadGraphic("assets/images/point.png", true, 8, 8);
		point.updateHitbox();

		add(point);

		point.animation.add("unselected", [0]);
		point.animation.add("selected", [1]);

		point.scale.set(3, 3);
		point.updateHitbox();

		point.x -= point.width / 2;
		point.y -= point.height / 2;

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
		point.animation.play(overlap ? "selected" : "unselected");
		lerp = FlxMath.lerp(lerp, overlap ? 1 : 0, elapsed * 20);

		box.offset.y = 0;
		txt.alpha = box.alpha = lerp;
		txt.scale.x = box.scale.x = lerp;

		var scl = Math.max(0.5 * 3, lerp * 3);
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
