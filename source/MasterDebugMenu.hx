package;

import Controls.Control;
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
import flixel.input.keyboard.FlxKey;
import openfl.Lib;
import sys.io.File;
import sys.FileSystem;

class MasterDebugMenu extends MusicBeatState
{
    // Allow the player to type or not
    public var canType:Bool = true;

    // Cool Delete Character Stuff
    public var percent:Int = 0;
    public var password:Int = 0;
    public var characterToDelete:String = '';

    public var loading:Bool = false;
    public var increase:Int = 0;
    public var frames:Int = 0;

    public var maxFrames:Int = 0;
    public var maxIncrease:Int = 0;
    
    // Build Type
    public var buildType:String = '';

    // Texts (new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true))
    public var titleText:FlxText;
    public var inputText:FlxText;
    public var inputTextW:FlxText;
    public var copyrightText:FlxText;
    public var cursorText:FlxText;

    // For the Cursor
    public var cursorSin:Float = 0.00;
    public var lastLineType:Int = 0;

    // For Typing
    public var toConvert:Array<Array<String>> = [
        ['ONE', '1'], ['TWO', '2'], ['THREE', '3'], ['FOUR', '4'], ['FIVE', '5'], ['SIX', '6'], ['SEVEN', '7'], ['EIGHT', '8'], ['NINE', '9'], ['ZERO', '0'],
        ['MINUS', '-'], ['PLUS', '+'], ['SLASH', '/'], ['SEMICOLON', ';'], ['COMMA', ','], ['PERIOD', '.'], ['NUMPADONE', '1'], ['NUMPADTWO', '2'], ['NUMPADTHREE', '3'], ['NUMPADFOUR', '4'], ['NUMPADFIVE', '5'], 
        ['NUMPADSIX', '6'], ['NUMPADSEVEN', '7'], ['NUMPADEIGHT', '8'], ['NUMPADNINE', '9'], ['NUMPADZERO', '0'], ['NUMPADMULTIPLY', '*'], ['NUMPADMINUS', '-'], ['NUMPADPLUS', '+'], ['QUOTE', "'"], ['NUMPADPERIOD', '.']
    ];

    // Correct Codes
    public var codes:Array<Array<String>> = [
        // Code, Text, To Run the Last Code Should be X, Force Last Code (For Strange Codes), Custom Function
        ['execute', 'What Would You Like to Execute?\n[0] - Add Achievement\n[1] - Force Menu Character\n[2] - Close Application\n[3] - Delete Character\n[4] - Set Type\n[5] - Clear\n[6] - Cancel\n[7] - Go Back to the Main Menu\nInsert Command> ', '', ''],
        ['0', 'Achievement Name to Add:\nInsert Command> ', 'execute', 'addAchievement'],
        ['1', 'New Permanent Menu Character ID:\nInsert Command> ', 'execute', 'forceMenuCharacter'],
        ['2', '', 'execute', 'close'],
        ['3', 'Character to Delete:\nInsert Command> ', 'execute', 'selectCharacter'],
        ['4', 'New Build Type:\nInsert Command> ', 'execute', 'buildType'],
        ['5', '', 'execute', 'clear'],
        ['6', '', 'execute', 'cancel'],
        ['7', '', 'execute', 'goBack'],

        // Dev Codes
        ['MCBFBESTBF', 'Successfully Used Custom Code "MCBFBESTBF".', 'code', '']
    ];

    // For Fixing the Cursor Position
    public var blankCodes:Array<String> = [''];

    // Menu Characters
    public var menuCharacters:Array<String> = ['Nightmare BF', 'Eteled', 'Bambi', 'Tricky'];

    // For Backspace Stuff
    public var added:Int = 0;
    public var typed:String = '';

    // For Subcodes
    public var lastCode = '';

    // Code Variables
    public static var menuCharacter:Int = 0;

