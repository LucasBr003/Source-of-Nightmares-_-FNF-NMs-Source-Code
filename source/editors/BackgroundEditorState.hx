package editors;

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

#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

/**
	*DEBUG MODE
 */
class BackgroundEditorState extends MusicBeatState
{
	// Camera Stuff
	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;
	private var camText:FlxCamera;

	public var pointer:FlxGraphic = FlxGraphic.fromClass(GraphicCursorCross);
	public var cameraPosition:FlxSprite;

	public var camFollow:FlxObject;
	public var camOutline:FlxSprite;
	public var camMask:FlxSprite;

	public var gameWidth = Math.round(Std.int(FlxG.width));
	public var gameHeight = Math.round(Std.int(FlxG.height));

	public var lastZoom:Float = 1;

	// Keybinds Stuff
	public var hideHUD:Bool = false;
	public var hideTips:Bool = false;

	// Images Stuff
	public var allImages:FlxTypedGroup<FlxSprite>;
	
	public var curImage:Int = 0;
	public var imagesList:Array<String> = [];
	public var imagesInfo:Array<Dynamic> = [];

	public var ghostImage:FlxSprite;
	public var lastImage:String = '';

	// Tips Variables
	public var tips:Array<String> = 
	[
		'Arrow Keys - Move Selected Sprite',
		'WASD - Move Camera',
		'Q / E - Change Camera Zoom',
		'SPACE - Play Beathit Animations',
		'Hold H To Hide The HUD',
		'Press T To Hide / Show The Tips',
		'Hold SHIFT To Move Faster'
	];

	// UI Tabs
	public var tabs:FlxUITabMenu;

	public var tabsArray = [
		{name: 'Image', label: 'Image'},
		{name: 'Image Properties', label: 'Image Properties'},
		{name: 'JSON Settings', label: 'JSON Settings'}
	];

	override function create()
	{
		// Making the mouse visible
		FlxG.mouse.visible = true;

		// Camera Stuff
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camText = new FlxCamera();

		FlxG.cameras.reset(camGame);

		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camText);

		camHUD.bgColor.alpha = 0; // Why do you exist...
		camText.bgColor.alpha = 0; // Why do you exist...

		FlxCamera.defaultCameras = [camGame];

		// Camera Range
		camOutline = new FlxSprite(0,0).makeGraphic(gameWidth, gameHeight, FlxColor.WHITE);
		camOutline.cameras = [camGame];
		add(camOutline);

		camMask = new FlxSprite(2,2).makeGraphic(gameWidth - 4, gameHeight - 4, 0xFF121212);
		camMask.cameras = [camGame];
		add(camMask);
		
		// Making the images group
		allImages = new FlxTypedGroup<FlxSprite>();
		add(allImages);
		
		// Making the ghost image
		ghostImage = new FlxSprite().loadGraphic(Paths.image('nightMall/nightTree'));
		add(ghostImage);

		// Camera Middle Point
		cameraPosition = new FlxSprite(Std.int(FlxG.width * 0.5), Std.int(FlxG.height * 0.5)).loadGraphic(pointer);
		cameraPosition.setGraphicSize(30, 30);
		cameraPosition.updateHitbox();
		cameraPosition.color = FlxColor.WHITE;
		cameraPosition.cameras = [camGame];
		add(cameraPosition);

		// Camera follow point
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		// Editor Tabs
		tabs = new FlxUITabMenu(null, tabsArray, true);
		tabs.cameras = [camHUD];
		tabs.resize(350, 400);
		tabs.x = 907;
		tabs.y = 25;
		tabs.scrollFactor.set();
		add(tabs);

