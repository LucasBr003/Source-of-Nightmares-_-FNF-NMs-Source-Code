 package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;

	public static var controllerMode:Bool = false;

	////////// MOD SAVE VARIABLES //////////

	public static var files:Bool = true;
	public static var scary:Bool = true;
	public static var windowMechs:Bool = true;
	public static var animIcons:Bool = true;
	public static var jumpscareVolume:Float = 1;
	public static var rgbIntensity:Float = 1;
	public static var shakeIntensity:Float = 1;
	public static var laneTransparency:Float = 0;
	public static var skinSelector:Bool = true;
	public static var baby:Bool = false;
	public static var ptbr:Bool = false;

	public static var showScore:Bool = true;
	public static var showMisses:Bool = true;
	public static var showAcc:Bool = true;
	public static var showHealth:Bool = true;
	public static var showJudgements:Bool = true;

	public static var dodges:Int = 0;
	public static var axes:Int = 0;
	public static var halos:Int = 0;
	public static var corns:Int = 0;

	public static var buildType = 'normal';

	///////////////////////////////////////

	public static var hitsoundVolume:Float = 0;

	public static var pauseMusic:String = 'Tea Time';
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState

		'note_left'	=>	 [A, LEFT],
		'note_down'	=>	 [S, DOWN],
		'note_up'	=> 	[W, UP],
		'note_right'	=>	 [D, RIGHT],
		
		'ui_left'	=>	 [A, LEFT],
		'ui_down'	=>	 [S, DOWN],
		'ui_up'		=>	 [W, UP],
		'ui_right'	=> 	[D, RIGHT],
		
		'accept'	=> 	[SPACE, ENTER],
		'back'		=> 	[BACKSPACE, ESCAPE],
		'pause'		=> 	[ENTER, ESCAPE],
		'reset'		=> 	[R, NONE],

		'dodge'		=> 	[SPACE],
		'erase'		=>	[DELETE],
		
		'volume_mute'	=> 	[ZERO, NONE],
		'volume_up'	=> 	[NUMPADPLUS, PLUS],
		'volume_down'	=> 	[NUMPADMINUS, MINUS],
		
		'debug_1'	=> 	[SEVEN, NONE],
		'debug_2'	=> 	[EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;

		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;

		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;

		//////// MOD SAVE STUFF ////////

		FlxG.save.data.files = files;
		FlxG.save.data.scary = scary;
		FlxG.save.data.windowMechs = windowMechs;
		FlxG.save.data.animIcons = animIcons;
		FlxG.save.data.shakeIntensity = shakeIntensity;
		FlxG.save.data.rgbIntensity = rgbIntensity;
		FlxG.save.data.laneTransparency = laneTransparency;
		FlxG.save.data.skinSelector = skinSelector;
		FlxG.save.data.baby = baby;
		FlxG.save.data.ptbr = ptbr;

		FlxG.save.data.showScore = showScore;
		FlxG.save.data.showMisses = showMisses;
		FlxG.save.data.showAcc = showAcc;
		FlxG.save.data.showHealth = showHealth;
		FlxG.save.data.showJudgements = showJudgements;

		FlxG.save.data.dodges = Achievements.dodges;
		FlxG.save.data.halos = Achievements.halos;
		FlxG.save.data.axes = Achievements.axes;
		FlxG.save.data.corns = Achievements.corns;

		FlxG.save.data.buildType = buildType;
	
		FlxG.save.flush();

		//////////////////////////////////

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff

		if (save.data.customControls != null)
			keyBinds = save.data.customControls;
		else
			save.data.customControls = keyBinds;

		save.flush();
		FlxG.log.add("Settings saved!");
		trace(save.data.customControls);

		//////////////////////////////////
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) downScroll = FlxG.save.data.downScroll;
		if(FlxG.save.data.middleScroll != null) middleScroll = FlxG.save.data.middleScroll;

		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}

		if(FlxG.save.data.flashing != null) flashing = FlxG.save.data.flashing;
		if(FlxG.save.data.globalAntialiasing != null) globalAntialiasing = FlxG.save.data.globalAntialiasing;
		if(FlxG.save.data.noteSplashes != null) noteSplashes = FlxG.save.data.noteSplashes;
		if(FlxG.save.data.lowQuality != null) lowQuality = FlxG.save.data.lowQuality;

		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		if(FlxG.save.data.camZooms != null) camZooms = FlxG.save.data.camZooms;
		if(FlxG.save.data.hideHud != null) hideHud = FlxG.save.data.hideHud;
		if(FlxG.save.data.noteOffset != null) noteOffset = FlxG.save.data.noteOffset;
		if(FlxG.save.data.arrowHSV != null) arrowHSV = FlxG.save.data.arrowHSV;
		if(FlxG.save.data.ghostTapping != null) ghostTapping = FlxG.save.data.ghostTapping;
		if(FlxG.save.data.timeBarType != null) timeBarType = FlxG.save.data.timeBarType;
		if(FlxG.save.data.scoreZoom != null) scoreZoom = FlxG.save.data.scoreZoom;
		if(FlxG.save.data.noReset != null) noReset = FlxG.save.data.noReset;
		if(FlxG.save.data.healthBarAlpha != null) healthBarAlpha = FlxG.save.data.healthBarAlpha;
		if(FlxG.save.data.comboOffset != null) comboOffset = FlxG.save.data.comboOffset;
		
		if(FlxG.save.data.ratingOffset != null) ratingOffset = FlxG.save.data.ratingOffset;
		if(FlxG.save.data.sickWindow != null) sickWindow = FlxG.save.data.sickWindow;
		if(FlxG.save.data.goodWindow != null) goodWindow = FlxG.save.data.goodWindow;
		if(FlxG.save.data.badWindow != null) badWindow = FlxG.save.data.badWindow;
		if(FlxG.save.data.safeFrames != null) safeFrames = FlxG.save.data.safeFrames;
		if(FlxG.save.data.controllerMode != null) controllerMode = FlxG.save.data.controllerMode;
		if(FlxG.save.data.hitsoundVolume != null) hitsoundVolume = FlxG.save.data.hitsoundVolume;
		if(FlxG.save.data.pauseMusic != null) pauseMusic = FlxG.save.data.pauseMusic;

		////////// MORE MOD SAVE STUFF //////////

		if(FlxG.save.data.files != null) files = FlxG.save.data.files;
		if(FlxG.save.data.scary != null) scary = FlxG.save.data.scary;
		if(FlxG.save.data.windowMechs != null) windowMechs = FlxG.save.data.windowMechs;
		if(FlxG.save.data.animIcons != null) animIcons = FlxG.save.data.animIcons;
		if(FlxG.save.data.laneTransparency != null) laneTransparency = FlxG.save.data.laneTransparency;
		if(FlxG.save.data.skinSelector != null) skinSelector = FlxG.save.data.skinSelector;
		if(FlxG.save.data.baby != null) baby = FlxG.save.data.baby;
		if(FlxG.save.data.ptbr != null) ptbr = FlxG.save.data.ptbr;

		if(FlxG.save.data.rgbIntensity != null) rgbIntensity = FlxG.save.data.rgbIntensity;
		if(FlxG.save.data.shakeIntensity != null) shakeIntensity = FlxG.save.data.shakeIntensity;

		if(FlxG.save.data.corns != null) corns = FlxG.save.data.corns;
		if(FlxG.save.data.halos != null) halos = FlxG.save.data.halos;
		if(FlxG.save.data.dodges != null) dodges = FlxG.save.data.dodges;
		if(FlxG.save.data.axes != null) axes = FlxG.save.data.axes;

		if(FlxG.save.data.showScore != null) showScore = FlxG.save.data.showScore;
		if(FlxG.save.data.showMisses != null) showMisses = FlxG.save.data.showMisses;
		if(FlxG.save.data.showAcc != null) showAcc = FlxG.save.data.showAcc;
		if(FlxG.save.data.showHealth != null) showHealth = FlxG.save.data.showHealth;
		if(FlxG.save.data.showJudgements != null) showJudgements = FlxG.save.data.showJudgements;

		if(FlxG.save.data.buildType != null) buildType = FlxG.save.data.buildType;

		/////////////////////////////////////////////

		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
