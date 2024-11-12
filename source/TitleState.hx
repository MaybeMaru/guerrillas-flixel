package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.system.System;

class TitleState extends FlxState
{
	var items:Array<FlxText> = [];
	var list = ["Jugar", "Controles", "Salir"];

	public static var wentBack:Bool = true;

	override function create()
	{
		super.create();

		var war = new FlxBackdrop("assets/images/war.png", X);
		war.x += FlxG.width / 1.5;
		var scale = FlxG.height / war.frameHeight;
		war.scale.set(scale, scale);
		war.updateHitbox();
		war.velocity.x = -10;
		add(war);

		war.scale.scale(2, 2);

		var txt = new FlxText(0, 85, 0, "Guerrillas", 64);
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
			var txt = new FlxText(0, 300 + (i * 30), 0, name, 24);
			txt.setFormat(null, 24, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
			txt.borderSize = 3;
			txt.borderQuality = 0;
			txt.screenCenter(X);
			add(txt);

			items.push(txt);
		}

		changeSelection(0);

		if (wentBack)
		{
			FlxG.sound.playMusic("assets/music/sitios-zaragoza.ogg");
			FlxG.sound.music.fadeIn();
			wentBack = false;
		}

		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;

		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
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

	var clicked:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (clicked)
			return;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
			return;
		}

		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);

		if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
		{
			clicked = true;

			if (curSelection == 0)
				FlxG.sound.music.fadeOut(0.333);

			FlxG.camera.fade(FlxColor.BLACK, 0.333, false, () ->
			{
				switch (curSelection)
				{
					case 0:
						FlxG.switchState(new MapState());
					case 1:
						FlxG.switchState(new ControlsState());
					case 2:
						System.exit(0);
				}
			});
		}
	}
}
