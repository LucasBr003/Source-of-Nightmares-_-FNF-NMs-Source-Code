-- Making the last 4 sections before the drop easier bcs it's hell
function goodNoteHit()
	if curBeat >= 528 and curBeat <= 544 then
		setProperty('health', getProperty('health') + 0.0125)
	end
end

-- Hiding everything
function onStepHit()
	if curStep == 2560 then
		-- Screen Flash
		makeLuaSprite('flash', '', 0, 0);
		makeGraphic('flash', 1920, 1080, '0xFFFFFFFF');

		scaleObject('flash', 2, 2)
		setObjectCamera('flash', 'hud');

		if flashingLights then
			addLuaSprite('flash', true);
			doTweenAlpha('flashFade', 'flash', 0, 0.5, 'linear')
			runTimer('flashDelete', 0.5, 1)
		end

		setProperty('camHUD.visible', false)
		setProperty('camGame.visible', false)
	end
end

-- Removing the flash
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'flashDelete' then
		removeLuaSprite('flash', true)
	end
end