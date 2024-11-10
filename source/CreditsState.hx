package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CreditsState extends FlxState
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
		txt.setFormat("assets/fonts/Ancient Medium.ttf", 32);
		txt.text = "That pussy got me screamin, cryin, pissin, shittin, shoothin ropes";
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
