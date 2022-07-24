package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import flixel.FlxCamera;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import openfl.filters.BitmapFilter;
import flixel.util.FlxTimer;

#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	private var cam:FlxCamera;

	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';


	var scoreBG:FlxSprite;
	var mechBG:FlxSprite;

	var scoreText:FlxText;
	var diffText:FlxText;
	var mechText:FlxText;
	var mechDiffText:FlxText;
	var multiText:FlxText;

	public static var mechDiff:Int = 2;

	public var mechs:Array<String> = ['OFF', 'EASIER', 'STANDARD', 'NIGHTMARE'];
	public var mechName:String = 'STANDARD';

	public var multis:Array<String> = ['MULTIPLIER: 0.5x', 'MULTIPLIER: 1.0x', 'MULTIPLIER: 1.25x', 'MULTIPLIER: 1.5x'];

	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	// Chromatic thing
	public var filters:Array<BitmapFilter> = [];

	public var chromeTimer:FlxTimer;
	public var chromDanced:Bool = false;

	public var shader:ChromaticAberration;

	public var chromeOffset:Float = 0;
	public var chromeEffect:Float = 0;

	public var hasChroma:Bool = true;

	public var chromeExtra:Float = 1;

	// Song Data
	public var _songName:String = '';
	public var _songWeek:Int = 0;
	public var _songCharacter:String = '';
	public var _songColor:Int = 0;
	public var _songDiff:String = '';
	public var _songMechs:String = '';
	public var _songIntensity:Float = 0.0;
	public var _songBPM:Float = 0.0;

	public static var freeplayType = '';

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		// Chromatic
		hasChroma = true;
		//resetChromeShit2();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		if (CoolUtil.isPTBR())
		{
			mechs = ['DESLIGADO', 'FÁCIL', 'PADRÃO', 'PESADELO'];
			mechName = 'PADRÃO';
			multis = ['MULTIPLICADOR: 0.5x', 'MULTIPLICADOR: 1.0x', 'MULTIPLICADOR: 1.25x', 'MULTIPLICADOR: 1.35x'];
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		cam = new FlxCamera();
		FlxG.cameras.reset(cam);
		FlxCamera.defaultCameras = [cam];
		
		WeekData.loadTheFirstEnabledMod();

		// Adding Extra Songs
		if (freeplayType == 'Extras')
		{
			if (CoolUtil.isPTBR())
			{
				if (Achievements.isAchievementUnlocked('hidden_nightmare') || CoolUtil.isDevMode()) addSong('Burning in Fear', 0, 'bf-night', Std.parseInt('0xFF002338'), 'DISTORCIDO', 'true', 80, 170);
				if (Achievements.isAchievementUnlocked('killer_in_shadows') || CoolUtil.isDevMode()) addSong('DeleteNo', 1, 'eteled', Std.parseInt('0xFF2D000C'), 'DELETADO', 'true', 80, 185);
				if (Achievements.isAchievementUnlocked('hidden_in_the_corn_field') || CoolUtil.isDevMode()) addSong('True Spam', 0, 'bambi', Std.parseInt('0xFF002E09'), 'SPAM', 'true', 80, 240);
				if (Achievements.isAchievementUnlocked('secret_combat') || CoolUtil.isDevMode()) addSong('Magma', 0, 'tricky', Std.parseInt('0xFF3E0000'), 'LOUCO', 'true', 80, 212);
				if (Achievements.isAchievementUnlocked('divorce') || CoolUtil.isDevMode()) addSong('Broken Heart', 0, 'gf-night', Std.parseInt('0xFF900022'), 'TRAIÇÃO', 'false', 90, 220);
			}
			else
			{
				if (Achievements.isAchievementUnlocked('hidden_nightmare') || CoolUtil.isDevMode()) addSong('Burning in Fear', 0, 'bf-night', Std.parseInt('0xFF002338'), 'DISTORTED', 'true', 80, 170);
				if (Achievements.isAchievementUnlocked('killer_in_shadows') || CoolUtil.isDevMode()) addSong('DeleteNo', 1, 'eteled', Std.parseInt('0xFF2D000C'), 'DELETED', 'true', 80, 185);
				if (Achievements.isAchievementUnlocked('hidden_in_the_corn_field') || CoolUtil.isDevMode()) addSong('True Spam', 0, 'bambi', Std.parseInt('0xFF002E09'), 'SPAM', 'true', 80, 240);
				if (Achievements.isAchievementUnlocked('secret_combat') || CoolUtil.isDevMode()) addSong('Magma', 0, 'tricky', Std.parseInt('0xFF3E0000'), 'MAD', 'true', 80, 212);
				if (Achievements.isAchievementUnlocked('divorce') || CoolUtil.isDevMode()) addSong('Broken Heart', 0, 'gf-night', Std.parseInt('0xFF900022'), 'CHEAT', 'false', 90, 220);
			}
		}

		//NOT BROKEN ANYMORE AND USEFUL
		var initSonglist = getCorrectList();

		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				// Adding the Song
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[2], Std.parseInt(songArray[3]), songArray[4], songArray[5], Std.parseInt(songArray[6]), Std.parseInt(songArray[7]));

				// Getting the song Data
				getSongData();
			}
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			if (songText.width > 980)
			{
				var textScale:Float = 980 / songText.width;
				songText.scale.x = textScale;
				for (letter in songText.lettersArray)
				{
					letter.x *= textScale;
					letter.offset.x *= textScale;
				}
				//songText.updateHitbox();
				//trace(songs[i].songName + ' new scale: ' + textScale);
			}

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		mechBG = new FlxSprite(scoreText.x - 150, 80).makeGraphic(1, 66, 0xFF000000);
		mechBG.alpha = 0.6;
		add(mechBG);

		mechText = new FlxText(mechBG.x + mechBG.width + 25, mechBG.y + 25, 0, "MECHANICS DIFFICULTY:", 24);
		mechText.font = scoreText.font;

		if (CoolUtil.isPTBR())
			mechText.text = 'DIFICULDADE DAS MECÂNICAS:';
		add(mechText);

		mechDiffText = new FlxText(mechBG.x + mechBG.width + 25, mechBG.y + 25, 0, "< NORMAL >", 24);
		mechDiffText.font = scoreText.font;
		add(mechDiffText);

		multiText = new FlxText(mechBG.x + mechBG.width + 25, mechBG.y + 25, 0, "MULTIPLIER: 1.0x", 24);
		multiText.font = scoreText.font;
		add(multiText);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.color = FlxColor.RED;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end

		if (CoolUtil.isPTBR())
			leText = "Pressione o botão de REINICIAR para resetar seus Pontos e Precisão.";

		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();

		changeDiff(0);
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, diffName:String, hasMechs:String, intensity:Float, bpm:Float)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, diffName, hasMechs, intensity, bpm));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		// Getting the song Data
		getSongData();

		var crochet = ((60 * _songBPM) * 1000);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		// More Chromatic
		chromaticDance(2);
		chromeEffect += (_songIntensity / 10000) / (ClientPrefs.framerate / 120);

		diffText.text = '< ' + _songDiff + ' >';

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		if (CoolUtil.isPTBR())
			scoreText.text = 'MELHOR PESSOAL: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';

		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new FreeplaySelector());
		}

		/*if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else */if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			if (_songMechs == 'true') {
				PlayState.mechDifficulty = mechDiff;
				if (mechDiff == 0) PlayState.multiplier = 0.5;
				if (mechDiff == 1) PlayState.multiplier = 1.0;
				if (mechDiff == 2) PlayState.multiplier = 1.25;
				if (mechDiff == 3) PlayState.multiplier = 1.5;
			}

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (ClientPrefs.skinSelector)
				LoadingState.loadAndSwitchState(new SkinSelectorState());
			else
				LoadingState.loadAndSwitchState(new PlayState());

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));

		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		mechDiff += change;

		// Getting the song Data
		getSongData();

		if (mechDiff > 3) mechDiff = 0;
		if (mechDiff < 0) mechDiff = 3;

		if (ClientPrefs.baby && mechDiff >= 3) mechDiff = 0;

		if (mechDiff == 0) mechDiffText.color = FlxColor.GRAY;
		if (mechDiff == 1) mechDiffText.color = 0xFF9980FF;
		if (mechDiff == 2) mechDiffText.color = 0xFFFF00B9;
		if (mechDiff == 3) mechDiffText.color = 0xFFFF0000;

		mechName = mechs[mechDiff];
		mechDiffText.text = '< ' + mechName + ' >';

		multiText.text = multis[mechDiff];

		PlayState.storyDifficulty = curDifficulty;
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});

			// Getting the song Data
			getSongData();

			// Changing BPM
			Conductor.changeBPM(_songBPM);
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}

		if(instPlaying != curSelected)
		{
			#if PRELOAD_ALL
			destroyFreeplayVocals();
			FlxG.sound.music.volume = 0;
			Paths.currentModDirectory = songs[curSelected].folder;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());

			vocals = new FlxSound();

			FlxG.sound.list.add(vocals);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
			vocals.play();
			vocals.persist = true;
			vocals.looped = true;
			vocals.volume = 0.7;
			instPlaying = curSelected;
			#end
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);

		mechBG.scale.x = scoreBG.scale.x;
		mechBG.x = scoreBG.x;

		mechText.x = scoreText.x;
		mechText.y = mechBG.y + 7;

		mechDiffText.x = scoreText.x;
		mechDiffText.y = mechText.y + 27;

		multiText.x = mechDiffText.x + 250;
		multiText.y = mechDiffText.y;

		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;

		if (_songMechs == 'true') {
			mechBG.visible = true;
			mechText.visible = true;
			mechDiffText.visible = true;
			multiText.visible = true;
		} else {
			mechBG.visible = false;
			mechText.visible = false;
			mechDiffText.visible = false;
			multiText.visible = false;

			PlayState.mechDifficulty = 2;
			PlayState.multiplier = 1.0;
		}
	}

	public function chromaticDance(type:Float):Void
	{
		if (type == 1 || type == 2) {
			chromeOffset = _songIntensity;
			chromeOffset /= 1000;
		}

		if (type == 2)
		{
			chromeOffset *= 1;
		}

		if (chromeOffset - chromeEffect <= 0) {
			chromeOffset = 0;
		} else {
			chromeOffset -= chromeEffect;
		}

		ShadersHandler.setChrome(chromeOffset);

		chromDanced = !chromDanced;

		cam.setFilters([ShadersHandler.chromaticAberration]);
	}

	public function resetChromeShit2(?tmr:FlxTimer):Void
	{
		//ShadersHandler.setChrome(0.0);
		//chromDanced = false;
	}

	public function getCorrectList()
	{
		trace(freeplayType);
		var ret = CoolUtil.coolTextFile(Paths.txt('freeplay/nightmare/freeplaySonglist_en-us'));
		if (freeplayType == 'Nightmare' || freeplayType == 'Pesadelo')
		{
			ret = CoolUtil.coolTextFile(Paths.txt('freeplay/nightmare/freeplaySonglist_en-us'));
			if (CoolUtil.isPTBR())
			{
				ret = CoolUtil.coolTextFile(Paths.txt('freeplay/nightmare/freeplaySonglist_pt-br'));
			}
		}
		else
		{
			ret = CoolUtil.coolTextFile(Paths.txt('freeplay/extras/freeplaySonglist_en-us'));
			if (CoolUtil.isPTBR())
			{
				ret = CoolUtil.coolTextFile(Paths.txt('freeplay/extras/freeplaySonglist_pt-br'));
			}
		}

		return ret;
	}

	public function getSongData()
	{
		var allData:Array<Dynamic> = [songs[curSelected].songName, songs[curSelected].week, songs[curSelected].songCharacter, songs[curSelected].color, songs[curSelected].diffName, songs[curSelected].hasMechs, songs[curSelected].intensity, songs[curSelected].bpm];
	
		_songName = allData[0];
		_songWeek = allData[1];
		_songCharacter = allData[2];
		_songColor = allData[3];
		_songDiff = allData[4];
		_songMechs = allData[5];
		_songIntensity = allData[6];
		_songBPM = allData[7];
	}

	override function stepHit()
	{
		super.stepHit();
	}

	override function beatHit()
	{
		FlxG.camera.zoom += 0.03;
		chromeEffect = 0;

		FlxG.camera.shake(_songIntensity / 5000, 0.05);

		super.beatHit();
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var diffName:String = '';
	public var hasMechs:String = '';
	public var intensity:Float = 0;
	public var bpm:Float = 0;

	public function new(song:String, week:Int, songCharacter:String, color:Int, diffName:String, hasMechs:String, intensity:Float, bpm:Float)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		this.diffName = diffName;
		this.hasMechs = hasMechs;
		this.intensity = intensity;
		this.bpm = bpm;
		if(this.folder == null) this.folder = '';
	}
}