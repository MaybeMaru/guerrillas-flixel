package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Scene extends FlxTypedGroup<FlxObject>
{
	public function new()
	{
		super();

		var floor = new FlxSprite(0, FlxG.height - 60).makeGraphic((FlxG.width * 4), 60, FlxColor.BLUE);
		floor.screenCenter(X);
		floor.updateHitbox();
		add(floor);

		var wall1 = new FlxSprite(-600, -800).makeGraphic(5, FlxG.height * 4, FlxColor.LIME);
		add(wall1);

		var wall2 = new FlxSprite(FlxG.width + 600, -800, wall1.graphic);
		add(wall2);

		FlxG.debugger.drawDebug = true;
		FlxG.worldBounds.set(-4000, -4000, 8000, 8000);

		for (i in members)
			i.immovable = true;
	}
}
