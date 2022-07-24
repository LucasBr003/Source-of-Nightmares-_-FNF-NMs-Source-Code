package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		//'story_mode',
		'freeplay',
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	public var char:FlxSprite;
	public var charID:Int = 0;
	public var charString:String = '';

	var debugKeys:Array<FlxKey>;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;

		magenta.color = 0xFF82012B;
		bg.color = 0xFF50061E;


		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		charID = FlxG.random.int(1, 4);

		for (i in 0...optionShit.length)
		{
			var yOffset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;

			var xOffset = 100;

			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + yOffset);

			menuItem.scale.x = scale;
			menuItem.scale.y = scale;

			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');

			menuItem.ID = i;
			menuItem.screenCenter(X);

			menuItem.x += 200;
			if (charID <= 2)
				menuItem.x -= 400;

			menuItems.add(menuItem);

			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;

			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "FNF Nightmares " + "v0.9.6", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if (CoolUtil.isPTBR())
		{
			var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "(c) Time do IsItLucas?. Todos Direitos Reservados", 12);
			versionShit.scrollFactor.set();
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(versionShit);
		}
		else
		{
			var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "(c) IsItLucas?' Team. All Rights Reserved", 12);
			versionShit.scrollFactor.set();
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(versionShit);
		}
		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		if (MasterDebugMenu.menuCharacter > 0)
		{
			charID = MasterDebugMenu.menuCharacter;
		}
		
		switch (charID) // Random characters
		{
			case 1:
				magenta.color = 0xFF82012B;
				bg.color = 0xFF50061E;

				char = new FlxSprite(600, -100).loadGraphic(Paths.image('mainmenu/characters/Eteled_IC'));
				char.frames = Paths.getSparrowAtlas('mainmenu/characters/Eteled_IC');
				char.animation.addByPrefix('idle', 'Eteled Idle', 24, true);
				char.animation.play('idle');
				char.scrollFactor.set();
				char.flipX = true;
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scale.set(0.65, 0.65);
				add(char);

				charString = 'Eteled';

			case 2:
				magenta.color = 0xFF017382;
				bg.color = 0xFF064750;

				char = new FlxSprite(700, 35).loadGraphic(Paths.image('mainmenu/characters/nightmare-bf'));
				char.frames = Paths.getSparrowAtlas('mainmenu/characters/nightmare-bf');
				char.animation.addByPrefix('idle', 'BF idle dance', 24, true);
				char.animation.play('idle');
				char.scrollFactor.set();
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scale.set(0.7, 0.7);
				add(char);

				charString = 'Nightmare Boyfriend';

			case 3:
				magenta.color = 0xFF018202;
				bg.color = 0xFF064F0D;

				char = new FlxSprite(-75, 125).loadGraphic(Paths.image('mainmenu/characters/nightmare-bambi'));
				char.frames = Paths.getSparrowAtlas('mainmenu/characters/nightmare-bambi');
				char.animation.addByPrefix('idle', 'idle', 24, true);
				char.animation.play('idle');
				char.scrollFactor.set();
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scale.set(0.615, 0.615);
				add(char);

				charString = 'Bambi';

			case 4:
				magenta.color = 0xFF820101;
				bg.color = 0xFF4f0606;
	
				char = new FlxSprite(-130, -15).loadGraphic(Paths.image('mainmenu/characters/tricky_nightmare'));
				char.frames = Paths.getSparrowAtlas('mainmenu/characters/tricky_nightmare');
				char.animation.addByPrefix('idle', 'IdleTricky', 24, true);
				char.animation.play('idle');
				char.scrollFactor.set();
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scale.set(0.55, 0.55);
				add(char);
	
				charString = 'Tricky';
		}

		FlxG.mouse.visible = true; 

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{		
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								FlxG.mouse.visible = false;

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplaySelector());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				MusicBeatState.switchState(new MasterDebugMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});

		if (FlxG.keys.justPressed.F) {
			trace('Mouse X: ' + FlxG.mouse.x);
			trace('Mouse Y: ' + FlxG.mouse.y);
		}

		if (charString == 'Eteled')
			mouseClick(823, 165, 75, 'DeleteNo');

		if (charString == 'Nightmare Boyfriend')
			mouseClick(872, 351, 25, 'Burning in Fear');

		if (charString == 'Bambi')
			mouseClick(632, 145, 50, 'True Spam');

		if (charString == 'Tricky')
			mouseClick(609, 204, 30, 'Magma');
	}

	function mouseClick(x:Int, y:Int, range:Int, songToLoad:String)
	{
		if (FlxG.mouse.pressed) 
		{
			var mx = FlxG.mouse.x;
			var my = FlxG.mouse.y;

			if (mx > x - range && mx < x + range && my > y - range && my < y + range) 
			{
				loadSong(songToLoad);
			}
		}
	}

	function loadSong(songName:String)
	{
		persistentUpdate = false;

		var songLowercase = songName;
		var poop:String = Highscore.formatSong(songLowercase, 0);

		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;

		LoadingState.loadAndSwitchState(new PlayState());
		FlxG.sound.music.volume = 0;

		FlxG.mouse.visible = false;
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
