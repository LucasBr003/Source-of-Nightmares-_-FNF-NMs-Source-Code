package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		if (CoolUtil.isPTBR()) {
			title = 'Visuais e Interface';
			rpcTitle = 'Menu de Configuracões dos Visuais e da Interface'; //for Discord Rich Presence

			var option:Option = new Option('Splashes da Nota',
				"Se desmarcado, quando um \"Sick\" for acertado, não terá particulas.",
				'noteSplashes',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Esconder Interface',
				'Se marcado, apenas as setas ficarão visíveis.',
				'hideHud',
				'bool',
				false);
			addOption(option);
			
			var option:Option = new Option('Barra de Tempo:',
				"O que a barra de tempo deve mostrar?",
				'timeBarType',
				'string',
				'Tempo Restante e Nome da Musica',
				['Tempo Restante', 'Tempo Decorrido', 'Nome Da Musica', 'Tempo Restante e Nome da Musica', 'Tempo Decorrido e Nome da Musica', 'Nada']);
			addOption(option);

			var option:Option = new Option('Luzes Piscantes',
				"Desative isso se você é sensível a luzes piscantes (Epilepsia)!",
				'flashing',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Zooms da Camera',
				"Se desmarcado, a camera não irá ter nenhum zoom no rítimo da música.",
				'camZooms',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Zoom no texto ao acertar',
				"Se desmarcado, o texto da pontuação não terá nenhum tipo de zoom ao acertar uma nota.",
				'scoreZoom',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Opacidade da Barra de Vida',
				'O quão transparente a barra de vida e os ícones devem ser.',
				'healthBarAlpha',
				'percent',
				1);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;
			addOption(option);
			
			#if !mobile
			var option:Option = new Option('Mostrar FPS',
				'Se desmarcado, o FPS não estará visível.',
				'showFPS',
				'bool',
				true);
			addOption(option);
			option.onChange = onChangeFPSCounter;
			#end
			
			var option:Option = new Option('Musica do Menude Pausa:',
				"Qual música você prefere para o menu de pausa?",
				'pauseMusic',
				'string',
				'Tea Time',
				['Nenhuma', 'Breakfast', 'Tea Time']);
			addOption(option);
			option.onChange = onChangePauseMusic;
		} else {
			title = 'Visuals and UI';
			rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

			var option:Option = new Option('Note Splashes',
				"If unchecked, hitting \"Sick!\" notes won't show particles.",
				'noteSplashes',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Hide HUD',
				'If checked, hides most HUD elements.',
				'hideHud',
				'bool',
				false);
			addOption(option);
			
			var option:Option = new Option('Time Bar:',
				"What should the Time Bar display?",
				'timeBarType',
				'string',
				'Time Left and Song Name',
				['Time Left', 'Time Elapsed', 'Song Name', 'Time Left and Song Name', 'Time Elapsed and Song Name', 'Disabled']);
			addOption(option);

			var option:Option = new Option('Flashing Lights',
				"Uncheck this if you're sensitive to flashing lights!",
				'flashing',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Camera Zooms',
				"If unchecked, the camera won't zoom in on a beat hit.",
				'camZooms',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Score Text Zoom on Hit',
				"If unchecked, disables the Score text zoomingeverytime you hit a note.",
				'scoreZoom',
				'bool',
				true);
			addOption(option);

			var option:Option = new Option('Health Bar Transparency',
				'How much transparent should the health bar and icons be.',
				'healthBarAlpha',
				'percent',
				1);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;
			addOption(option);
			
			#if !mobile
			var option:Option = new Option('FPS Counter',
				'If unchecked, hides FPS Counter.',
				'showFPS',
				'bool',
				true);
			addOption(option);
			option.onChange = onChangeFPSCounter;
			#end
			
			var option:Option = new Option('Pause Screen Song:',
				"What song do you prefer for the Pause Screen?",
				'pauseMusic',
				'string',
				'Tea Time',
				['None', 'Breakfast', 'Tea Time']);
			addOption(option);
			option.onChange = onChangePauseMusic;
		}

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}