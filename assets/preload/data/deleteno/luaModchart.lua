-- Window Arguments --

-- window_move(toX:Int, toY:Int)
-- window_alert(message:String, title:String)
-- window_close()
-- window_changeSize(width:Int, height:Int)
-- window_setResizable(resizable:Bool)
-- window_fullScreen(fullscreen:Bool)

--------------------------------------------------
-- Random LUA seed
math.randomseed(os.time())

-- Some Variables
bool = false
int = 0

fullScreen = false
canZoom = true

-- Actual Code
function onCreatePost()
    -- Making a dummy sprite to set the window position
    if windowFunctions and mechDiff > 0 then
        makeLuaSprite('window', '', 0, 0)
        makeGraphic('window', 1, 1, 0x00000000)
        addLuaSprite('window')

        window_fullScreen(false)
        window_changeSize(1280, 720)

        -- Window is not resizable
        window_setResizable(false)
    end

    -- Custom Time Bar Stuff
    setProperty('customBarTxt', true)

    if timeBarType == 'Tempo Decorrido'                     then    setProperty('timeTxt.text', '?:??')                 end
    if timeBarType == 'Tempo Restante'                      then    setProperty('timeTxt.text', '?:??')                 end
    if timeBarType == 'Nome da Musica'                      then    setProperty('timeTxt.text', '????????')             end
    if timeBarType == 'Tempo Restante e Nome da Musica'     then    setProperty('timeTxt.text', '???????? - (?:??)')    end
    if timeBarType == 'Tempo Decorrido e Nome da Musica'    then    setProperty('timeTxt.text', '???????? - (?:??)')    end

    if timeBarType == 'Time Elapsed'                        then    setProperty('timeTxt.text', '?:??')                 end
    if timeBarType == 'Time Left'                           then    setProperty('timeTxt.text', '?:??')                 end
    if timeBarType == 'Song Name'                           then    setProperty('timeTxt.text', '????????')             end
    if timeBarType == 'Time Left and Song Name'             then    setProperty('timeTxt.text', '???????? - (?:??)')    end
    if timeBarType == 'Time Elapsed and Song Name'          then    setProperty('timeTxt.text', '???????? - (?:??)')    end
end

function onUpdate()
    if windowFunctions and mechDiff > 0 then
        -- Forcing the camera to copy the dummy sprite properties
        window_move(getProperty('window.x') + (1280 / 4), getProperty('window.y')  + (720 / 4))

        setProperty('camZooming', canZoom)
        window_fullScreen(fullScreen)
    end
end