		// Tips
		for (t in 0...tips.length - 1)
		{
			// Text settings
			var tipText:FlxText;
			
			tipText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tips.length - t), 300, tips[t], 12);
			tipText.borderSize = 1;
			tipText.setFormat(null, 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);

			tipText.cameras = [camText];
			add(tipText);
		}

		// Adding HUD Stuff
		addJsonStuff();
		addImageStuff();

		// Updating stuff
		updateCameraRange();
		updateGhostImage();

		// This thing
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
	}

	// Basically everything for the JSON tab
	var hideGf:FlxUICheckBox;
	var pixelStage:FlxUICheckBox;

	var zoomStepper:FlxUINumericStepper;
	var zoomLabel:FlxText;
	var directoryInput:FlxUIInputText;
	var directoryText:FlxText;

	var dadXStepper:FlxUINumericStepper;
	var dadYStepper:FlxUINumericStepper;
	var dadXLabel:FlxText;
	var dadYLabel:FlxText;
	var dadCamXStepper:FlxUINumericStepper;
	var dadCamYStepper:FlxUINumericStepper;
	var dadCamXLabel:FlxText;
	var dadCamYLabel:FlxText;

	var gfXStepper:FlxUINumericStepper;
	var gfYStepper:FlxUINumericStepper;
	var gfXLabel:FlxText;
	var gfYLabel:FlxText;
	var gfCamXStepper:FlxUINumericStepper;
	var gfCamYStepper:FlxUINumericStepper;
	var gfCamXLabel:FlxText;
	var gfCamYLabel:FlxText;

	var bfXStepper:FlxUINumericStepper;
	var bfYStepper:FlxUINumericStepper;
	var bfXLabel:FlxText;
	var bfYLabel:FlxText;
	var bfCamXStepper:FlxUINumericStepper;
	var bfCamYStepper:FlxUINumericStepper;
	var bfCamXLabel:FlxText;
	var bfCamYLabel:FlxText;

	var camSpeedLabel:FlxText;
	var camSpeedStepper:FlxUINumericStepper;

	var saveJsonButton:FlxButton;

	function addJsonStuff()
	{
		// JSON Group
		var jsonGroup = new FlxUI(null, tabs);
		jsonGroup.name = 'JSON Settings';

		// Variables make our lifes easier
		var checksX = 20;
		var checksY = 175;
		var checksDisY = 25;
		var disY = 40;
		var disX = 120;
		var textFixX = 3;
		var labelDisY = 15;

		// "Hide GF" Checkbox
		hideGf = new FlxUICheckBox(checksX, checksY, null, null, 'Hide Girlfriend', 100);
		hideGf.checked = false;
		hideGf.callback = function()
		{
			girlfriendHide();
		};

		// "Is Pixel Stage" Checkbox
		pixelStage = new FlxUICheckBox(checksX, hideGf.y + checksDisY, null, null, 'Pixel Stage', 100);
		pixelStage.checked = false;
		pixelStage.callback = function()
		{
			girlfriendHide();
		};

		// Default Cam Zoom Stepper
		zoomLabel = new FlxText(hideGf.x + disX, hideGf.y - 12, 0, 'Default Zoom:');
		zoomStepper = new FlxUINumericStepper(zoomLabel.x + textFixX, zoomLabel.y + labelDisY, 0.05, 1.0, 0.05, 10.0, 2);

		// Camera Speed Stepper
		camSpeedLabel = new FlxText(zoomLabel.x, zoomLabel.y + disY, 0, 'Camera Speed:');
		camSpeedStepper = new FlxUINumericStepper(zoomStepper.x, camSpeedLabel.y + labelDisY, 0.05, 1.0, 0.05, 10.0, 2);

		// Directory Text Input
		directoryInput = new FlxUIInputText(hideGf.x, checksY + (70 + labelDisY), 200, '', 8);
		directoryText = new FlxText(directoryInput.x - textFixX, directoryInput.y - labelDisY, 0, 'Directory:');

		// Save Stage Button
		saveJsonButton = new FlxButton(hideGf.x, directoryText.y + (disY + 20), 'Save JSON', function() {
			saveStage();
		});

		//// CHARACTERS POSITION AND CAMERA ////

		// Text Stuff
		disX = 80;

		bfXLabel = new FlxText(17, 20, 0, 'Boyfriend X:');
		bfYLabel = new FlxText(bfXLabel.x + disX, bfXLabel.y, 0, 'Boyfriend Y:');
		gfXLabel = new FlxText(bfXLabel.x, bfXLabel.y + disY, 0, 'Girlfriend X:');
		gfYLabel = new FlxText(gfXLabel.x + disX, gfXLabel.y, 0, 'Girlfriend Y:');
		dadXLabel = new FlxText(gfXLabel.x, gfXLabel.y + disY, 0, 'Opponent X:');
		dadYLabel = new FlxText(dadXLabel.x + disX, dadXLabel.y, 0, 'Opponent Y:');

		bfCamXLabel = new FlxText(dadYLabel.x + disX, bfXLabel.y, 0, 'BF Camera X:');
		bfCamYLabel = new FlxText(bfCamXLabel.x + disX, bfCamXLabel.y, 0, 'BF Camera Y:');
		gfCamXLabel = new FlxText(bfCamXLabel.x, bfCamXLabel.y + disY, 0, 'GF Camera X:');
		gfCamYLabel = new FlxText(gfCamXLabel.x + disX, gfCamXLabel.y, 0, 'GF Camera Y:');
		dadCamXLabel = new FlxText(gfCamXLabel.x, gfCamXLabel.y + disY, 0, 'Dad Camera X:');
		dadCamYLabel = new FlxText(dadCamXLabel.x + disX, dadCamXLabel.y, 0, 'Dad Camera Y:');
		
		// The actual Steppers
		bfXStepper = new FlxUINumericStepper(bfXLabel.x + textFixX, bfXLabel.y + labelDisY, 5, 150, -9999, 9999, 0);
		bfYStepper = new FlxUINumericStepper(bfYLabel.x + textFixX, bfYLabel.y + labelDisY, 5, 150, -9999, 9999, 0);
		gfXStepper = new FlxUINumericStepper(gfXLabel.x + textFixX, gfXLabel.y + labelDisY, 5, 150, -9999, 9999, 0);
		gfYStepper = new FlxUINumericStepper(gfYLabel.x + textFixX, gfYLabel.y + labelDisY, 5, 150, -9999, 9999, 0);
		dadXStepper = new FlxUINumericStepper(dadXLabel.x + textFixX, dadXLabel.y + labelDisY, 5, 150, -9999, 9999, 0);
		dadYStepper = new FlxUINumericStepper(dadYLabel.x + textFixX, dadYLabel.y + labelDisY, 5, 150, -9999, 9999, 0);

		bfCamXStepper = new FlxUINumericStepper(bfCamXLabel.x + textFixX, bfXLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		bfCamYStepper = new FlxUINumericStepper(bfCamYLabel.x + textFixX, bfYLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		gfCamXStepper = new FlxUINumericStepper(gfCamXLabel.x + textFixX, gfXLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		gfCamYStepper = new FlxUINumericStepper(gfCamYLabel.x + textFixX, gfYLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		dadCamXStepper = new FlxUINumericStepper(dadCamXLabel.x + textFixX, dadXLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		dadCamYStepper = new FlxUINumericStepper(dadCamYLabel.x + textFixX, dadYLabel.y + labelDisY, 5, 0, -9999, 9999, 0);

		// Putting everything into the group
		jsonGroup.add(hideGf);
		jsonGroup.add(pixelStage);
		jsonGroup.add(directoryInput);
		jsonGroup.add(directoryText);
		jsonGroup.add(saveJsonButton);

		jsonGroup.add(zoomStepper);
		jsonGroup.add(zoomLabel);
		jsonGroup.add(camSpeedStepper);
		jsonGroup.add(camSpeedLabel);

		jsonGroup.add(bfXStepper);
		jsonGroup.add(bfXLabel);
		jsonGroup.add(bfYStepper);
		jsonGroup.add(bfYLabel);
		jsonGroup.add(bfCamXStepper);
		jsonGroup.add(bfCamXLabel);
		jsonGroup.add(bfCamYStepper);
		jsonGroup.add(bfCamYLabel);

		jsonGroup.add(gfXStepper);
		jsonGroup.add(gfXLabel);
		jsonGroup.add(gfYStepper);
		jsonGroup.add(gfYLabel);
		jsonGroup.add(gfCamXStepper);
		jsonGroup.add(gfCamXLabel);
		jsonGroup.add(gfCamYStepper);
		jsonGroup.add(gfCamYLabel);

		jsonGroup.add(dadXStepper);
		jsonGroup.add(dadXLabel);
		jsonGroup.add(dadYStepper);
		jsonGroup.add(dadYLabel);
		jsonGroup.add(dadCamXStepper);
		jsonGroup.add(dadCamXLabel);
		jsonGroup.add(dadCamYStepper);
		jsonGroup.add(dadCamYLabel);

		// Adding the group
		tabs.addGroup(jsonGroup);
	}

	// Hide GF Function
	function girlfriendHide()
	{
		trace('TODO');
	}

	// All things that we are going to add later (Images Tab)
	var nameInput:FlxUIInputText;
	var nameText:FlxText;
	var pathInput:FlxUIInputText;
	var pathText:FlxText;

	var addImageButton:FlxButton;
	var removeImageButton:FlxButton;

	var imageXStepper:FlxUINumericStepper;
	var imageYStepper:FlxUINumericStepper;
	var imageXLabel:FlxText;
	var imageYLabel:FlxText;

	function addImageStuff()
	{
		// Useful variables
		var textFixX = 3;
		var labelDisY = 15;

		// Image Group
		var imageGroup = new FlxUI(null, tabs);
		imageGroup.name = 'Image';

		// Image Name Text Input
		nameInput = new FlxUIInputText(20, 25, 125, '', 8);
		nameText = new FlxText(nameInput.x - textFixX, nameInput.y - labelDisY, 0, 'Image Name:');

		// Image Path Text Input
		pathInput = new FlxUIInputText(nameInput.x + 150, nameInput.y, 125, '', 8);
		pathText = new FlxText(pathInput.x - textFixX, pathInput.y - labelDisY, 0, 'Image Path:');

		// Add and Remove Button
		addImageButton = new FlxButton(65, 340, 'Add / Update', function() {
			addImage();
		});
		removeImageButton = new FlxButton(addImageButton.x + 120, addImageButton.y, 'Remove', function() {
			removeImage();
		});

		// Image Position
		imageXLabel = new FlxText(20 - textFixX, 75 - labelDisY, 0, 'Image X:');
		imageYLabel = new FlxText(imageXLabel.x + 75, imageXLabel.y, 0, 'Image Y:');
		imageXStepper = new FlxUINumericStepper(imageXLabel.x + textFixX, imageXLabel.y + labelDisY, 5, 0, -9999, 9999, 0);
		imageYStepper = new FlxUINumericStepper(imageYLabel.x + textFixX, imageYLabel.y + labelDisY, 5, 0, -9999, 9999, 0);

		// Putting everything into the group
		imageGroup.add(nameInput);
		imageGroup.add(nameText);
		imageGroup.add(pathInput);
		imageGroup.add(pathText);

		imageGroup.add(imageXLabel);
		imageGroup.add(imageYLabel);
		imageGroup.add(imageXStepper);
		imageGroup.add(imageYStepper);

		imageGroup.add(addImageButton);
		imageGroup.add(removeImageButton);

		// Adding the group
		tabs.addGroup(imageGroup);
	}

	// Add Image Function
	function addImage()
	{
		// Variables to simplify stuff
		var imageName = nameInput.text;
		var imagePath = pathInput.text;
		var folder = 'images/';
		var extension = '.png';
		
		var x = imageXStepper.value;
		var y = imageYStepper.value;
		
		var directory = Paths.modFolders(folder + imagePath + extension);

		// Checking if there aren't any image with the same name
		// and checking if the image exists
		if (!imagesList.contains(imageName))
		{
			// Creating a new image data
			if (FileSystem.exists(directory))
			{
				// Adding image information to lists
				imagesList.push(imageName);
				imagesInfo.push([imageName, directory, imagePath, x, y]);

				directory = Paths.modFolders(imagePath);

				updateImages();
			}
			else
			{
				trace('ERROR: COULD NOT FIND IMAGE!!!');	
			}
		}
		else
		{
			trace('ERROR: ALREADY EXISTS AN IMAGE WITH THE SAME NAME!!!');
		}
	}

	function updateImages()
	{
		trace(imagesList);

		allImages.forEach(function(spr:FlxSprite) {
			spr.kill();
			allImages.remove(spr, true);
			spr.destroy();
		});

		remove(allImages);
		for (i in 0...imagesList.length)
		{
			var image:FlxSprite;

			var name = imagesInfo[i][0];

			image = new FlxSprite().loadGraphic(Paths.image(imagesInfo[i][2]));
			image.x = imagesInfo[i][3];
			image.y = imagesInfo[i][4];

			allImages.add(image);
		}

		allImages.cameras = [camGame];
		add(allImages);
	}

	// Remove Image Function
	function removeImage()
	{
		trace('TODO');
	}

	// Save file stuff
	var _file:FileReference;
	function saveStage() 
	{
		// Some badly coded arrays. I know I can do better, but I don't know how. At least it works.
		var bfPos:Array<Dynamic> = [bfXStepper.value, bfYStepper.value];
		var gfPos:Array<Dynamic> = [gfXStepper.value, gfYStepper.value];
		var dadPos:Array<Dynamic> = [dadXStepper.value, dadYStepper.value];

		var bfCam:Array<Dynamic> = [bfCamXStepper.value, bfCamYStepper.value];
		var gfCam:Array<Dynamic> = [gfCamXStepper.value, gfCamYStepper.value];
		var dadCam:Array<Dynamic> = [dadCamXStepper.value, dadCamYStepper.value];

		var json = 
		{
			"directory": "",

			"defaultZoom": zoomStepper.value,
			"isPixelStage": pixelStage.checked,

			"boyfriend": bfPos,
			"girlfriend": gfPos,
			"opponent": dadPos,

			"hide_girlfriend": hideGf.checked,

			"camera_speed": camSpeedStepper.value,
			"camera_boyfriend": bfCam,
			"camera_girlfriend": gfCam,
			"camera_opponent": dadCam
		};
	
		var data:String = Json.stringify(json, "\t");
	
		if (data.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, "stage.json");
		}
	}
		
	function onSaveComplete(_):Void	
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}
	
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}
	
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file.");
	}

	override public function update(elapsed:Float)
	{
		// Camera movement
		var moveSpeed = 5.0;
		if (FlxG.keys.pressed.SHIFT)
			moveSpeed = 10.0;

		if (FlxG.keys.pressed.W)
			camFollow.y -= moveSpeed;
		if (FlxG.keys.pressed.S)
			camFollow.y += moveSpeed;
		if (FlxG.keys.pressed.A)
			camFollow.x -= moveSpeed;
		if (FlxG.keys.pressed.D)
			camFollow.x += moveSpeed;

		// Camera Zoom
		if (FlxG.keys.pressed.SHIFT)
			moveSpeed = 0.025;
		else
			moveSpeed = 0.01;

		if (FlxG.keys.pressed.Q)
			camGame.zoom -= moveSpeed;
		if (FlxG.keys.pressed.E)
			camGame.zoom += moveSpeed;

		// Camera range based on stage zoom
		if (lastZoom != zoomStepper.value)
		{
			updateCameraRange();

			if (FileSystem.exists(Paths.modFolders('images/' + pathInput.text + '.png')))
			{
				updateGhostImage();
			}
		}

		// Some keybinds
		if (FlxG.keys.justPressed.T)
			camText.visible = !camText.visible;

		if (FlxG.keys.pressed.H)
			camHUD.visible = false;
		else
			camHUD.visible = true;

		// Ghost Image
		if (FileSystem.exists(Paths.modFolders('images/' + pathInput.text + '.png')))
			updateGhostImage();
		else
			ghostImage.visible = false;

		super.update(elapsed);
	}

	function updateCameraRange()
	{
		remove(camOutline);
		remove(camMask);

		var ww = Math.round(gameWidth / (zoomStepper.value / 2));
		var hh = Math.round(gameHeight / (zoomStepper.value / 2));

		camOutline = new FlxSprite(0,0).makeGraphic(ww, hh, FlxColor.WHITE);
		camOutline.cameras = [camGame];
		camOutline.screenCenter();
		add(camOutline);

		ww = Math.round((gameWidth - 4) / (zoomStepper.value / 2));
		hh = Math.round((gameHeight - 4) / (zoomStepper.value / 2));

		camMask = new FlxSprite(2 / zoomStepper.value, 2 / zoomStepper.value).makeGraphic(ww, hh, 0xFF121212);
		camMask.cameras = [camGame];
		camMask.screenCenter();
		add(camMask);

		lastZoom = zoomStepper.value;

		updateImages();
	}

	function updateGhostImage()
	{
		remove(ghostImage);
		ghostImage = new FlxSprite().loadGraphic(Paths.image(pathInput.text));
		ghostImage.x = imageXStepper.value;
		ghostImage.y = imageYStepper.value;
		ghostImage.alpha = 0.4;
		ghostImage.visible = true;
		ghostImage.cameras = [camGame];
		add(ghostImage);

		lastImage = pathInput.text;
	}
}