    override function create()
    {
        // This Thing
        super.create();

        // Translation
        if (CoolUtil.isPTBR())
        {
            codes = [
                // Code, Text, To Run the Last Code Should be X, Force Last Code (For Strange Codes), Custom Function
                ['execute', 'O que você gostaria de executar?\n[0] - Adicionar Conquista\n[1] - Forçar Personagem no Menu\n[2] - Fechar o Jogo\n[3] - Deletar Personagem\n[4] - Definir Tipo\n[5] - Limpar\n[6] - Cancelar\n[7] - Voltar Para o Menu Principal\nInserir Comando> ', '', ''],
                ['0', 'Nome da Conquista a ser Adicionada:\nInserir Comando> ', 'execute', 'addAchievement'],
                ['1', 'ID do Novo Personagem do Menu Permanente:\nInserir Comando> ', 'execute', 'forceMenuCharacter'],
                ['2', '', 'execute', 'close'],
                ['3', 'Personagem a ser Deletado:\nInserir Comando> ', 'execute', 'selectCharacter'],
                ['4', 'Novo Tipo de Build:\nInserir Comando> ', 'execute', 'buildType'],
                ['5', '', 'execute', 'clear'],
                ['6', '', 'execute', 'cancel'],
                ['7', '', 'execute', 'goBack'],
        
                // Dev Codes
                ['MCBFBESTBF', 'Codigo "MCBFBESTBF" Usado com Sucesso.', 'code', '']
            ];
        }

        // Generating the Passcode
        generatePassword();

        // Fade Music
        FlxG.sound.music.fadeOut();

        // Title Text
        titleText = new FlxText(0, 35, 0, 'Master Debug [v1.0.0]', 48, false);
        titleText.font = Paths.font('PixelOperator.ttf');
        titleText.color = 0x00FF00;
        titleText.borderStyle = NONE;
        titleText.screenCenter(X);

        add(titleText);

        // Copyright Text
        copyrightText = new FlxText(0, 85, 0, "(c) IsItLucas?' Team. All Rights Reserved.", 24, false);
        copyrightText.font = Paths.font('PixelOperator.ttf');
        copyrightText.color = 0x00FF00;
        copyrightText.borderStyle = NONE;
        copyrightText.screenCenter(X);

        add(copyrightText);

        // Input Text
        inputText = new FlxText(50, 150, 0, 'PS C:FNF Nightmares.exe // Insert Command> ', 15, false);
        inputText.font = Paths.font('PixelOperator.ttf');
        inputText.color = 0x00FF00;
        inputText.borderStyle = NONE;

        add(inputText);

        // For getting the Width of the text typed by the Player
        inputTextW = new FlxText(50, 150, 0, '', 15, false);
        inputTextW.font = Paths.font('PixelOperator.ttf');
        inputTextW.color = 0x00FF00;
        inputTextW.visible = false;

        add(inputText);

        // Cursor Text
        cursorText = new FlxText(50, 150, 0, '_', 15, false);
        cursorText.font = Paths.font('PixelOperator.ttf');
        cursorText.color = 0x00FF00;

        add(cursorText);

        // More Translation
        if (CoolUtil.isPTBR())
        {
            titleText.text = 'Debug Mestre [v1.0.0]';
            copyrightText.text = '(c) Time do IsItLucas?. Todos Direitos Reservados.';
            inputText.text = 'PS C:FNF Nightmares.exe // Inserir Comando> ';
        }
    }

