-- Variables
directions = {'left', 'down', 'up', 'right'}

animations = {'arrow', 'press', 'confirm'}

offsetX_eachNote = 153
offsetX_eachStrum = (offsetX_eachNote * 4) + 22

confirmOffset = {-22, -27, -26, -22, 
		-22, -25.0, -22, -22}

pressOffset = 	{4.5, 2, 1, 2,
		 4.0, 2, 2, 1}

startingX = -74
strumY = 0

noteSize = 0.65

strums = 0

opponentPrefix = 'opponent'
extraPrefix = 'hank'
playerPrefix = 'player'

originalX = {}
originalY = {}

local noteOffset = 3

canGhostTap = {true, true, true, true}

function onBeatHit()
	if curBeat == 124 and songName == 'Magma' then
		strumY = defaultPlayerStrumY0

		-- Hiding the original strums
		for i = 0,7 do
			noteTweenAlpha('note_hide_'..i, i, 0, 0.0001, 'linear')
		end

		-- Creating the new strums
		createStrumLine(opponentPrefix)
		createStrumLine(extraPrefix)
		createStrumLine(playerPrefix)

		-- Screen Flash
		if flashingLights then
			cameraFlash('hud', 'FFFFFF', 1, true)
		end
	end
end

function createStrumLine(prefix)
	for i = 1,4 do
		-- Variables
		strumName = prefix..'Strum_'..i
		idlePrefix = animations[1]..directions[i]:upper()
		pressPrefix = directions[i]..' '..animations[2]
		confirmPrefix = directions[i]..' '..animations[3]

		x = (startingX + (offsetX_eachNote * i) * noteSize) + ((offsetX_eachStrum * strums) * noteSize)

		-- Fuck downscroll
		if downscroll then
			strumY = 365
		end

		-- Making the Strum Sprite
		makeAnimatedLuaSprite(strumName, 'LUANOTE_assets', x, strumY)

		addAnimationByPrefix(strumName, 'static', idlePrefix, 24, false)
		addAnimationByPrefix(strumName, 'press', pressPrefix, 24, false)
		addAnimationByPrefix(strumName, 'confirm', confirmPrefix, 24, false)

		objectPlayAnimation(strumName, 'static', false)

		setObjectCamera(strumName, 'hud')
		scaleObject(strumName, noteSize, noteSize)
		setObjectOrder(strumName, getObjectOrder('lane') + 1)
		updateHitbox(strumName)

		-- Tweeing the original notes
		if prefix == opponentPrefix then
			noteTweenX(prefix..'Fix_'..i, i - 1, x - noteOffset, 0.0001, 'linear')
		end
		if prefix == playerPrefix then
			noteTweenX(prefix..'Fix_'..i + 3, i + 3, x - noteOffset, 0.0001, 'linear')
		end

		-- Adding It
		addLuaSprite(strumName, false)

		-- Saving some info
		table.insert(originalX, x)
		table.insert(originalY, strumY)
	end

	-- Adding 1 to the strum counter
	strums = strums + 1
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if songName == 'Magma' then
		-- Animation Play
		playAnimation(opponentPrefix, 1, noteData)
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if songName == 'Magma' then
		-- Ghost Tap
		canGhostTap[noteData + 1] = false

		if noteType == '' then
			-- Animation Play
			playAnimation(playerPrefix, 9, noteData)

			-- Reset Timer
			timerName = 'resetAnim_'..noteData + 8
			cancelTimer(timerName)
		else
			-- Animation Play
			playAnimation(extraPrefix, 5, noteData)

			-- Reset Timer
			timerName = 'resetAnim_'..noteData + 4
			cancelTimer(timerName)
		end

		if noteType == 'Extra Strum Note' then
			triggerEvent('Play Animation', 'sing'..directions[noteData + 1]:upper(), 'gf')
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- Opponent Resets
	if tag == 'resetAnim_0' then resetAnim(1, opponentPrefix, 0) end
	if tag == 'resetAnim_1' then resetAnim(2, opponentPrefix, 0) end
	if tag == 'resetAnim_2' then resetAnim(3, opponentPrefix, 0) end
	if tag == 'resetAnim_3' then resetAnim(4, opponentPrefix, 0) end

	-- Extra Resets
	if tag == 'resetAnim_4' then resetAnim(1, extraPrefix, 4) end
	if tag == 'resetAnim_5' then resetAnim(2, extraPrefix, 4) end
	if tag == 'resetAnim_6' then resetAnim(3, extraPrefix, 4) end
	if tag == 'resetAnim_7' then resetAnim(4, extraPrefix, 4) end

	-- Player Resets
	if tag == 'resetAnim_8' then resetAnim(1, playerPrefix, 8) end
	if tag == 'resetAnim_9' then resetAnim(2, playerPrefix, 8) end
	if tag == 'resetAnim_10' then resetAnim(3, playerPrefix, 8) end
	if tag == 'resetAnim_11' then resetAnim(4, playerPrefix, 8) end
