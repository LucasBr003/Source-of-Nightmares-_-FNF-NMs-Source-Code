package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	// For change warnings
	public var curWarn:Int = 0;
	public var warns:Int = 3;

	// Text Groups
	public var warnFLGroup = new FlxTypedGroup<FlxText>();
	public var warnCOGroup = new FlxTypedGroup<FlxText>();
	public var warnWMGroup = new FlxTypedGroup<FlxText>();
	public var warnCLGroup = new FlxTypedGroup<FlxText>();

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		// Flashing Lights Warning
		var warnFL:Array<String> = 
		[
			'[!] Warning 1 / 3 [!]',
			'FLASHING LIGHTS',
			'',
			'This mod contains FLASHING LIGHTS.',
			'If you are sensitive to this kind of thing go to',
			'Options -> Visuals -> Flashing Lights',
			'and disable it.',
			'',
			'Use the ARROW KEYS to read all the warnings.',
			'Press ENTER to continue.'
		];
		if (CoolUtil.isPTBR())
		{
			warnFL = 
			[
				'[!] Aviso 1 / 3 [!]',
				'LUZES PISCANTES',
				'',
				'Este mod contém LUZES PISCANTES.',
				'Se você é sensível a esse tipo de coisa, vá para',
				'Opções -> Visuais -> Luzes Piscantes',
				'e desative-as.',
				'',
				'Use as SETAS para ler todos os avisos.',
				'Pressione ENTER para continuar.'
			];
		}

		for (t in 0...warnFL.length)
		{
			// Text settings
			var y = 200;
			var offset = 32;

			var text = new FlxText(0, y + (offset * t), 0, warnFL[t], 12);
			text.borderSize = 1;
			text.size = 32;
			text.font = Paths.font("vcr.ttf");
			text.screenCenter(X);

			warnFLGroup.add(text);
		}

		// Custom Options Warning
		var warnCO:Array<String> = 
		[
			'[!] Warning 2 / 3 [!]',
			'CUSTOM OPTIONS',
			'',
			'This mod provides a bunch of NEW OPTIONS.',
			'Make sure to check them for best experience.',
			'All the new options are located in',
			'Options -> Mods.',
			'',
			'Use the ARROW KEYS to read all the warnings.',
			'Press ENTER to continue.'
		];
		if (CoolUtil.isPTBR())
		{
			warnCO = 
			[
				'[!] Aviso 2 / 3 [!]',
				'OPÇÕES PERSONALIZADAS',
				'',
				'Este mod fornece um monte de NOVAS OPÇÕES.',
				'Certifique-se de verificá-las para melhor experiência.',
				'Todas as novas opções estão localizadas em',
				'Opções -> Mods.',
				'',
				'Use as SETAS para ler todos os avisos.',
				'Pressione ENTER para continuar.'
			];		
		}

		for (t in 0...warnCO.length)
		{
			// Text settings
			var y = 200;
			var offset = 32;

			var text = new FlxText(0, y + (offset * t), 0, warnCO[t], 12);
			text.borderSize = 1;
			text.size = 32;
			text.font = Paths.font("vcr.ttf");
			text.screenCenter(X);

			warnCOGroup.add(text);
		}

		// Window Mechanics Warning
		var warnWM:Array<String> = 
		[
			'[!] Warning 3 / 3 [!]',
			'WINDOW MECHANICS',
			'',
			'One of the songs in this mod messes with the game window.',
			'This mechanic may not work correctly in smaller resolutions.',
			'If you are having issues with it, go to',
			'Options -> Mods -> Window Mechanics and disable it.',
			'',
			'Use the ARROW KEYS to read all the warnings.',
			'Press ENTER to continue.'
		];
		if (CoolUtil.isPTBR())
		{
			warnWM = 
			[
				'[!] Warning 3 / 3 [!]',
				'MECÂNICAS DA JANELA DO JOGO',
				'',
				'Uma das músicas deste mod mexe com a janela do jogo.',
				'Esta mecânica pode não funcionar corretamente em resoluções menores.',
				'Se você está tendo problemas com isso, vá para',
				'Opções -> Mods -> Mecânicas da Janela e desative-a.',
				'',
				'Use the ARROW KEYS to read all the warnings.',
				'Press ENTER to continue.'
			];	
		}

		for (t in 0...warnWM.length)
		{
			// Text settings
			var y = 200;
			var offset = 32;

			var text = new FlxText(0, y + (offset * t), 0, warnWM[t], 12);
			text.borderSize = 1;
			text.size = 32;
			text.font = Paths.font("vcr.ttf");
			text.screenCenter(X);

			warnWMGroup.add(text);
		}

		// Changelog Warning
		var warnCL:Array<String> = 
		[
			'CHANGELOG (v0.9.6)',
			'What changed?',
			'',
			'* Addition: New Song (Broken Heart)',
			'* Addition: Bambis Mechanic (Final Nightmare)',
			'* Addition: Skin Selector (Freeplay Only)',
			'* Addition: New Options',
			'* Addition: This Warning Screen',
			'* Addition: Credit Bar at the Beginning of the Songs',
			'* Addition: Baby Mode',
			'* Addition: Freeplay Categories',
			'* Addition: Brazilian Portuguese',
			'* Rework: "Vanishing" Voices',
			'* Rework: "No Traces" Voices',
			'* Rework: Bambis Voice',
			'* Rework: Eteleds Mechanics',
			'* Rework: DeleteNo',
			'* Rework: Chromatic Aberration Effect',
			'* Rework: Mid Song Events',
			'* Rework: Bambis Mechanic',
			'* Nerf: Eteleds Mechanic',
			'* Nerf: Tricky (Final Nightmare)',
			'* Nerf: Antispam',
			'* Nerf: EASIER Difficulty',
			'* Nerf: Distortion',
			'* Nerf: Miss Penalities',
			'* Fix: Lane and Sign Layering',
			'* Fix: Downscroll Mechanics',
			'* Fix: Window Mechanics Fatal Error (When Off)',
			'* Fix: Checkpoints',
			'* Fix: Animated Icons',
			'',
			'Use the ARROW KEYS to read all the warnings.',
			'Press ENTER to continue.'
		];
		if (CoolUtil.isPTBR())
		{
			warnCL = 
			[
				'QUADRO DE MUDANÇAS (v0.9.6)',
				'O que mudou?',
				'',
				'* Adição: Nova Música (Broken Heart)',
				'* Adição: Mecânica do Bambi (Final Nightmare)',
				'* Adição: Seletor de Skins (Freeplay Apenas)',
				'* Adição: Novas Opções',
				'* Adição: Essa Tela de Aviso',
				'* Adição: Barra de Créditos no Começo das Músicas',
				'* Adição: Modo Bebê',
				'* Adição: Categorias do Menu de Jogo Livre',
				'* Adição: Português Brasileiro',
				'* Retrabalhado: Vozes da "Vanishing"',
				'* Retrabalhado: Vozes da "No Traces"',
				'* Retrabalhado: Voz do Bambi',
				'* Retrabalhado: Mecânica do Eteled',
				'* Retrabalhado: Mecânica do Bambi',
				'* Retrabalhado: DeleteNo',
				'* Retrabalhado: Efeito RGB',
				'* Retrabalhado: Eventos das Músicas',
				'* Nerf: Mecânica do Eteled',
				'* Nerf: Tricky (Final Nightmare)',
				'* Nerf: Antispam',
				'* Nerf: Dificuldade FÁCIL',
				'* Nerf: Distortion',
				'* Nerf: Penalidades de Erro',
				'* Conserto: Mal Organização da Pista e da Placa de Aviso',
				'* Conserto: Mecânicas no Downscroll',
				'* Conserto: Erro Fatal Quando as Mecânicas da Janela Estão Desligadas',
				'* Conserto: Checkpoints',
				'* Conserto: Ícones Animados',
				'',
				'Use the ARROW KEYS to read all the warnings.',
				'Press ENTER to continue.'
			];	
		}

		var lastX:Float = 0;
		for (t in 0...warnCL.length)
		{
			// Text settings
			var y = 30;
			var offset = 20;

			var text = new FlxText(0, y + (offset * t), 0, warnCL[t], 12);
			text.borderSize = 1;
			text.size = 20;
			text.font = Paths.font("vcr.ttf");
			if (t > 2 && t <= warnCL.length - 3)
			{
				if (CoolUtil.isPTBR())
				{
					text.x = 270;
				}
				else
				{
					text.x = 350;
				}
			}
			else
			{
				text.screenCenter(X);
				lastX = text.x;
			}

			warnCLGroup.add(text);
		}

		// Adding the text
		add(warnFLGroup);
		add(warnCOGroup);
		add(warnWMGroup);
		add(warnCLGroup);
	}

	override function update(elapsed:Float)
	{
		// Enter to continue
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
			}

			if(leftState)
			{
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		// Change between warnings
		var left = FlxG.keys.justPressed.LEFT;
		var right = FlxG.keys.justPressed.RIGHT;

		// Moving
		if (right)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

			curWarn += 1;
			if (curWarn > warns)
			{
				curWarn -= 1;
			}
		}
		if (left)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

			curWarn -= 1;
			if (curWarn < 0)
			{
				curWarn += 1;
			}
		}

		// Showing only the selected warn
		warnFLGroup.visible = false;
		warnCOGroup.visible = false;
		warnWMGroup.visible = false;
		warnCLGroup.visible = false;

		if (curWarn == 0) warnFLGroup.visible = true;
		if (curWarn == 1) warnCOGroup.visible = true;
		if (curWarn == 2) warnWMGroup.visible = true;
		if (curWarn == 3) warnCLGroup.visible = true;

		super.update(elapsed);
	}
}
