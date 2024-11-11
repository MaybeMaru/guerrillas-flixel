package;

import MapState.PointData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PresentSubstate extends FlxSubState
{
	var pointData:PointData;

	public function new(pointData:PointData)
	{
		super();
		this.pointData = pointData;
	}

	override function create()
	{
		super.create();

		var bg:FlxSprite;
		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.setGraphicSize(FlxG.width * 4, FlxG.height * 4);
		add(bg);

		var line = new FlxSprite().makeGraphic(6, FlxG.height, FlxColor.RED);
		line.screenCenter(X);
		add(line);

		var present = pointData.present;

		var oppImg = new FlxSprite(0, 25).loadGraphic('assets/images/portraits/${present.enemy}.png');
		oppImg.setGraphicSize(40 * 4, 45 * 4);
		oppImg.updateHitbox();
		oppImg.screenCenter(X);
		oppImg.x -= FlxG.width / 4;
		add(oppImg);

		var oppDesc = new FlxText(25, FlxG.height / 2, FlxG.width / 3, "");
		oppDesc.setFormat("assets/fonts/Ancient Medium.ttf", 30);
		oppDesc.text = present.enemyDescription;
		add(oppDesc);

		var playerImg = new FlxSprite(0, 25).loadGraphic('assets/images/portraits/${present.player}.png');
		playerImg.setGraphicSize(40 * 4, 45 * 4);
		playerImg.updateHitbox();
		playerImg.screenCenter(X);
		playerImg.x += FlxG.width / 4;
		add(playerImg);

		var playerDesc = new FlxText(FlxG.width - 25, FlxG.height / 2, FlxG.width / 3, "");
		playerDesc.setFormat("assets/fonts/Ancient Medium.ttf", 30);
		playerDesc.alignment = RIGHT;
		playerDesc.text = present.playerDescription;
		playerDesc.x -= playerDesc.width;
		add(playerDesc);

		line.scale.x = 0;
		FlxTween.tween(line.scale, {x: 1}, 1, {startDelay: 0.2});

		oppImg.y += FlxG.height;
		playerImg.y += FlxG.height;

		FlxTween.tween(playerImg, {y: playerImg.y - FlxG.height}, 1, {ease: FlxEase.backOut, startDelay: 0.1});
		FlxTween.tween(oppImg, {y: oppImg.y - FlxG.height}, 1, {ease: FlxEase.backOut});

		oppDesc.x -= FlxG.width;
		playerDesc.x += FlxG.width;

		FlxTween.tween(oppDesc, {x: oppDesc.x + FlxG.width}, 1, {startDelay: 0.333, ease: FlxEase.backOut});
		FlxTween.tween(playerDesc, {x: playerDesc.x - FlxG.width}, 1, {startDelay: 0.333, ease: FlxEase.backOut});

		new FlxTimer().start(3, (tmr) ->
		{
			FlxTween.tween(line.scale, {x: 0}, 1);
			FlxTween.tween(oppImg, {y: oppImg.y + FlxG.height}, 1, {ease: FlxEase.backIn});
			FlxTween.tween(playerImg, {y: playerImg.y + FlxG.height}, 1, {ease: FlxEase.backIn});
			FlxTween.tween(oppDesc, {x: oppDesc.x - FlxG.width}, 1, {startDelay: 0.333, ease: FlxEase.backIn});
			FlxTween.tween(playerDesc, {x: playerDesc.x + FlxG.width}, 1, {
				startDelay: 0.333,
				ease: FlxEase.backIn,
				onComplete: (twn) ->
				{
					this._parentState.persistentDraw = true;
					FlxTween.tween(bg, {alpha: 0}, 0.333, {
						onComplete: (twn) ->
						{
							close();
						}
					});
				}
			});
		});
	}
}
