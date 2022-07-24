function onCreatePost()
    -- Initial Zoom
    setProperty('camHUD.zoom', 3)
    setProperty('camZooming', false)
end

function onStepHit()
    if curStep == 1 then
        -- Slowly Zoom Out
        doTweenZoom('slowZoomOut', 'camHUD', 1, 15.5, 'quadInOut')

		-- Middle Scroll
		middleScroll(true, 0.001, 0.001, 'backOut')
    end

    if curStep == 16 * 32 then
        -- Normal Scroll
		middleScroll(false, 1, 1, 'backOut')

		-- Note rotate
		for i = 0,7 do
			if i >= 4 then
				noteTweenAngle('angle'..i, i, 360 * -2, 1, 'easeInOut')
			else
				noteTweenAngle('angle'..i, i, 360 * -2, 2, 'easeInOut')
			end
		end
    end

    if curStep == 1792 then
        if flashingLights then
            cameraFlash('hud', 'FFFFFF', 2, true)
        end
    end
end

function onUpdate()
    -- Cam Zoom Control
    if curStep < 255 then
        setProperty('camZooming', false)
    end
    if curStep >= 256 then
        setProperty('camZooming', true)
    end
end

-- Midle scroll function bcs this is used a lot
function middleScroll(middle, timeBF, timeOpponent, ease)
	if not middlescroll then
		if middle then
			noteTweenX('Note_Tween_0', 0, defaultOpponentStrumX0 - (322 * 2), timeOpponent, ease)
			noteTweenX('Note_Tween_1', 1, defaultOpponentStrumX1 - (322 * 2), timeOpponent, ease)
			noteTweenX('Note_Tween_2', 2, defaultOpponentStrumX2 - (322 * 2), timeOpponent, ease)
			noteTweenX('Note_Tween_3', 3, defaultOpponentStrumX3 - (322 * 2), timeOpponent, ease)

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