end

function resetAnim(strumID, prefix, extra)
	-- Making variables to make things easier
	strumName = prefix..'Strum_'..strumID

	-- Reseting
	objectPlayAnimation(strumName, 'static', true)

	-- Offsets
	setPropertyLuaSprite(strumName, 'x', originalX[strumID + extra])
	setPropertyLuaSprite(strumName, 'y', originalY[strumID + extra])
end

function playAnimation(prefix, add, noteData)
	-- Making variables to make things easier
	strumName = prefix..'Strum_'..noteData + 1

	-- Confirm Animation
	objectPlayAnimation(strumName, 'confirm', true)

	-- Offsets
	setPropertyLuaSprite(strumName, 'x', originalX[noteData + add] + confirmOffset[noteData + 1])
	setPropertyLuaSprite(strumName, 'y', originalY[noteData + add] + confirmOffset[noteData + 5])

	-- Reset Timer
	if prefix == opponentPrefix then
		timerName = 'resetAnim_'..noteData + (add - 1)

		cancelTimer(timerName)
		runTimer(timerName, 0.16, 1)
	end
end
	
function onStepHit()
	if songName == 'Magma' then
		for i = 1,4 do
			-- Animation
			if canGhostTap[i] and keyPressed(directions[i]) then
				-- Ghost Tap Notes

				-- Variables, Of course
				strumName = playerPrefix..'Strum_'..i
				-- Animation
				objectPlayAnimation(strumName, 'press', false)
				-- Offsets
				setPropertyLuaSprite(strumName, 'x', originalX[i + 8] + pressOffset[i])
				setPropertyLuaSprite(strumName, 'y', originalY[i + 8] + pressOffset[i + 4])

				-- More Variables
				strumName = extraPrefix..'Strum_'..i
				-- More Animation
				objectPlayAnimation(strumName, 'press', false)
				-- Offsets
				setPropertyLuaSprite(strumName, 'x', originalX[i + 4] + pressOffset[i])
				setPropertyLuaSprite(strumName, 'y', originalY[i + 4] + pressOffset[i + 4])
			end

			-- Reset Timer
			timerName = 'resetAnim_'..(i - 1) + 8
			if not keyPressed(directions[i]) then
				canGhostTap[i] = true

				runTimer(timerName, 0.001, 1)
			else
				cancelTimer(timerName)
			end

			timerName = 'resetAnim_'..(i - 1) + 4
			if not keyPressed(directions[i]) then
				canGhostTap[i] = true

				runTimer(timerName, 0.001, 1)
			else
				cancelTimer(timerName)
			end
		end

		-- Hank Zoom
		if gfSection then
			setProperty('defaultCamZoom', 1.15)
		else
			setProperty('defaultCamZoom', 0.75)
		end
	end
end

function onCreatePost()
	-- Some Notes Config
	setProperty('globalCopyAlpha', false)
	setProperty('globalNoteSize', noteSize)

	-- Only run this script on Magma
	if not songName == 'Magma' then
		close(false)
	end
end