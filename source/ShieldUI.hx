package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class ShieldUI extends FlxSprite
{
	public function new(x:Float, y:Float, person:Person)
	{
		super(x, y);

		loadGraphic('assets/images/shieldui.png', true, 20, 24);
		this.person = person;

		animation.add('filled', [0]);
		animation.add('empty', [1]);

		setFilled(true);

		scale.set(2, 2);
		updateHitbox();
	}

	var lastFilled:Bool = true;

	public function setFilled(isFilled:Bool)
	{
		animation.play(isFilled ? 'filled' : 'empty');

		if (isFilled != lastFilled)
		{
			if (!isFilled)
			{
				FlxTween.shake(this, 0.1, 0.1);
			}
			lastFilled = isFilled;
		}
	}

	var person:Person;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setFilled(ID < person.leftShieldHits);
	}
}
