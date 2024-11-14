package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ResultState extends FlxState
{
	public function new(isWin:Bool)
	{
		super();
		this.isWin = isWin;
	}

	override function create()
	{
		super.create();

		FlxG.sound.music.stop();
		FlxG.camera.flash();

		FlxG.sound.play("assets/sounds/explosion.ogg").onComplete = () ->
		{
			new FlxTimer().start(2, (tmr) ->
			{
				openUp();
			});
		};
	}

	var isWin:Bool;

	function openUp()
	{
		if (isWin)
		{
			FlxG.sound.play("assets/sounds/win.ogg");

			var spain = new FlxBackdrop("assets/images/spain.png");
			spain.scale.set(3, 3);
			spain.updateHitbox();
			spain.velocity.set(25, -25);
			spain.color = FlxColor.GRAY;
			add(spain);

			var txt = new FlxText();
			txt.text = "Guerrilla\nVictoriosa!!";
			txt.setFormat("assets/fonts/Ancient Medium.ttf", 64, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
			txt.alignment = CENTER;
			txt.borderSize = 6;
			txt.borderQuality = 0;
			add(txt);

			txt.updateHitbox();
			txt.screenCenter();
		}
		else
		{
			FlxG.sound.play("assets/sounds/wompwomp.ogg");

			var france = new FlxBackdrop("assets/images/france.png");
			france.scale.set(3, 3);
			france.updateHitbox();
			france.velocity.set(15, 15);
			france.color = FlxColor.GRAY;
			add(france);

			var txt = new FlxText();
			txt.text = "Guerrilla\nPerdida...";
			txt.setFormat("assets/fonts/Ancient Medium.ttf", 64, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
			txt.alignment = CENTER;
			txt.borderSize = 6;
			txt.borderQuality = 0;
			add(txt);

			txt.updateHitbox();
			txt.screenCenter();
		}

		FlxG.camera.fade(FlxColor.BLACK, 0.333, true);

		new FlxTimer().start(8, (tmr) ->
		{
			FlxG.sound.music.fadeOut();
			FlxG.camera.fade(FlxColor.BLACK, false, () ->
			{
				FlxG.switchState(new MapState());
			});
		});
	}
}
