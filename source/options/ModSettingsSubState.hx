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

class ModSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		if (!CoolUtil.isPTBR())
		{
			title = 'Mod Settings';
			rpcTitle = 'Mod Settings Menu'; //for Discord Rich Presence

			var option:Option = new Option('Scary Mode',
			'If checked, the game will be a little scarier than usual.',
			'scary',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Window Mechanics',
			'One of the songs has a mechanic that messes with the window, but it may not work with certain screen resolutions. If you are having trouble with this mechanic, just disable this option.',
			'windowMechs',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Baby Mode',
			'If checked, you will make the game easier and allow it to make fun of you.',
			'baby',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Animated Icons',
			'If unchecked, Animated Icons will be replaced by Normal Icons. Animated Icons can be distracting some times.',
			'animIcons',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Skin Selector',
			'If checked, you will be able to choose your BF skin before playing a song in Freeplay. But it can get annoying, since it takes a while to load.',
			'skinSelector',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Portuguese',
			'If checked, the mod will be fully translated to Portuguese Brazilian.',
			'ptbr',
			'bool',
			false);
			addOption(option);

			////////// Starting here, the Information Stuff //////////

			var option:Option = new Option('Show Score',
			'Wanna see your score?',
			'showScore',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Show Misses',
			'Wanna see your misses?',
			'showMisses',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Show Accuracy',
			'Wanna see your accuracy?',
			'showAcc',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Show Health',
			'Wanna see your health?',
			'showHealth',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Show Judgements',
			'Wanna see your judgements?',
			'showJudgements',
			'bool',
			true);
			addOption(option);

			////////// Ending here,  the Information Stuff //////////

			var option:Option = new Option('Lane Transparency',
				'This mod contains a lot of distracting stuff in the background, making harder to read the notes. If checked, a black bar will cover the background close to the notes, making easier to see them.\n0 = Invisible\n100 = Fully Visible',
				'laneTransparency',
				'percent',
				0);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.05;
			option.decimals = 2;

			var option:Option = new Option('Jumpscare Volume',
				'The game will try to scare you in a similar way Winter Horrorland did.\nBut do not worry, you can change the jumpscare volume to prevent a heart attack.',
				'jumpscareVolume',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;

			var option:Option = new Option('Chromatic Intensity',
				'Chromatic aberration effect intensity.',
				'rgbIntensity',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;

			var option:Option = new Option('Shake Intensity',
				'Screen shake intensity.',
				'shakeIntensity',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;
		}
		else
		{
			title = 'Opcoes do Mod';
			rpcTitle = 'Menu de Configurações do Mod'; //for Discord Rich Presence

			var option:Option = new Option('Modo Assustador',
			'Se marcado, o jogo ficará mais assustador do que o normal.',
			'scary',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Mecanicas da Janela do Jogo',
			'Em uma das músicas, o jogo mexe com a janela do jogo, mas isso pode se tornar problemático em resoluções de tela muito pequenas. Então se estiver tendo problemas, desative essa opção.',
			'windowMechs',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Modo Bebe',
			'Se marcado, você tornará o jogo mais fácil e permitirá que ele tire sarro de você.',
			'baby',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Icones Animados',
			'Se desmarcado, os ícones animados serão substituidos por ícones normais. Ícones animados são legais, mas podem te destrair.',
			'animIcons',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Seletor de Skin',
			'Se marcado você poderá escolher uma skin diferente para o BF enquanto joga no Free Play, mas pode se tornar irritante pois demora anos para carregar.',
			'skinSelector',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Portugues',
			'Se marcado, o mod será traduzido para a melhor língua de todas. Portugues Brasileiro.',
			'ptbr',
			'bool',
			false);
			addOption(option);

			////////// Starting here, the Information Stuff //////////

			var option:Option = new Option('Mostrar Pontos',
			'Quer ver seus pontos?',
			'showScore',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Mostrar Erros',
			'Quer ver seus erros?',
			'showMisses',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Mostrar Precisao',
			'Quer ver sua precisão?',
			'showAcc',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Mostrar Vida',
			'Quer ver sua vida?',
			'showHealth',
			'bool',
			true);
			addOption(option);

			var option:Option = new Option('Mostrar Julgamentos',
			'Quer ver seus julgamentos?',
			'showJudgements',
			'bool',
			true);
			addOption(option);

			////////// Ending here,  the Information Stuff //////////

			var option:Option = new Option('Transparencia da Pista',
				'Esse mod contém cenários que podem te destrair, fazendo com que fique difícil se concentrar nas notas. Se marcado, uma faixa preta aparecerá cobrindo tudo que pode te destrair, facilitando se concentrar nas notas.',
				'laneTransparency',
				'percent',
				0);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.05;
			option.decimals = 2;

			var option:Option = new Option('Volume do Jumpscare',
				'O jogo tentará te assustar de uma forma semelhanta a da Winter Horrorland. Mas não se preocupe! Você pode abaixar o volume para previnir um ataque cardíaco.',
				'jumpscareVolume',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;

			var option:Option = new Option('Intensidade do Efeito RGB',
				'Intensidade do Efeito RGB (Se não sabe o que é, pesquise no Google "Efeito RGB" ou "Chromatic Aberration").',
				'rgbIntensity',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;

			var option:Option = new Option('Intensidade do Tremor',
				'Intensidade do Tremor (Quando o oponente canta, a tela treme).',
				'shakeIntensity',
				'percent',
				1);
			addOption(option);
			option.scrollSpeed = 1.6;
			option.minValue = 0.0;
			option.maxValue = 1;
			option.changeValue = 0.1;
			option.decimals = 1;	
		}

		super();
	}
}