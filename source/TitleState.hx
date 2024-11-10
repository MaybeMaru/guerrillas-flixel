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
	var list = ["Jugar", "Creditos", "Salir"];

	override function create()
	{
		super.create();

		/*var emmiter = new FlxEmitter();
			emmiter.setPosition();
			emmiter.setSize(FlxG.width, FlxG.height);
			emmiter.makeParticles();
			emmiter.start(false);
			add(emmiter); */

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

		FlxG.sound.playMusic("assets/music/sitios-zaragoza.ogg");
		FlxG.sound.music.fadeIn();

		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;

		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
	}

	var curSelection:Int = 0;

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

	override function update(elapsed:Float)
	{
		super.update(elapsed);

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
			switch (curSelection)
			{
				case 0:
					FlxG.switchState(new MapState());
				case 1:
					FlxG.switchState(null); // Credits state
				case 2:
					System.exit(0);
			}
		}
	}
}
