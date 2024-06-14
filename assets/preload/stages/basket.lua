function onCreate()
	makeLuaSprite('bg', 'basket/city_shit', -1100, -750)
	addLuaSprite('bg', false)
	makeLuaSprite('court', 'basket/floor', -1100, -750)
	addLuaSprite('court', false)

   	makeAnimatedLuaSprite('cassette', 'cd', 500, 600)
	addAnimationByPrefix('cassette', 'idle', 'boombox', 24, false);
	addLuaSprite('cassette', false)

	if stringStartsWith(dadName, 'darnell') then --Nene and Pico on bg
		makeAnimatedLuaSprite('fgChar1', 'basket/nene', -600, 660)
		setScrollFactor('fgChar1', 1.6, 1.2);
		addAnimationByPrefix('fgChar1', 'bop', 'nene bop', 24, false);
		scaleObject('fgChar1', 1.6, 1.6);
		addLuaSprite('fgChar1', true);

		makeAnimatedLuaSprite('fgChar2', 'basket/pico', 1500, 600)
		setScrollFactor('fgChar2', 1.9, 1.2);
		addAnimationByPrefix('fgChar2', 'bop', 'pico bop', 24, false);
		scaleObject('fgChar2', 1.6, 1.6);
		addLuaSprite('fgChar2', true);
	elseif stringStartsWith(dadName, 'pico') then --Darnell and Nene on bg
		makeAnimatedLuaSprite('fgChar1', 'basket/nene', 1500, 640)
		setScrollFactor('fgChar1', 1.9, 1.2);
		addAnimationByPrefix('fgChar1', 'bop', 'nene bop', 24, false);
		scaleObject('fgChar1', 1.6, 1.6);
		addLuaSprite('fgChar1', true);
		setProperty('fgChar1.flipX', true)

		makeAnimatedLuaSprite('fgChar2', 'basket/darnell', -600, 600)
		setScrollFactor('fgChar2', 1.7, 1.2);
		addAnimationByPrefix('fgChar2', 'bop', 'darnell bop', 24, false);
		scaleObject('fgChar2', 1.6, 1.6);
		addLuaSprite('fgChar2', true);
		setProperty('fgChar2.flipX', true)
	elseif stringStartsWith(dadName, 'nene') then --Darnell and Pico on bg
		makeAnimatedLuaSprite('fgChar1', 'basket/pico', 1500, 600)
		setScrollFactor('fgChar1', 1.9, 1.2);
		addAnimationByPrefix('fgChar1', 'bop', 'pico bop', 24, false);
		scaleObject('fgChar1', 1.6, 1.6);
		addLuaSprite('fgChar1', true);

		makeAnimatedLuaSprite('fgChar2', 'basket/darnell', -600, 600)
		setScrollFactor('fgChar2', 1.7, 1.2);
		addAnimationByPrefix('fgChar2', 'bop', 'darnell bop', 24, false);
		scaleObject('fgChar2', 1.6, 1.6);
		addLuaSprite('fgChar2', true);
		setProperty('fgChar2.flipX', true)
	end

	setPropertyFromClass('GameOverSubstate', 'characterName', 'skarlet-dead');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'deathDarnell');
end

local defaultNotePos = {}
local spin = 2

function onSongStart()
	for i = 0, 7 do
		defaultNotePos[i] = {
			getPropertyFromGroup('strumLineNotes', i, 'x'),
			getPropertyFromGroup('strumLineNotes', i, 'y')
		}
	end
end

function onUpdate(elapsed)
	if curStep >= 0 and curStep < 5000 then
		local songPos = getPropertyFromClass('Conductor', 'songPosition') / 1000 --How long it will take.
		setProperty("camHUD.angle", spin * math.sin(songPos))
	end

	if curStep >= 5000 then
		setProperty("camHUD.angle", 0)
	end
end

function onCountdownTick(counter)
	if counter % 2 == 0 then
		objectPlayAnimation('fgChar1', 'bop', true);
		objectPlayAnimation('fgChar2', 'bop', true);
	end
end

function onBeatHit()
	playAnim("cassette", "idle", true)

	if curBeat % 2 == 0 then
		objectPlayAnimation('fgChar1', 'bop', true);
		objectPlayAnimation('fgChar2', 'bop', true);
	end
end