	override function update(elapsed:Float)
    {
        // This
        super.update(elapsed);

        // Check if the player typed something
        checkKeyPress();

        // Cursor Position
        if (lastCode == '')
        {
            lastLineType = 0;
        }
        if (lastCode != '' && !blankCodes.contains(lastCode))
        {
            lastLineType = 1;
        }
        if (blankCodes.contains(lastCode))
        {
            lastLineType = 2;
        }

        // Checking the last Line
        for (i in 0...blankCodes.length)
        {
            if (lastCode == blankCodes[i])
            {
                lastLineType = 2;
                break;
            }
        }

        // For Get the Width
        inputTextW.text = typed;

        // Positionating the Cursor
        if (lastLineType == 0)
        {
            cursorText.x = 275 + inputText.x;
        }
        else if (lastLineType == 1)
        {
            cursorText.x = 108 + inputText.x;
        }
        else
        {
            cursorText.x = inputText.x;
        }

        cursorText.x += inputTextW.width - 2;
        cursorText.y = (inputText.height + inputText.y) - 20;

        // Show and Hide Cursor Animation
        cursorSin += 0.0625;
        if (cursorSin > 2)
        {
            cursorSin = 0;
        }
        if (cursorSin > 1 || !canType)
        {
            cursorText.visible = false;
        }
        else
        {
            cursorText.visible = true;
        }

        // Cool Loading
        if (loading)
        {
            if (frames <= 0)
            {
                maxFrames = Math.floor(8 * (ClientPrefs.framerate / 60));
                maxIncrease = 2;

                frames = FlxG.random.int(0, maxFrames);
                increase = FlxG.random.int(0, maxIncrease);

                percent += increase;
                if (percent >= 100)
                {
                    percent = 99;
                    loading = false;
                   
                    if (!CoolUtil.isPTBR())
                    {
                        insertText(' <ERROR>');
                        skipLine(1);
                        insertText('Could Not Detele Character "' + characterToDelete + '".');
                        skipLine(1);
                        insertText('The Process was Interrupted by an Administrator.');
        
                        typed = '';
                        lastCode = 'deleteno';
                        added = 0;
                        canType = true;
        
                        skipLine(1);
                        insertText('PS C:FNF Nightmares.exe // Insert Command?> ');
                    }
                    else
                    {
                        insertText(' <ERRO>');
                        skipLine(1);
                        insertText('Não Pode Deletar o Personagem "' + characterToDelete + '".');
                        skipLine(1);
                        insertText('O Processo foi Interrompido Por Um Administrador.');
        
                        typed = '';
                        lastCode = 'deleteno';
                        added = 0;
                        canType = true;
        
                        skipLine(1);
                        insertText('PS C:FNF Nightmares.exe // Inserir Comando?> ');   
                    }
                }
                else
                {
                    updateLoading(false);
                }
            }
            else
            {
                frames--;
            }
        }
    }

    public function checkKeyPress()
    {
        // Key Variables
        var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
        var keyName:String = Std.string(keyPressed);

        if (FlxG.keys.firstJustPressed() != FlxKey.NONE && canType)
        {
            // Normal Letter Type
            if (keyName.length == 1)
            {
                inputText.text += keyName.toLowerCase();
                typed += keyName.toLowerCase();

                added++;
            }
            else
            {
                convertLetter(keyName);
            }

            // Special Keys
            if (keyName == 'BACKSPACE' && added > 0)
            {
                eraseLetters(1);
            }
            if (keyName == 'ENTER')
            {
                checkSpecialCode(typed);
            }
        }
    }

    public function eraseLetters(amount:Int)
    {
        // Erase Input Letters
        added -= amount;

        // Save What the Text was Before
        var last:String = inputText.text;

        // Erasing the Text
        inputText.text = '';

        // Recreating the Text
        for (i in 0...last.length - amount)
        {
            inputText.text += last.charAt(i);
        }


        // Save What the Text was Before
        last = typed;

        // Erasing the Text
        typed = '';

        // Recreating the Text
        for (i in 0...last.length - amount)
        {
            typed += last.charAt(i);
        }
    }

    public function convertLetter(letter:String)
    {
        for (i in 0...toConvert.length)
        {
            if (letter == toConvert[i][0] + '')
            {
                added++;

                if (toConvert[i][0] + '' == 'MINUS')
                {
                    inputText.text += '_';
                    typed += '_';
                }
                else
                {
                    inputText.text += toConvert[i][1] + '';
                    typed += toConvert[i][1] + '';
                }

                break;
            }
        }
    }

    public function skipLine(skips:Int)
    {
        for (i in 0...skips)
        {
            inputText.text += '\n';
        }
    }

