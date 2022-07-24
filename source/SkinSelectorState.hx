package;

#if desktop
import Discord.DiscordClient;
#end
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import Character;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import lime.system.Clipboard;
import flixel.animation.FlxAnimation;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;

#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class SkinSelectorState extends MusicBeatState
{
	// Sprites Variables (Stupid)
	public var ic:FlxSprite;
	public var b3:FlxSprite;
	public var bsides:FlxSprite;
	public var dsides:FlxSprite;
	public var female:FlxSprite;
	public var ghost:FlxSprite;
	public var mc:FlxSprite;
	public var minusBlue:FlxSprite;
	public var minusRed:FlxSprite;
	public var minusGreen:FlxSprite;
	public var neon:FlxSprite;
	public var sneeple:FlxSprite;
	public var soft:FlxSprite;
	public var sunk:FlxSprite;
	public var zombie:FlxSprite;

	public var bfsGroup = new FlxTypedGroup<FlxSprite>();

	// Lists and other Variables
	public var skinsName:Array<String> = [
		'Indie Cross BF',
		'Nightmare B3 BF',
		'Nightmare B-Sides BF',
		'Nightmare D-Sides BF',
		'Nightmare Female BF',
		'Nightmare Ghost BF',
		'Nightmare MCBF',
		'Nightmare Minus BF (Blue)',
		'Nightmare Minus BF (Red)',
		'Nightmare Minus BF (Green)',
		'Nightmare Neon BF',
		'Nightmare Sneeple BF',
		'Nightmare Soft BF',
		'Nightmare Sunk BF',
		'Nightmare Zombie BF'
	];
	public var skins:Array<String> = [
		'ic',
		'b3',
		'bsides',
		'dsides',
		'female',
		'ghost',
		'mc',
		'minusBlue',
		'minusRed',
		'minusGreen',
		'neon',
		'sneeple',
		'soft',
		'sunk',
		'zombie'
	];
	public var charJson:Array<String> = [
		'ic',
		'skin-b3-bf',
		'skin-bsides-bf',
		'skin-dsides-bf',
		'skin-female-bf',
		'skin-ghost-bf',
		'skin-mc-bf',
		'skin-minus-blue-bf',
		'skin-minus-red-bf',
		'skin-minus-green-bf',
		'skin-neon-bf',
		'skin-sneeple-bf',
		'skin-soft-bf',
		'skin-sunk-bf',
		'skin-zombie-bf'
	];
	public var colors:Array<String> = [
		'50A5EB',
		'FFEF00',
		'FFBBFF',
		'554298',
		'65FDFD',
		'138DE8',
		'FA2A2A',
		'65FEFE',
		'B80C00',
		'A4B332',
		'78FA5E',
		'8C00FF',
		'33CCCC',
		'FF2D32',
		'78D158'
	];

	public var curSkin:Int = 0;
	public var totalSkins:Int = 14;

	// Offsets
	public var offsetX:Array<Int> = [429,272,240,201,359,264,306,203,348,362,322,297,188,287,283];
	public var offsetY:Array<Int> = [241,-54,-113,-104,48,-58,-37,-110,53,39,1,-7,-75,-31,-42];

	// Cameras
	public var camBack:FlxCamera;
	public var camMiddle:FlxCamera;
	public var camFront:FlxCamera;
	public var camTrans:FlxCamera;

	public var lerpCamX:Float = 0.0;
	public var camX:Float = 0;

	// BG
	public var bg:FlxSprite;
	public var bgBright:FlxSprite;
	public var colorTween:FlxTween;
	public var colorTweenBright:FlxTween;

	public var coolthingTop:FlxSprite;
	public var coolthingBottom:FlxSprite;

	// Text
	public var titleText:FlxText;
	public var skinNameText:FlxText;
	public var instructionsText:FlxText;

	override function create()
	{
		// Cameras
		camBack = new FlxCamera();
		camMiddle = new FlxCamera();
		camFront = new FlxCamera();
		camTrans = new FlxCamera();

		camBack.bgColor.alpha = 0;
		camMiddle.bgColor.alpha = 0;
		camFront.bgColor.alpha = 0;
		camTrans.bgColor.alpha = 0;

		FlxG.cameras.reset(camBack);
		FlxG.cameras.add(camMiddle);
		FlxG.cameras.add(camFront);
		FlxG.cameras.add(camTrans);

		FlxCamera.defaultCameras = [camBack];
		CustomFadeTransition.nextCamera = camTrans;

		// Music
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.3);
		trace(Paths.inst(PlayState.SONG.song));

		// Nice BG
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		bgBright = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bgBright.screenCenter();
		bgBright.antialiasing = ClientPrefs.globalAntialiasing;
		bgBright.visible = false;
		add(bgBright);

		// Cool BG Detail
		coolthingTop = new FlxSprite().loadGraphic(Paths.image('freeplay/coolThing'));
		coolthingTop.antialiasing = ClientPrefs.globalAntialiasing;
		coolthingTop.flipY = true;
		coolthingTop.cameras = [camFront];
		add(coolthingTop);

		coolthingBottom = new FlxSprite(0, 600).loadGraphic(Paths.image('freeplay/coolThing'));
		coolthingBottom.antialiasing = ClientPrefs.globalAntialiasing;
		coolthingBottom.cameras = [camFront];
		add(coolthingBottom);

		// Title Text
		titleText = new FlxText(0, 0, 0, 'SKIN SELECTOR', 60);
		titleText.borderSize = 1;
		titleText.font = Paths.font("cafe.ttf");
		titleText.cameras = [camFront];
		titleText.screenCenter(X);
		add(titleText);

		if (CoolUtil.isPTBR())
		{
			titleText.text = 'SELETOR DE SKINS';
		}

		// Skin Name Text
		skinNameText = new FlxText(0, titleText.y + 80, 0, 'Indie Cross BF', 30);
		skinNameText.borderSize = 1;
		skinNameText.alignment = CENTER;
		skinNameText.font = Paths.font("vcr.ttf");
		skinNameText.cameras = [camFront];
		skinNameText.screenCenter(X);
		add(skinNameText);

		// Instructions Text Text
		instructionsText = new FlxText(15, coolthingBottom.y + 15, 0, '', 24);
		instructionsText.borderSize = 1;
		instructionsText.alignment = LEFT;
		instructionsText.font = Paths.font("vcr.ttf");
		instructionsText.cameras = [camFront];

		instructionsText.text += 'Song: ' + PlayState.SONG.song + ' (Mechanics: ';

		if (PlayState.mechDifficulty == 0)
			instructionsText.text += 'OFF)';
		if (PlayState.mechDifficulty == 1)
			instructionsText.text += 'EASIER)';
		if (PlayState.mechDifficulty == 2)
			instructionsText.text += 'STANDARD)';
		if (PlayState.mechDifficulty == 3)
			instructionsText.text += 'NIGHTMARE)';

		instructionsText.text += '\n\nLEFT / RIGHT Arrow Keys - Change Between Skins';
		instructionsText.text += '\nACCEPT - Select Skin and Start';
		instructionsText.text += '\nCANCEL - Go Back to Freeplay';

		if (CoolUtil.isPTBR())
		{
			instructionsText.text = 'Música: ' + PlayState.SONG.song + ' (Mecânicas: ';

			if (PlayState.mechDifficulty == 0)
				instructionsText.text += 'DESLIGADAS)';
			if (PlayState.mechDifficulty == 1)
				instructionsText.text += 'FÁCIL)';
			if (PlayState.mechDifficulty == 2)
				instructionsText.text += 'PADRÃO)';
			if (PlayState.mechDifficulty == 3)
				instructionsText.text += 'PESADELO)';

			instructionsText.text += '\n\nSetas ESQUERDA / DIREITA - Mudar de Skin';
			instructionsText.text += '\nCONFIRMAR - Selecionar Skin e Começar';
			instructionsText.text += '\nCANCELAR - Voltar Para o Freeplay';
		}

		add(instructionsText);

		// This is just stupid lmao
		for (i in 0...skins.length)
		{	
			var path = 'characters/boyfriendSkins/' + skins[i] + '_bf-nm';
			if (i == 0) {
				ic = new FlxSprite().loadGraphic(Paths.image(path));
				ic.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(ic);
			}
			if (i == 1) {
				b3 = new FlxSprite().loadGraphic(Paths.image(path));
				b3.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(b3);
			}
			if (i == 2) {
				bsides = new FlxSprite().loadGraphic(Paths.image(path));
				bsides.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(bsides);
			}
			if (i == 3) {
				dsides = new FlxSprite().loadGraphic(Paths.image(path));
				dsides.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(dsides);
			}
			if (i == 4) {
				female = new FlxSprite().loadGraphic(Paths.image(path));
				female.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(female);
			}
			if (i == 5) {
				ghost = new FlxSprite().loadGraphic(Paths.image(path));
				ghost.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(ghost);
			}
			if (i == 6) {
				mc = new FlxSprite().loadGraphic(Paths.image(path));
				mc.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(mc);
			}
			if (i == 7) {
				minusBlue = new FlxSprite().loadGraphic(Paths.image(path));
				minusBlue.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(minusBlue);
			}
			if (i == 8) {
				minusRed = new FlxSprite().loadGraphic(Paths.image(path));
				minusRed.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(minusRed);
			}
			if (i == 9) {
				minusGreen = new FlxSprite().loadGraphic(Paths.image(path));
				minusGreen.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(minusGreen);
			}
			if (i == 10) {
				neon = new FlxSprite().loadGraphic(Paths.image(path));
				neon.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(neon);
			}
			if (i == 11) {
				sneeple = new FlxSprite().loadGraphic(Paths.image(path));
				sneeple.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(sneeple);
			}
			if (i == 12) {
				soft = new FlxSprite().loadGraphic(Paths.image(path));
				soft.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(soft);
			}
			if (i == 13) {
				sunk = new FlxSprite().loadGraphic(Paths.image(path));
				sunk.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(sunk);
			}
			if (i == 14) {
				zombie = new FlxSprite().loadGraphic(Paths.image(path));
				zombie.frames = Paths.getSparrowAtlas(path);
				bfsGroup.add(zombie);
			}
		}

		// Resizing all bfs in one line of code
		camMiddle.zoom = 0.65;

		// BF Group settings
		bfsGroup.forEach(function(i:FlxSprite) 
		{
			i.cameras = [camMiddle];
			i.flipX = true;
			i.antialiasing = true;
			i.x = offsetX[curSkin];
			i.y = offsetY[curSkin];
			i.antialiasing = ClientPrefs.globalAntialiasing;
			i.animation.addByPrefix('idle', 'BF idle dance', 24, true);
			i.animation.play('idle');
		});

		// Adding it
		add(bfsGroup);

		// Update Fix
		updateSelector();
	}

	public var leftState:Bool = false;
	override function update(elapsed:Float)
	{
		// Change between Skins
		var left = FlxG.keys.justPressed.LEFT;
		var right = FlxG.keys.justPressed.RIGHT;

		// Moving
		if (!leftState)
		{
			if (right)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

				curSkin += 1;
				if (curSkin > totalSkins)
				{
					curSkin = 0;
				}

				updateSelector();
			}
			if (left)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

				curSkin -= 1;
				if (curSkin < 0)
				{
					curSkin = totalSkins;
				}

				updateSelector();
			}
		}

		// BFS Stuff
		for (i in 0...bfsGroup.members.length)
		{
			// Offset
			bfsGroup.members[i].x = offsetX[i] + (750 * i);
			bfsGroup.members[i].y = offsetY[i];

			// Alpha
			if (Math.abs(i - curSkin) == 0)
				bfsGroup.members[i].alpha = 1;
			if (Math.abs(i - curSkin) == 1)
				bfsGroup.members[i].alpha = 0.15;
			if (Math.abs(i - curSkin) >= 2)
				bfsGroup.members[i].alpha = 0;
		}

		// Camera
		lerpCamX = Math.floor(FlxMath.lerp(lerpCamX, camX, CoolUtil.boundTo(elapsed * 18, 0, 1)));
		camMiddle.x = lerpCamX;

		camX = ((488 * (curSkin)) * -1) - 1515;
		camMiddle.width = 9999;

		// Continue and Go back
		if (!leftState)
		{
			if (controls.ACCEPT)
			{
				// Stop any other actions
				leftState = true;

				// Changing BF Skin
				PlayState.bfSkin = charJson[curSkin];
				trace(charJson[curSkin]);

				// Music Stop
				FlxG.sound.music.stop();

				// Sound
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				// Wait, then load PlayState
				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});

				// Flicker Effect
				bgBright.visible = true;
				if (ClientPrefs.flashing) FlxFlicker.flicker(bgBright, 1.3, 0.1, false);

				// Fading everything
				for (i in 0...bfsGroup.members.length)
				{
					if (i != curSkin)
					{
						bfsGroup.members[i].visible = false;
					}
				}

				coolthingBottom.visible = false;
				instructionsText.visible = false;
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
				leftState = true;
				LoadingState.loadAndSwitchState(new FreeplayState());
			}
		}

		super.update(elapsed);
	}

	function updateSelector()
	{
		// Skin Name Update
		skinNameText.text = '< ' + skinsName[curSkin] + ' >';
		skinNameText.screenCenter(X);

		// Color Update
		if(colorTween != null) {
			colorTween.cancel();
		}
		colorTween = FlxTween.color(bg, 0.5, bg.color, Std.parseInt('0x26' + colors[curSkin]), {
			onComplete: function(twn:FlxTween) {
				colorTween = null;
			}
		});

		// Color Update (BRIGHT)
		if(colorTweenBright != null) {
			colorTweenBright.cancel();
		}
		colorTweenBright = FlxTween.color(bgBright, 0.5, bgBright.color, Std.parseInt('0x59' + colors[curSkin]), {
			onComplete: function(twn:FlxTween) {
				colorTweenBright = null;
			}
		});
	}
}