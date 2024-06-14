local bopInterval = 1

function onCreate()
	makeLuaSprite('bg', 'background', -380, -417)
	setScrollFactor('bg', 0.9, 0.9);
	addLuaSprite('bg', false)

	makeAnimatedLuaSprite('bump1', 'boppers_left', 180, 216)
	addAnimationByPrefix('bump1','bumpin','bop',24,false)
	objectPlayAnimation('bump1','bumpin',false)
	setScrollFactor('bump1', 0.9, 0.9);
	addLuaSprite('bump1', false)

	makeAnimatedLuaSprite('bump2', 'boppers_right', 950, 175)
	addAnimationByPrefix('bump2','bumpin','bop',24,false)
	objectPlayAnimation('bump2','bumpin',false)
	setScrollFactor('bump2', 0.9, 0.9);
	addLuaSprite('bump2', false)

	makeLuaSprite("trainPlacement", nil)
	setProperty("trainPlacement.exists", false)
	addLuaSprite('trainPlacement', false)

	makeLuaSprite('floor', 'floorground', -500, -322)
	addLuaSprite('floor', false)

	makeAnimatedLuaSprite('bump_front', 'foreground boppers', -450, 691)
	addAnimationByPrefix('bump_front','bumpin','foreground bop',24,false)
	objectPlayAnimation('bump_front','bumpin',false)
	setScrollFactor('bump_front', 0.9, 0.9);
	addLuaSprite('bump_front', true)

	--close()
	if songPath == "soda-pop" then
		bopInterval = 2
	end
end


function onBeatHit()
	if curBeat % bopInterval == 0 then
		objectPlayAnimation('bump1', 'bumpin', true)
		objectPlayAnimation('bump2', 'bumpin', true)
		objectPlayAnimation('bump_front', 'bumpin', true)
	end
end