function onBeatHit()
    if windowFunctions and mechDiff > 0 then
        if portuguese then
            if curBeat == 128 and windowFunctions 		then 		window_alert("DebugMestre>_ Ameaca Detectada: ''Eteled.rat''.", 'FNF Nightmares.exe') 													end
            if curBeat == 156 and windowFunctions 		then 		window_alert("DebugMestre>_ Recomece ou saia da musica para previnir danos ao seu computador.", 'FNF Nightmares.exe') 					end
            if curBeat == 184 and windowFunctions 		then 		window_alert("DebugMestre>_ Uma ameaca de alto risco foi encontrada recentemente. Pare de jogar imediatamente.", 'FNF Nightmares.exe') 	end
            if curBeat == 224 and windowFunctions 		then 		window_alert("DebugMestre>_ Musica corrompida.", 'FNF Nightmares.exe') 																	end
            if curBeat == 239 and windowFunctions 		then 		window_alert("DebugMestre>_ Personagem corrompido.", 'FNF Nightmares.exe') 																end
            if curBeat == 249 and windowFunctions 		then		window_alert("DebugMestre>_ Ameaca detectada.", 'FNF Nightmares.exe') 																	end
        else
			if curBeat == 128 and windowFunctions 		then 		window_alert("MasterDebug>_ Threat detected: ''Eteled.rat''.", 'FNF Nightmares.exe') 													end
			if curBeat == 156 and windowFunctions 		then 		window_alert("MasterDebug>_ Restart or leave the song to prevent any damage to your computer.", 'FNF Nightmares.exe') 					end
			if curBeat == 184 and windowFunctions 		then 		window_alert("MasterDebug>_ A high-risk threat was recently found. Stop playing immediately.", 'FNF Nightmares.exe') 					end
			if curBeat == 224 and windowFunctions 		then 		window_alert("MasterDebug>_ Song corrupted.", 'FNF Nightmares.exe') 																	end
			if curBeat == 239 and windowFunctions 		then 		window_alert("MasterDebug>_ Character corrupted.", 'FNF Nightmares.exe') 																end
			if curBeat == 249 and windowFunctions 		then		window_alert("MasterDebug>_ Threat detected.", 'FNF Nightmares.exe') 
        end

        if curBeat == 1 then
            fullScreen = true
            window_fullScreen(true)
        end

        if not fullScreen then
            if curBeat >= 5 then
                -- HUD Zoom
                doTweenZoom('zoomInHUD', 'camHUD', 1.65, 0.0001, 'easeInOut')
                doTweenZoom('zoomOutHUD', 'camHUD', 1.6, 0.25, 'easeInOut')

                -- Game Zoom
                doTweenZoom('zoomInGame', 'camGame', 1.35, 0.0001, 'easeInOut')
                doTweenZoom('zoomOutGame', 'camGame', 1.25, 0.25, 'easeInOut')
            end
        end
    end

    if curBeat == 256 then
        if timeBarType == 'Tempo Decorrido'                     then    setProperty('timeTxt.text', '?:??')                 end
        if timeBarType == 'Tempo Restante'                      then    setProperty('timeTxt.text', '?:??')                 end
        if timeBarType == 'Nome da Musica'                      then    setProperty('timeTxt.text', 'DeleteNo')             end
        if timeBarType == 'Tempo Restante e Nome da Musica'     then    setProperty('timeTxt.text', 'DeleteNo - (?:??)')    end
        if timeBarType == 'Tempo Decorrido e Nome da Musica'    then    setProperty('timeTxt.text', 'DeleteNo - (?:??)')    end
    
        if timeBarType == 'Time Elapsed'                        then    setProperty('timeTxt.text', '?:??')                 end
        if timeBarType == 'Time Left'                           then    setProperty('timeTxt.text', '?:??')                 end
        if timeBarType == 'Song Name'                           then    setProperty('timeTxt.text', 'DeleteNo')             end
        if timeBarType == 'Time Left and Song Name'             then    setProperty('timeTxt.text', 'DeleteNo - (?:??)')    end
        if timeBarType == 'Time Elapsed and Song Name'          then    setProperty('timeTxt.text', 'DeleteNo - (?:??)')    end
    end

    if curBeat == 512 then
        setProperty('customBarTxt', false)
        setProperty('barGlitch', false)
    end

	-- Cool Texts
	if portuguese then
		if curBeat == 1 	then 	debugPrint("DebugMestre>_ O personagem que você tentou carregar (Eteled.json) telvez esteja corrompido.") 		    end
		if curBeat == 4 	then 	debugPrint("DebugMestre>_ Carregar o personagem mesmo assim?") debugPrint("DebugMestre>_ [S / N]") 				    end
		if curBeat == 8 	then 	debugPrint("DebugMestre>_ Você escolheu SIM.") debugPrint("DebugMestre>_ Carregando personagem ''Eteled.json''.") 	end
		if curBeat == 12 	then 	debugPrint("Eteled.rat>_ Sub1st1tu1nd0 p3rson4g3m ''Eteled.json'' p0r ''3TE13d.rat''.") 						    end
		if curBeat == 16 	then 	debugPrint("Eteled.rat>_ P3rs0n4g3m ''3TE13d.rat'' c4rr3g4d0 c0m suc3ss0.") 									    end

		if curBeat == 256 	then 	debugPrint("DebugMestre>_ Pare de jogar imediatamente para previnir danos ao seu computador.") 					    end
		if curBeat == 273 	then 	debugPrint("DebugMestre>_ Ameaça detectada: ''Eteled.rat''.") 													    end
		if curBeat == 273 	then 	debugPrint("DebugMestre>_ Risco: Fatal") 																		    end
	else
		if curBeat == 1 	then 	debugPrint("MasterDebug>_ The character you tried to load (Eteled.json) may be corrupted.") 					    end
		if curBeat == 4 	then 	debugPrint("MasterDebug>_ Load the character anyways?") debugPrint("MasterDebug>_ [Y / N]") 					    end
		if curBeat == 8 	then 	debugPrint("MasterDebug>_ You choosed YES.") debugPrint("MasterDebug>_ Loading character ''Eteled.json''.") 	    end
		if curBeat == 12 	then 	debugPrint("Eteled.rat>_ R3pl4cing char4cter ''Eteled.json'' by ''3TE13D.rat''.") 								    end
		if curBeat == 16 	then 	debugPrint("Eteled.rat>_ Suc3fully l0aded ch4ract3r ''3tE13D.rat''.") 											    end																	end

		if curBeat == 256 	then 	debugPrint("MasterDebug>_ Stop playing immediately to prevent any damage to your computer.") 					    end
		if curBeat == 273 	then 	debugPrint("MasterDebug>_ Threat detected: ''Eteled.rat''.") 													    end
		if curBeat == 273 	then 	debugPrint("MasterDebug>_ Risk: Fatal") 																		    end
	end

    -- Time Bar Effects
    if curBeat == 64 then
        setProperty('customBarTxt', false)
    end

    if curBeat == 256 then
        setProperty('customBarTxt', true)
        setProperty('barGlitch', true)
    end