    public function checkSpecialCode(code:String)
    {
        trace(typed);
        
        // If the game should crash or not
        var found = false;
        var usedDiffCode = false;

        // Clearing the Prompt, Cancelling, and Going back to the Main Menu
        if (typed == 'clear' || typed == 'cancel' || typed == '5' || typed == '6')
        {
            usedDiffCode = true;

            if (typed == 'clear' || typed == '5')
            {
                inputText.text = '';
            }
            else
            {
                skipLine(1);
            }

            typed = '';
            lastCode = '';
            added = 0;

            if (CoolUtil.isPTBR())
            {
                insertText('PS C:FNF Nightmares.exe // Inserir Comando> ');
            }
            else
            {
                insertText('PS C:FNF Nightmares.exe // Insert Command> ');
            }
        }

        if (typed == 'goBack' || typed == '7')
        {
            usedDiffCode = true;

            LoadingState.loadAndSwitchState(new MainMenuState());
        }

        // Translation Shit
        if (!CoolUtil.isPTBR())
        {
            // Checking for Achievement Name
            if (lastCode == 'addAchievement')
            {
                usedDiffCode = true;
                for (i in 0...Achievements.achievementsStuff.length)
                {
                    if (Achievements.achievementsStuff[i][2] == code)
                    {
                        Achievements.unlockAchievement(code);
                        found = true;
                    }
                }

                if (!found)
                {
                    Lib.application.window.alert('Could Not Find Achievement Named "' + code + '"!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
                else
                {
                    skipLine(1);
                    insertText('Successfully Added Achievement "' + code + '".');

                    typed = '';
                    lastCode = '';
                    added = 0;

                    skipLine(1);
                    insertText('PS C:FNF Nightmares.exe // Insert Command> ');
                }
            }

            // Checking for Menu Character
            if (lastCode == 'forceMenuCharacter')
            {
                usedDiffCode = true;
                if (code == '1' || code == '2' || code == '3' || code == '4')
                {
                    skipLine(1);
                    insertText('Successfully Forced Menu Character of ID: ' + code + ' (' + menuCharacters[Std.parseInt(code) - 1] + ').');

                    menuCharacter = Std.parseInt(code);
                    typed = '';
                    lastCode = '';
                    added = 0;

                    skipLine(1);
                    insertText('PS C:FNF Nightmares.exe // Insert Command> ');
                }
                else
                {
                    Lib.application.window.alert('A Menu Character with an ID of ' + code + ' Does Not Exist!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            }

            if (lastCode == 'close')
            {
                usedDiffCode = true;
                Lib.application.window.close();
            }

            if (lastCode == 'passwordDelte')
            {
                usedDiffCode = true;
                if (typed == password + '')
                {
                    generatePassword();

                    skipLine(1);
                    insertText('Access Granted.');
        
                    typed = '';
                    lastCode = 'correctPassword';
                    added = 0;
                    canType = false;
                    loading = true;
        
                    skipLine(1);
                    insertText('Deleting Character "' + characterToDelete + '":');
                    updateLoading(true);
                }
                else
                {
                    Lib.application.window.alert('WRONG PASSWORD!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            } 

            if (lastCode == 'selectCharacter')
            {
                usedDiffCode = true;
                var path:String = Paths.modFolders('characters/' + typed);
                if (!FileSystem.exists(path)) 
                {
                    path = Paths.getPreloadPath(typed);
                    if (!FileSystem.exists(path)) 
                    {
                        Lib.application.window.alert('Could not find character named "' + typed + '".', 'MasterDebug.dll');
                        Lib.application.window.close();
                    }  
                } 

                skipLine(1);
                insertText('A Password is Required to Execute this Action.');

                characterToDelete = typed;
                typed = '';
                lastCode = 'passwordDelte';
                added = 0;

                skipLine(1);
                insertText('Insert Password> ');
            }  

            if (lastCode == 'deleteno')
            {
                // Variables
                usedDiffCode = true;
                canType = false;

                var delay = 0.025;
                var repeat = 100;

                // Error Messages
                new FlxTimer().start(delay, function(tmr:FlxTimer)
                {
                    skipLine(1);
                    insertText('<FATAL ERROR>');
                }, repeat);

                // Load DeleteNo
                new FlxTimer().start(delay * repeat, function(tmr:FlxTimer)
                {
                    loadSong('DeleteNo');
                }, 1);
            }

            if (lastCode == 'passwordBuild')
            {
                usedDiffCode = true;
                if (typed == '508379652532320131414239')
                {
                    generatePassword();

                    skipLine(1);
                    insertText('Access Granted.');
        
                    skipLine(1);
                    insertText('Build Type Set to: ' + buildType + '.');
                    skipLine(1);
                    insertText('The game must be restarted to apply all changes.');
                    skipLine(1);
                    insertText('Waiting Restart>');

                    typed = '';
                    lastCode = 'correctPasswordBuild';
                    added = 0;
                    canType = false;

                    ClientPrefs.buildType = buildType;
                    ClientPrefs.saveSettings();
                }
                else
                {
                    Lib.application.window.alert('WRONG PASSWORD!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            } 

            if (lastCode == 'buildType')
            {
                usedDiffCode = true;
                if (code == 'dev' || code == 'normal')
                {
                    skipLine(1);
                    insertText('A Master Password is Required to Execute this Action.');
        
                    buildType = typed;
                    typed = '';
                    lastCode = 'passwordBuild';
                    added = 0;
        
                    skipLine(1);
                    insertText('Insert Password> ');
                }
                else
                {
                    Lib.application.window.alert('Invalid Argument for "Build Type".', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            }

            // Checking for Normal Code
            found = false;
            for (i in 0...codes.length)
            {
                if (code == codes[i][0] + '' && lastCode == codes[i][2])
                {
                    skipLine(1);

                    typed = '';
                    lastCode = codes[i][0];
                    added = 0;

                    insertText(codes[i][1]);

                    if (codes[i][3] != '')
                    {
                        lastCode = codes[i][3];
                    }

                    found = true;
                    break;
                }
            }

            if (!found && typed != '' && !usedDiffCode)
            {
                Lib.application.window.alert('Code "' + typed + '" does not exist!', 'MasterDebug.dll');
                Lib.application.window.close();  
            }
        }



        else



        {

            // Checking for Achievement Name
            if (lastCode == 'addAchievement')
            {
                usedDiffCode = true;
                for (i in 0...Achievements.achievementsStuff.length)
                {
                    if (Achievements.achievementsStuff[i][2] == code)
                    {
                        Achievements.unlockAchievement(code);
                        found = true;
                    }
                }

                if (!found)
                {
                    Lib.application.window.alert('Nao foi Possivel Encontrar Conquista Chamada "' + code + '"!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
                else
                {
                    skipLine(1);
                    insertText('Conquista Adicionada com Sucesso: "' + code + '".');

                    typed = '';
                    lastCode = '';
                    added = 0;

                    skipLine(1);
                    insertText('PS C:FNF Nightmares.exe // Inserir Comando> ');
                }
            }

            // Checking for Menu Character
            if (lastCode == 'forceMenuCharacter')
            {
                usedDiffCode = true;
                if (code == '1' || code == '2' || code == '3' || code == '4')
                {
                    skipLine(1);
                    insertText('Personagem do Menu: ' + code + ' (' + menuCharacters[Std.parseInt(code) - 1] + ') ' + 'Forçado com Sucesso.');

                    menuCharacter = Std.parseInt(code);
                    typed = '';
                    lastCode = '';
                    added = 0;

                    skipLine(1);
                    insertText('PS C:FNF Nightmares.exe // Inserir Comando> ');
                }
                else
                {
                    Lib.application.window.alert('Um Personagem do Menu com o Nome ' + code + ' Nao Existe!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            }

            if (lastCode == 'close')
            {
                usedDiffCode = true;
                Lib.application.window.close();
            }

            if (lastCode == 'passwordDelte')
            {
                usedDiffCode = true;
                if (typed == password + '')
                {
                    generatePassword();

                    skipLine(1);
                    insertText('Acesso Concedido.');
        
                    typed = '';
                    lastCode = 'correctPassword';
                    added = 0;
                    canType = false;
                    loading = true;
        
                    skipLine(1);
                    insertText('Deleting Character "' + characterToDelete + '":');
                    updateLoading(true);
                }
                else
                {
                    Lib.application.window.alert('SENHA INCORRETA!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            } 

            if (lastCode == 'selectCharacter')
            {
                usedDiffCode = true;
                var path:String = Paths.modFolders('characters/' + typed);
                if (!FileSystem.exists(path)) 
                {
                    path = Paths.getPreloadPath(typed);
                    if (!FileSystem.exists(path)) 
                    {
                        Lib.application.window.alert('Nao foi Possivel Encontrar um Personagem Chamado "' + typed + '".', 'MasterDebug.dll');
                        Lib.application.window.close();
                    }  
                } 

                skipLine(1);
                insertText('Uma Senha é Necessária para Executar esta Ação.');

                characterToDelete = typed;
                typed = '';
                lastCode = 'passwordDelte';
                added = 0;

                skipLine(1);
                insertText('Insert Password> ');
            }  

            if (lastCode == 'deleteno')
            {
                // Variables
                usedDiffCode = true;
                canType = false;

                var delay = 0.025;
                var repeat = 100;

                // Error Messages
                new FlxTimer().start(delay, function(tmr:FlxTimer)
                {
                    skipLine(1);
                    insertText('<ERRO FATAL>');
                }, repeat);

                // Load DeleteNo
                new FlxTimer().start(delay * repeat, function(tmr:FlxTimer)
                {
                    loadSong('DeleteNo');
                }, 1);
            }

            if (lastCode == 'passwordBuild')
            {
                usedDiffCode = true;
                if (typed == '508379652532320131414239')
                {
                    generatePassword();

                    skipLine(1);
                    insertText('Acesso Concedido.');
        
                    skipLine(1);
                    insertText('Tipo de Build Definido Para: ' + buildType + '.');
                    skipLine(1);
                    insertText('O Jogo Precisará ser Reiniciado para que Todas as Mudanças sejam Aplicadas.');
                    skipLine(1);
                    insertText('Esperando...>');

                    typed = '';
                    lastCode = 'correctPasswordBuild';
                    added = 0;
                    canType = false;

                    ClientPrefs.buildType = buildType;
                    ClientPrefs.saveSettings();
                }
                else
                {
                    Lib.application.window.alert('SENHA INCORRETA!', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            } 

            if (lastCode == 'buildType')
            {
                usedDiffCode = true;
                if (code == 'dev' || code == 'normal')
                {
                    skipLine(1);
                    insertText('Uma Senha Mestre é Necessária para Executar esta Ação.');
        
                    buildType = typed;
                    typed = '';
                    lastCode = 'passwordBuild';
                    added = 0;
        
                    skipLine(1);
                    insertText('Insert Password> ');
                }
                else
                {
                    Lib.application.window.alert('Argumento Invalido para "Tipo de Build".', 'MasterDebug.dll');
                    Lib.application.window.close();
                }
            }

            // Checking for Normal Code
            found = false;
            for (i in 0...codes.length)
            {
                if (code == codes[i][0] + '' && lastCode == codes[i][2])
                {
                    skipLine(1);

                    typed = '';
                    lastCode = codes[i][0];
                    added = 0;

                    insertText(codes[i][1]);

                    if (codes[i][3] != '')
                    {
                        lastCode = codes[i][3];
                    }

                    found = true;
                    break;
                }
            }

            if (!found && typed != '' && !usedDiffCode)
            {
                Lib.application.window.alert('O Codigo "' + typed + '" Nao Existe!', 'MasterDebug.dll');
                Lib.application.window.close();  
            }
        }
    }
    
    public function insertText(string:String)
    {
        inputText.text += string;
    }

    public function updateLoading(first:Bool = false)
    {
        if (!first)
        {
            var percentString = percent + '%';
            if (percentString.length > 2)
            {
                if (percentString.length > 3)
                {
                    eraseLetters(5);
                }
                else
                {
                    eraseLetters(4); 
                }
            }
            else
            {
                eraseLetters(3); 
            }
        }
        skipLine(1);
        insertText(percent + '%');
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
        PlayState.mechDifficulty = 2;

		LoadingState.loadAndSwitchState(new PlayState());
		FlxG.sound.music.volume = 0;

		FlxG.mouse.visible = false;
	}

    public function generatePassword()
    {
        var content = [for (_ in 0...6) FlxG.random.int(0, 9) + ''].join('');
        var path = Paths.getPreloadPath('data/userData.json');

        // Deleting the File
        if (sys.FileSystem.exists(path))
        {
            sys.FileSystem.deleteFile(path);
        }

        // Creating the File
        if (!sys.FileSystem.exists(path) || (sys.FileSystem.exists(path) && sys.io.File.getContent(path) == content))
        {
            sys.io.File.saveContent(path, content);
        }

        password = Std.parseInt(content);
    }
}