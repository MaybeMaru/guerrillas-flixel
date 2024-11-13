package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ControlsState extends FlxState
{
	override function create()
	{
		super.create();

		var war = new FlxBackdrop("assets/images/war.png", X);
		war.x += FlxG.width / 1.5;
		var scale = FlxG.height / war.frameHeight;
		war.scale.set(scale, scale);
		war.updateHitbox();
		war.velocity.x = -5;
		add(war);

		war.scale.scale(3, 3);
		war.color = FlxColor.GRAY;

		var txt = new FlxText(25, 25, FlxG.width - 50);
		txt.text = "CONTROLES:\n\nMovimiento: Flechas Direccionales\nSalto: Flecha de Arriba\nAtaque: Z\nEscudo: X";

		txt.setFormat("assets/fonts/Ancient Medium.ttf", 32, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
		txt.borderSize = 3;
		txt.borderQuality = 0;

		add(txt);

		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
	}

	var escaped:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (escaped)
			return;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			escaped = true;
			FlxG.camera.fade(FlxColor.BLACK, 0.333, false, () ->
			{
				FlxG.switchState(new TitleState());
			});
		}
	}
}
