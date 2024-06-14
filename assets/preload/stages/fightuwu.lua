function onCreate()
	makeLuaSprite('sky', 'sky bg', -2250, -1900)
	setScrollFactor('sky', 0.4, 0.4)
	scaleObject('sky', 1.5, 1.5)
	addLuaSprite('sky', false)

	makeLuaSprite('floor', 'floorr', -2250, -600)
	setScrollFactor('floor', 0.9, 0.9)
	scaleObject('floor', 2, 2)
	addLuaSprite('floor', false)
	
	-- it would be super corny if i did a lemon demon joke
	-- but fuck man
	makeLuaSprite('trucks', 'trucks', -400, 110)
	setScrollFactor('trucks', 0.8, 0.8)
	scaleObject('trucks', 1.1, 1.1)
	addLuaSprite('trucks', false)
end

local triggeredNycto = false
local intendZoom = 0
function onEvent(name, value1, value2)
	if name == 'Nycto Intro' then
		intendZoom = 0.72
		triggerEvent('Camera Follow Pos', getProperty('dad.x') - 80, getProperty('dad.y') + 250)
		doTweenZoom('camGamezoomtween', 'camGame', intendZoom, 2, 'quadInOut')
		doTweenAlpha('camHUDalphatween', 'camHUD', 0, 1, 'sineOut')
		setProperty('camZooming', false)

		makeLuaSprite('frkpnkblkbg', nil, -700, -1000)
		makeGraphic('frkpnkblkbg', 1, 1, '000000')
		scaleObject('frkpnkblkbg', 2500, 2500)
		setScrollFactor('frkpnkblkbg', 0, 0)
		setObjectOrder('frkpnkblkbg', getObjectOrder('gfGroup')+1)
		setProperty('frkpnkblkbg.alpha', 0)
		doTweenAlpha('frkpnkblkbgalphatween', 'frkpnkblkbg', 0.8, 3, 'sineOut')
		triggeredNycto = true
	end

	if triggeredNycto and name == 'Play Animation' then
		if value1 == 'three' or value1 == 'two' or value1 == 'one' then
			intendZoom = intendZoom + 0.06
			doTweenZoom('camGamezoomtween', 'camGame', intendZoom, 0.1, 'quadInOut')
			cameraShake('camGame', 0.03, 0.1)
			setProperty('camGame.angle', 0)
			if value1 == 'one' then
				setProperty('camGame.angle', -10)
			elseif value1 == 'two' then
				setProperty('camGame.angle', 10)
			end

			setProperty('camFollow.y', getProperty('camFollow.y') - 50)
			setProperty('camFollowPos.y', getProperty('camFollowPos.y') - 50)
		end
		if value1 == 'ascend' then
			setProperty('dad.skipDance', true)
			setProperty('dad.holdAnim', true)
			print("Stopped dance")
		end
	end
end

function opponentNoteHit()
	if triggeredNycto then
		triggerEvent('Camera Follow Pos', '', '')
		setProperty('dad.skipDance', false)
		setProperty('dad.holdAnim', false)
		doTweenAlpha('camHUDalphatween', 'camHUD', 1, 1, 'sineOut')
		doTweenAlpha('frkpnkblkbgalphatween', 'frkpnkblkbg', 0, 2, 'sineOut')
		triggeredNycto = false
	end
end


local ENDING_STATE_START = 0
local ENDING_STATE_JUMPSCARE = 1
local ENDING_STATE_PARRY = 2
local ENDING_STATE_END = 3

function brutalizeOpponent(state)
	setProperty('camZooming', false)
	setProperty('cameraSpeed', 1.4)
	if state == ENDING_STATE_START then
		triggerEvent('Camera Follow Pos', getProperty('dad.x') - 80, getProperty('dad.y') + 250)
		doTweenZoom('camGamezoomtween', 'camGame', 0.8, 0.5, 'quadInOut')
	elseif state == ENDING_STATE_JUMPSCARE then
		triggerEvent('Camera Follow Pos', getProperty('boyfriend.x') + 100, getProperty('dad.y') + 250)
		doTweenZoom('camGamezoomtween', 'camGame', 0.65, 0.5, 'quadInOut')
	elseif state == ENDING_STATE_PARRY then
		if flashingLights then
			makeLuaSprite('frkpnkwhibg', nil, -700, -1000)
			makeGraphic('frkpnkwhibg', 1, 1, 'FFFFFF')
			scaleObject('frkpnkwhibg', 2500, 2500)
			setScrollFactor('frkpnkwhibg', 0, 0)
			setObjectOrder('frkpnkwhibg', getObjectOrder('gfGroup')+1)
			runTimer('kill frkpnkwhibg', 0.05)
			cameraShake('camGame', 0.03, 0.1)
		end
		setProperty('strumLineNotes.visible', false)
		setProperty('notes.visible', false)
		setProperty('timeBar.visible', false)
		setProperty('timeBarBG.visible', false)
		setProperty('timeTxt.visible', false)
		setProperty('gf.stunned', true)
	elseif state == ENDING_STATE_END then
		cameraSetTarget('bf')
		setProperty('camFollowPos.x', getProperty('camFollow.x'))
		setProperty('camFollowPos.y', getProperty('camFollow.y'))
		runTimer('hide mora health', 0.1, 13)
		setProperty('battleSystem.healthBar.animation.curAnim.curFrame', 5)
	end
end

local calledHideMoraHealth = 0
function onTimerCompleted(tag, loopsElapsed, loopsLeft)
	if tag == 'kill frkpnkwhibg' then
		removeLuaSprite('frkpnkwhibg')
	elseif tag == 'hide mora health' then
		calledHideMoraHealth = calledHideMoraHealth + 1
		setProperty('battleSystem.healthBar.visible', (calledHideMoraHealth % 2 == 0))
		setProperty('battleSystem.healthIcon.visible', (calledHideMoraHealth % 2 == 0))
	end
end