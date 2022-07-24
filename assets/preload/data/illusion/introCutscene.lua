-- Variables
local cutsceneState = 0;
local allowCountdown = false;
local flashState = 0;

function onStartCountdown()
	if not seenCutscene and cutsceneState == 0 and showCutscene then
		allowCountdown = true
		cutsceneState = 1
	
		setProperty('inCutscene', true)
		setProperty('camGame.alpha', 0)
	
		startDialogue('dialogue', '')
	
		return Function_Stop
	else
		setProperty('seenCutscene', true)
		setProperty('inCutscene', false)
		setProperty('camHUD.zoom', 3)

		return Function_Continue
	end
end

function onDialogueEnd()
	doTweenAlpha('camShow', 'camGame', 1, 0.75, 'linear')
	doTweenZoom('camOut', 'camHUD', 1, 3, 'quadInOut')

	startCountdown()
end