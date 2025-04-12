package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ResultState extends FlxState
{
	var isWin:Bool;
	var score:Int;

	public function new(isWin:Bool, score:Int)
	{
		super();
		this.isWin = isWin;
		this.score = score;
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

	function openUp()
	{
		if (isWin)
		{
			FlxG.sound.play("assets/sounds/win.ogg");

			var path = "assets/images/spain.png";
			if (FlxG.random.bool(1)) // hehehe
				path = "assets/images/republica.png";

			var spain = new FlxBackdrop(path);
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

			var scoreTxt = new ResultScore();
			scoreTxt.y = 350;
			scoreTxt.lerpToScore(score);
			add(scoreTxt);

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

class ResultScore extends FlxText
{
	public function new()
	{
		super(0, 0, 0, "", 24);

		setFormat(null, 24, FlxColor.WHITE, null, SHADOW, FlxColor.BLACK);
		borderSize = 3;
		borderQuality = 0;
	}

	var _score:Float = 0;

	public function lerpToScore(score:Float)
	{
		FlxTween.tween(this, {_score: score}, 2, {
			startDelay: 1,
			ease: FlxEase.sineIn
		});
	}

	var lastScore:Int = 0;
	var pitch:Float = 0.5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var roundScore = Math.round(_score);

		if (roundScore <= 0)
			return;

		if (roundScore > lastScore)
		{
			FlxG.sound.play('assets/sounds/scoreClick.ogg').pitch = pitch;
			pitch += 0.02 / pitch;
			lastScore = roundScore;
		}

		this.text = 'Puntos: ' + roundScore;

		updateHitbox();
		screenCenter(X);
	}
}
