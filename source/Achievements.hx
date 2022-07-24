import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement, Image Name
		['Confronting Yourself',		'Start your nightmare (For real)',	'confronting_yourself',			false,		'boyfriend_1'],
		['Dodge Master',				'Dodge 50 times on Illusion',		'dodge_master',					false,		'boyfriend_2'],
		['Illusionist',					'Full Combo ILLUSION',				'illusionist',					false,		'boyfriend_3'],
		['Hidden Nightmare',			"Beat Nightmare BF's secret song",	'hidden_nightmare',				false,		'boyfriend_4'],

		['You Survived',				"Beat Eteled's Nightmare",			'survive',						false,		'eteled_1'],
		['Too many Deaths',				'Press 50 Axe Notes',				'too_many_deaths',				false,		'eteled_2'],
		['Killer of Killers',			'Full Combo VANISHING',				'killer_of_killers',			false,		'eteled_3'],
		['Killer in the Shadows',		"Beat Eteled's secret song",		'killer_in_shadows',			false,		'eteled_4'],

		['Tricking the Trickster',		"Beat Tricky's Nightmare",			'trickster',					false,		'tricky_1'],
		['Expurgated',					'Press 50 Halo Notes',				'expurgated',					false,		'tricky_2'],
		['Stronger than Hank',			'Full Combo IMPROBABILITY',			'stronger_than_hank',			false,		'tricky_3'],
		['Secret Combat',				"Beat Tricky's secret song",		'secret_combat',				false,		'tricky_4'],

		['Hell Farm',					"Beat Bambi's Nightmare",			'hell_farm',					false,		'bambi_1'],
		['Farming',						'Press 500 Corn Notes',				'farming',						false,		'bambi_2'],
		['Spammer',						'Full Combo FIRE CORN',				'spammer',						false,		'bambi_3'],
		['Hidden in the Cornfield',		"Beat Bambi's secret song",			'hidden_in_the_corn_field',		false,		'bambi_4'],

		['Divorce', 					'Beat Nightmare Girlfriend',		'divorce',						false,		'girlfriend_1'],
		['Victory',						'Beat Nightmare Imposter',			'victory',						false,		'imposter_1']
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static var dodges:Int = 0;
	public static var halos:Int = 0;
	public static var axes:Int = 0;
	public static var corns:Int = 0;

	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

		ClientPrefs.saveSettings();
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		trace(FlxG.save.data.achievementsMap);
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(FlxG.save.data.achievementsUnlocked != null) {
				FlxG.log.add("Trying to load stuff");
				var savedStuff:Array<String> = FlxG.save.data.achievementsUnlocked;
				for (i in 0...savedStuff.length) {
					achievementsMap.set(savedStuff[i], true);
				}
			}

			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}

			if(dodges == 0 && FlxG.save.data.dodges != null) {
				dodges = FlxG.save.data.dodges;
			}
			if(axes == 0 && FlxG.save.data.axes != null) {
				axes = FlxG.save.data.axes;
			}
			if(halos == 0 && FlxG.save.data.halos != null) {
				halos = FlxG.save.data.halos;
			}
			if(corns == 0 && FlxG.save.data.corns != null) {
				corns = FlxG.save.data.corns;
			}

			trace('Axes Pressed by The Player Until Now: ' + FlxG.save.data.axes);
			trace('Halo Pressed by The Player Until Now: ' + FlxG.save.data.halos);
			trace('Corn Pressed by The Player Until Now: ' + FlxG.save.data.corns);
		}

		// You might be asking "Why didn't you just fucking load it directly dumbass??"
		// Well, Mr. Smartass, consider that this class was made for Mind Games Mod's demo,
		// i'm obviously going to change the "Psyche" achievement's objective so that you have to complete the entire week
		// with no misses instead of just Psychic once the full release is out. So, for not having the rest of your achievements lost on
		// the full release, we only save the achievements' tag names instead. This also makes me able to rename
		// achievements later as long as the tag names aren't changed of course.

		// Edit: Oh yeah, just thought that this also makes me able to change the achievements orders easier later if i want to.
		// So yeah, if you didn't thought about that i'm smarter than you, i think

		// buffoon

		// EDIT 2: Uhh this is weird, this message was written for MInd Games, so it doesn't apply logically for Psych Engine LOL
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			var id:Int = Achievements.getAchievementIndex(tag);

			loadGraphic(Paths.image('achievements/' + Achievements.achievementsStuff[id][4]));
			trace(Achievements.achievementsStuff[id][4]);
		} else {
			loadGraphic(Paths.image('achievements/achievementLock'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('achievements/' + Achievements.achievementsStuff[id][4]));

		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 2.5)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;

		ClientPrefs.saveSettings();

		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}