end

function splitScreen(mustHitSection, time)
    if windowFunctions and mechDiff > 0 then
        -- Resize
        window_changeSize(math.floor(1280 / 2), math.floor(720 / 2))

        -- Not Full Screen and Can't zoom
        fullScreen = false
        canZoom = false

        -- Camera Zoom
        setProperty('camHUD.zoom', 1.5)
        setProperty('camGame.zoom', 1.25)

        -- Middle Scroll
        middleScroll(true, 0.001, 0.001, 'backOut')

        -- Fix Offset Y
        for i = 0,7 do
           noteTweenY('tween_'..i, i, defaultOpponentStrumY0 + 100, 0.0001, 'backOut')
        end

        -- Slower Notes
        triggerEvent('Change Scroll Speed', 0.825)

        -- Hide Health Bar
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
        setProperty('iconP1.visible', false)
        setProperty('iconP2.visible', false)

        -- Instant Offset
        doTweenY('bottom', 'window', 800, 0.001, 'linear')

        if mustHitSection == 'True' then
            doTweenX('left', 'window', (150 * 5), 0.001, 'linear')

            for i = 0,3 do
                noteTweenAlpha('Alpha0-'..i, i, 0, 0.0001, 'linear')
            end
            for i = 4,7 do
                noteTweenAlpha('Alpha1-'..i, i, 1, 0.0001, 'linear')
            end
        else
            doTweenX('left', 'window', -150, 0.001, 'linear')

            for i = 4,7 do
                noteTweenAlpha('Alpha2-'..i, i, 0, 0.0001, 'linear')
            end
            for i = 0,3 do
                noteTweenAlpha('Alpha3-'..i, i, 1, 0.0001, 'linear')
            end
        end

        -- Slowly go up
        doTweenY('tweenUp', 'window', 170, time, 'backOut')

        -- Fix for Downscroll
        if downscroll then
            fix = 115

            noteTweenY('Downscroll_Fix_0', 0, defaultOpponentStrumY0 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_1', 1, defaultOpponentStrumY1 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_2', 2, defaultOpponentStrumY2 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_3', 3, defaultOpponentStrumY3 - fix, 0.0001, 'linear')

            noteTweenY('Downscroll_Fix_4', 4, defaultPlayerStrumY0 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_5', 5, defaultPlayerStrumY1 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_6', 6, defaultPlayerStrumY2 - fix, 0.0001, 'linear')
            noteTweenY('Downscroll_Fix_7', 7, defaultPlayerStrumY3 - fix, 0.0001, 'linear')
        end
    end
end

function screenFix(time)
    if windowFunctions and mechDiff > 0 then
        -- Slowly go up
        doTweenY('tweenUp', 'window', 170, time, 'backOut')
        doTweenX('middle', 'window', (150 * 3), 0.001, 'linear')
    end
end

function splitScreenPrepare(time)
    if windowFunctions and mechDiff > 0 then
        -- Slowly go down
        doTweenY('tweenDown', 'window', 900, time, 'backIn')

        -- Camera Speed
        setProperty('cameraSpeed', 10)
    end
end

function onEvent(name, value1, value2)
    if windowFunctions and mechDiff > 0 then
        if name == 'Split Screen' then
            int = tonumber(value2)
            bool = value1

            runTimer('split', int, 1)

            if bool == 'True' then
                splitScreenPrepare(int)
            else
                splitScreenPrepare(int)
            end
        end

        if name == 'Screen Fix' then
            int = tonumber(value1)

            splitScreenPrepare(int)

            runTimer('fix', int, 1)
            runTimer('fullScreen', int, 1)
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if windowFunctions and mechDiff > 0 then
        if tag == 'split' then
            splitScreen(bool, int)
        end
        if tag == 'fix' then
            screenFix(int)
        end
        if tag == 'fullScreen' then
            -- Resize
            window_changeSize(math.floor(1280 * 2), math.floor(720 * 2))

            -- Reset Settings
            fullScreen = true
            canZoom = true

            window_fullScreen(true)
            window_setResizable(true)

            -- Camera Zoom Out
            setProperty('camHUD.zoom', 1)
            setProperty('camGame.zoom', 1)

            -- Normal Scroll
            middleScroll(false, 0.001, 0.001, 'backOut')

            -- Reset Offset Y
            for i = 0,7 do
                noteTweenY('tween_'..i, i, defaultOpponentStrumY0, 0.0001, 'backOut')
            end

            -- Faster Notes
            triggerEvent('Change Scroll Speed', 1)

            -- Show Health Bar
            setProperty('healthBar.visible', true)
            setProperty('healthBarBG.visible', true)
            setProperty('iconP1.visible', true)
            setProperty('iconP2.visible', true)

            -- Only the Player's notes are going to be visible
            for i = 4,7 do
                noteTweenAlpha('Alpha4-'..i, i, 1, 0.0001, 'linear')
            end
            for i = 0,3 do
                noteTweenAlpha('Alpha5-'..i, i, 0, 0.0001, 'linear')
            end
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Axe Note' and not isSustainNote then   
        width = 1280
        height = 720

        x = 0
        y = 0

        if mechDiff >= 2 then
            for i = 4,7 do
                if i == 4 then
                    x = math.random(100, math.floor(width / 3))

                    if downscroll then
                        y = math.random(math.floor(height / 2), height - 100)
                    else
                        y = math.random(0, 300)
                    end

                    setPropertyFromGroup('strumLineNotes', i, 'x', x)
                    setPropertyFromGroup('strumLineNotes', i, 'y', y)
                else
                    x = math.random(math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'x') + 50), math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'x') + 300))
                    y = math.random(math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'y') - 50), math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'y') + 50))

                    setPropertyFromGroup('strumLineNotes', i, 'x', x)
                    setPropertyFromGroup('strumLineNotes', i, 'y', y)
                end
            end
        end

        if mechDiff == 1 then
            if downscroll then
                y = math.random(math.floor(height / 2), height - 100)
            else
                y = math.random(0, 300)
            end

            for i = 4,7 do    
                if i == 4 then
                    x = math.random(100, math.floor(width / 4))

                    setPropertyFromGroup('strumLineNotes', i, 'x', x)
                    setPropertyFromGroup('strumLineNotes', i, 'y', y)
                else
                    x = math.random(math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'x') + 50), math.floor(getPropertyFromGroup('strumLineNotes', i - 1, 'x') + 300))

                    setPropertyFromGroup('strumLineNotes', i, 'x', x)
                    setPropertyFromGroup('strumLineNotes', i, 'y', y)
                end
            end
        end
    end
