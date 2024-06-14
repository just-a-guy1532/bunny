function atls(name, path, bgX, bgY, above)
	if above == nil then above = false end
	makeAnimatedLuaSprite(name, 'alleyway', bgX, bgY)
	addAnimationByPrefix(name, path, path, 0)
	setProperty(name..".active", false)
	addLuaSprite(name, above)
end

function onCreate()
	atls("sky", "skyy", -483, -310)
	setScrollFactor('sky', 0.1, 0.1)

	atls("bg", "background", -483, -310)

	atls("light", "light", -113, -310, true)
	setBlendMode('light', 'ADD')
	setProperty("light.alpha", 0.3)

	atls("trash", "trash", -383, 610, true)
	atls("bin", "bin", 783, 710, true)

	setScrollFactor('trash', 1.1, 1.1)
	setScrollFactor('bin', 1.1, 1.1)
end

function onCreatePost()
	setProperty("camFollowPos.x", getProperty("camFollow.x") - 25)
	setProperty("camFollowPos.y", getProperty("camFollow.y") - 25)

	close()
end