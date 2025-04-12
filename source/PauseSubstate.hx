package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PauseSubstate extends FlxSubState
{
	var items:Array<FlxText> = [];
	var list = ["Resumir", "Salir"];

	var music:FlxSound;
	var franco:FlxSound;

	public function new()
	{
		super(0x6d000000);

		music = FlxG.sound.load('assets/music/espana.ogg'); // no puedo ponerlo como yo quiero :(
		franco = FlxG.sound.load('assets/music/franco.ogg');

		music.looped = true;
		franco.looped = true;

		var txt = new FlxText(0, 85, 0, "Pausa", 64);
		txt.textField.antiAliasType = ADVANCED;
		txt.setFormat("assets/fonts/Ancient Medium.ttf", 64, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
		txt.borderSize = 6;
		txt.borderQuality = 0;
		txt.scale.scale(1.6, 1.6);
		txt.updateHitbox();
		txt.screenCenter(X);
		add(txt);

		for (i => name in list)
		{
			var txt = new FlxText(0, 250 + (i * 50), 0, name, 24);
			txt.setFormat(null, 24, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
			txt.borderSize = 3;
			txt.borderQuality = 0;
			txt.screenCenter(X);
			add(txt);

			items.push(txt);
		}

		changeSelection(0);

		var soundPause:Array<FlxSound> = [];
		var soundTmr:FlxTimer;

		this.openCallback = () ->
		{
			selected = false;
			FlxG.sound.music.pause();
			setGlobalManager(false);

			soundPause.resize(0);
			for (sound in FlxG.sound.list)
			{
				if (sound.playing)
				{
					soundPause.push(sound);
					sound.pause();
				}
			}

			soundTmr = new FlxTimer().start(FlxG.random.float(3, 5), (tmr) ->
			{
				music.play(true, 0.0);
				music.fadeIn(6);

				if (FlxG.random.bool(1)) // 1 / 100 easter egg
				{
					franco.play(true, 0.0);
					franco.fadeIn(10);
				}
			});

			curSelection = 0;
			changeSelection(0);
		}

		this.closeCallback = () ->
		{
			soundTmr.cancel();

			music.stop();
			franco.stop();

			FlxG.sound.music.resume();
			setGlobalManager(true);

			for (sound in soundPause)
				sound.resume();
		}
	}

	function setGlobalManager(active:Bool = true) @:privateAccess
	{
		for (timer in FlxTimer.globalManager._timers)
		{
			if (!timer.finished)
				timer.active = active;
		}

		for (tween in FlxTween.globalManager._tweens)
		{
			if (!tween.finished)
				tween.active = active;
		}
	}

	static var curSelection:Int = 0;

	function changeSelection(change:Int)
	{
		curSelection = FlxMath.wrap(curSelection + change, 0, items.length - 1);
		for (i => txt in items)
		{
			txt.color = (i == curSelection) ? FlxColor.YELLOW : FlxColor.WHITE;
			txt.text = (i == curSelection) ? '>${list[i]}<' : list[i];
			txt.screenCenter(X);
		}
	}

	var selected:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (selected)
			return;

		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);

		if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
		{
			selected = true;
			switch (curSelection)
			{
				case 0:
					close();
				case 1:
					camera.fade(FlxColor.BLACK, 0.3, false, () ->
					{
						FlxG.switchState(new MapState());
					});

					for (i in [music, franco])
						i.fadeOut(0.3, 0);
			}
		}
	}
}