end

function middleScroll(middle, timeBF, timeOpponent, ease)
	if not middlescroll then
		if middle then
			noteTweenX('Note_Tween_0', 0, defaultPlayerStrumX0 - 322, timeOpponent, ease)
			noteTweenX('Note_Tween_1', 1, defaultPlayerStrumX1 - 322, timeOpponent, ease)
			noteTweenX('Note_Tween_2', 2, defaultPlayerStrumX2 - 322, timeOpponent, ease)
			noteTweenX('Note_Tween_3', 3, defaultPlayerStrumX3 - 322, timeOpponent, ease)

			noteTweenX('Note_Tween_4', 4, defaultPlayerStrumX0 - 322, timeBF, ease)
			noteTweenX('Note_Tween_5', 5, defaultPlayerStrumX1 - 322, timeBF, ease)
			noteTweenX('Note_Tween_6', 6, defaultPlayerStrumX2 - 322, timeBF, ease)
			noteTweenX('Note_Tween_7', 7, defaultPlayerStrumX3 - 322, timeBF, ease)
		else
			noteTweenX('Note_Tween_0', 0, defaultOpponentStrumX0, timeOpponent, ease)
			noteTweenX('Note_Tween_1', 1, defaultOpponentStrumX1, timeOpponent, ease)
			noteTweenX('Note_Tween_2', 2, defaultOpponentStrumX2, timeOpponent, ease)
			noteTweenX('Note_Tween_3', 3, defaultOpponentStrumX3, timeOpponent, ease)

			noteTweenX('Note_Tween_4', 4, defaultPlayerStrumX0, timeBF, ease)
			noteTweenX('Note_Tween_5', 5, defaultPlayerStrumX1, timeBF, ease)
			noteTweenX('Note_Tween_6', 6, defaultPlayerStrumX2, timeBF, ease)
			noteTweenX('Note_Tween_7', 7, defaultPlayerStrumX3, timeBF, ease)
		end
	else
		if middle then
			noteTweenX('Note_Tween_0', 0, defaultOpponentStrumX0 - (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_1', 1, defaultOpponentStrumX1 - (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_2', 2, defaultOpponentStrumX2 + (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_3', 3, defaultOpponentStrumX3 + (322 * 1), timeOpponent, ease)
		else
			noteTweenX('Note_Tween_0', 0, defaultOpponentStrumX0 + (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_1', 1, defaultOpponentStrumX1 + (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_2', 2, defaultOpponentStrumX2 - (322 * 1), timeOpponent, ease)
			noteTweenX('Note_Tween_3', 3, defaultOpponentStrumX3 - (322 * 1), timeOpponent, ease)
		end
	end
end