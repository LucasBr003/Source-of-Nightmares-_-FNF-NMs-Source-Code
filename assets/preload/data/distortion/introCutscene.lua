-- Variables
local cutsceneState = 0;
local allowCountdown = false;
local flashState = 0;

function onStartCountdown()
	if cutsceneState == 0 and showCutscene then
		startDialogue('dialogue', '');
		setProperty('camGame.visible', false);

		cutsceneState = 1

		return Function_Stop;
	end
end

function onDialogueEnd()
	jumpscare()
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startCount' then
		doTweenZoom('camZoomOut', 'camHUD', 1, 2.5, 'quadInOut')

		setProperty('seenCutscene', true)
	end

	if tag == 'zoomOut' then
		doTweenZoom('camZoomOut', 'camGame', 0.95, 2.5, 'quadInOut')
	end

	if tag == 'camFade' then
		doTweenAlpha('camHide', 'camGame', 0, 0.75, 'linear')
	end

	if tag == 'toInst' then
		instructions()
	end

	if tag == 'update' then
		cutsceneState = 4
	end

	if tag == 'instFlash' and flashingLights then
		if flashState == 0 then
			doTweenAlpha('instHide'..loopsLeft, 'inst', 0, 0.000001, 'linear')
			flashState = 1
		else
			doTweenAlpha('instHide'..loopsLeft, 'inst', 1, 0.000001, 'linear')
			flashState = 0
		end

		if loopsLeft == 0 then
			doTweenAlpha('instHide'..loopsLeft, 'inst', 0, 0.000001, 'linear')
		end
 	end

	if tag == 'endCutscene' then
		doTweenAlpha('camShow', 'camGame', 1, 0.75, 'linear')
		doTweenZoom('camOut', 'camHUD', 1, 3, 'quadInOut')

		startCountdown()

		cutsceneState = 6
		close(true);
		return Function_Continue;
	end
end

function jumpscare()
	if cutsceneState == 1 then
		setProperty('inCutscene', true)
		setProperty('camGame.visible', true);

		setProperty('camGame.zoom', 0.95)
		setProperty('camHUD.zoom', 3.5)

		doTweenZoom('camFirstIn', 'camGame', 1.2, 0.45, 'quadInOut')

		runTimer('zoomOut', 0.6)
		runTimer('camFade', 3.35);
		runTimer('toInst', 4.75);

		playSound('Lights_Turn_On', jumpscareVolume, 'jumpscareSound')

		allowCountdown = true
		cutsceneState = 2

		return Function_Stop;
	end
end

function instructions()
	-- Black Thing but HUD
	makeLuaSprite('inst', 'nightMall/nightInstructions', 0, 0);
	setScrollFactor('inst', 0, 0);
	scaleObject('inst', 1, 1);

	setObjectCamera('inst', 'other')

	addLuaSprite('inst', true);
	doTweenAlpha('instHide', 'inst', 0, 0.000001, 'linear')
	doTweenAlpha('instShow', 'inst', 1, 1.25, 'linear')

	runTimer('update', 1.3)

	cutsceneState = 3
end

function onUpdate()
	if showCutscene then
		if keyJustPressed('accept') and cutsceneState == 4 then
			playSound('confirmMenu', 1, 'accept')
			runTimer('instFlash', 0.08, 20)
			runTimer('endCutscene', 2, 1)

			cutsceneState = 5
		end
	end
end