local amountOfSteps = 450
local signPass = {}

function onCreate()
	addHaxeLibrary('BGSprite', '')
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display')
	addHaxeLibrary("VarTween", "flixel.tweens.misc")

	runHaxeCode([[
		var game = PlayState.instance;
		var position = game.members.indexOf(game.gfGroup)-1;

		var add = function(object){
			game.insert(position, object);
			position++;
		}


		//streetstyle
		var sky = new BGSprite('outside/sky', 'philly', -225, -404, 0.2, 0.2);
		sky.scale.set(1.15, 1.15);
		sky.updateHitbox();
		sky.velocity.x -= 1;
		sky.active = true;
		add(sky);

		var farbuildings = new FlxBackdrop(Paths.image('outside/far buildings', 'philly'), 1, 1, true, false);
		farbuildings.y = -504;
		farbuildings.velocity.x -= 800;
		farbuildings.antialiasing = ClientPrefs.globalAntialiasing;
		add(farbuildings);

		var buildings = new FlxBackdrop(Paths.image('outside/buildings', 'philly'), 1, 1, true, false);
		buildings.x = -1137;
		buildings.y = -334;
		buildings.velocity.x -= 2250;
		buildings.antialiasing = ClientPrefs.globalAntialiasing;
		add(buildings);

		var darkbuildings = new FlxBackdrop(Paths.image('outside/buildings darker', 'philly'), 1, 1, true, false);
		darkbuildings.x = 500;
		darkbuildings.y = -250;
		darkbuildings.velocity.x -= 2500;
		darkbuildings.antialiasing = ClientPrefs.globalAntialiasing;
		add(darkbuildings);

		var poles = new FlxBackdrop(Paths.image('outside/poles', 'philly'), 1, 1, true, false);
		poles.y = 444;
		poles.velocity.x -= 3000;
		poles.antialiasing = ClientPrefs.globalAntialiasing;
		add(poles);

		var tricky_ad = new BGSprite('outside/ad_tricky', 'philly', 3500, 234);
		add(tricky_ad);
		setVar("ad", tricky_ad);

		var train = new BGSprite('outside/train', 'philly', -250, 500, 1, 1);
		train.scale.set(1.25, 1.25);
		train.updateHitbox();
		add(train);

		//streetstyle
		var wallX = 343;
		var tunnelWall = new BGSprite('tunnel/wall2', 'philly', -325, -320, 0.9, 0.9);
		tunnelWall.active = true;
		tunnelWall.scale.set(5, 5);
		tunnelWall.updateHitbox();
		setVar("tunnelWall", tunnelWall);
		add(tunnelWall);
		tunnelWall.visible = false;

		var tunnelWallOverlay = new BGSprite('tunnel/walloverlay', 'philly', -1000, -320, 0.9, 0.9);
		tunnelWallOverlay.active = true;
		tunnelWallOverlay.scale.set(4.0, 4.0);
		tunnelWallOverlay.updateHitbox();
		tunnelWallOverlay.velocity.x -= 7500;
		setVar("tunnelWallOverlay", tunnelWallOverlay);
		add(tunnelWallOverlay);
		tunnelWallOverlay.visible = false;
		
		var arr = [];
		for (i in 0...2)
		{
			var light = new BGSprite('tunnel/light', 'philly', 200 + 2050 * i, 380, 0.9, 0.9);
			light.scale.set(1.4, 1.4);
			light.updateHitbox();
			light.active = true;
			light.velocity.x -= 7500;
			light.visible = false;
			add(light);
			arr.push(light);
		}
		setVar("tunnelLights", arr);

		var tunnelTrain = new BGSprite('tunnel/train', 'philly', train.x, train.y, 1, 1);
		tunnelTrain.scale.set(1.25, 1.25);
		tunnelTrain.updateHitbox();
		setVar("tunnelTrain", tunnelTrain);
		add(tunnelTrain);
		tunnelTrain.visible = false;

		var tunnelTrans = new BGSprite('tunnel/wall', 'philly', wallX, -320, 0, 0);
		tunnelTrans.active = true;
		tunnelTrans.velocity.x -= 12000;
		game.add(tunnelTrans);
		setVar("tunnelTrans", tunnelTrans);
		tunnelTrans.visible = false;
	]])

	makeAnimatedLuaSprite('dropBg', 'tunnel/dropbg', -600, -400);
	scaleObject('dropBg', 2.2, 2.2);
	addAnimationByPrefix('dropBg', 'idle', 'tunnel loop', 24, true);
	setScrollFactor('dropBg', 0.1, 0.1);
	setObjectOrder('dropBg', getObjectOrder('dadGroup')-1);
	screenCenter('dropBg')
	setProperty('dropBg.visible', false);
	
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-streetstyle-dead');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'deathStreetstyle');
end

function onUpdate(elapsed)
	runHaxeCode([[
		var tunnelWallOverlay = getVar("tunnelWallOverlay");
		var arr = getVar("tunnelLights");
		if(tunnelWallOverlay.x < -2728)
		{
			tunnelWallOverlay.x += 2728;
		}

		for (obj in arr)
		{
			if(obj.x < -1000) obj.x += 4100;
		}
	]]);

	if transitionback then
		runHaxeCode([[
			var tunnelWall = getVar("tunnelWall");
			var tunnelWallOverlay = getVar("tunnelWallOverlay");
			var tunnelTrans = getVar("tunnelTrans");
			if (tunnelTrans.x <= -tunnelTrans.width)
			{
				tunnelTrans.visible = false;
			}
			else if (tunnelTrans.x < -200)
			{
				tunnelWall.visible = false;
				tunnelWallOverlay.visible = false;
				getVar("tunnelTrain").visible = false;
				PlayState.instance.boyfriendGroup.visible = true;
				PlayState.instance.triggerEventNote('Change Character', 'boyfriend', PlayState.SONG.player1);
				PlayState.instance.triggerEventNote('Change Character', 'dad', PlayState.SONG.player2);
				for (obj in getVar("tunnelLights"))
				{
					obj.visible = false;
				}
			}
		]]);

		if boyfriendName == 'bf-epic' and getProperty('boyfriendGroup.visible') then
			transitionback = false;
			onthedrop = false;
			ontunnel = false;
			setProperty('dropBg.visible', false);
		end
	elseif ontunnel then
		runHaxeCode([[
			var tunnelTrans = getVar("tunnelTrans");
			if(tunnelTrans.x < 200 && PlayState.instance.boyfriend.curCharacter != 'bf-graffiti')
			{
				PlayState.instance.triggerEventNote('Change Character', 'boyfriend', 'bf-graffiti');
				PlayState.instance.triggerEventNote('Change Character', 'dad', 'skarlet-graffiti');
				PlayState.instance.modchartSprites.get('dropBg').visible = false;
				PlayState.instance.boyfriendGroup.visible = true;
				getVar("tunnelWall").visible = true;
				getVar("tunnelWallOverlay").visible = true;
				getVar("tunnelTrain").visible = true;
				for (obj in getVar("tunnelLights"))
				{
					obj.visible = true;
				}
			}
		]]);
	elseif onthedrop then
		runHaxeCode([[
			var tunnelTrans = getVar("tunnelTrans");
			if(tunnelTrans.x < 200 && PlayState.instance.dad.curCharacter != 'skarlet-drop')
			{
				PlayState.instance.triggerEventNote('Change Character', 'dad', 'skarlet-drop');
			}
		]]);

		if getProperty('dad.curCharacter') == 'skarlet-drop' then --on da drop
			setProperty('cameraSpeed', 2);
			setProperty('dropBg.visible', true);
			setProperty('boyfriendGroup.visible', false);
		end
	end
end

local MIN_TIME = 95
function onCreatePost()
	--songTime = getProperty("vocals.length")
	time = getRandomInt(10,amountOfSteps)
	table.insert(signPass, time)
	if getRandomBool(50) then
		adtime = getRandomInt(10,amountOfSteps)
		while (adtime-MIN_TIME <= time and adtime+MIN_TIME >= time) do
			adtime = getRandomInt(10,amountOfSteps)
			break
		end
		table.insert(signPass, adtime)
	end
end

--[[
	im required to do this because
	when i try to manually add a tween to modchartTweens in PlayState
	it doesn't and does work at the same time

	(it doesnt work ingame)
	(but works in hscript)
]]--

function onPause()
	runHaxeCode([[
		getVar("adTween").active = false;
	]])
end

function onResume()
	runHaxeCode([[
		getVar("adTween").active = true;
	]])
end

function onStepHit()
	for _,step in ipairs(signPass) do
		if curStep == step then
			runHaxeCode([[
				var ad = getVar("ad");
				setVar("adTween", FlxTween.tween(ad, {x:-2500}, 1, {onComplete:function(twn){
					ad.x = 3500;
				}}));
			]])
		end
	end
end

onthedrop = false;
ontunnel = false;
transitionback = false;
function onEvent(name, value1, value2)
	if name == 'Streetstyle Neon' then
		transitionback = false;
		setProperty('cameraSpeed', 1);
		val1 = math.floor(tonumber(value1));
		if val1 < 1 then
			if ontunnel or onthedrop then
				runHaxeCode([[
					getVar('tunnelTrans').x = FlxG.width;
				]])
				transitionback = true;
			end
		end

		if not transitionback then
			runHaxeCode([[
				getVar("tunnelWall").visible = false;
				getVar("tunnelWallOverlay").visible = false;
				getVar("tunnelTrans").visible = false;
				for (obj in getVar("tunnelLights"))
				{
					obj.visible = false;
				}
			]]);
			onthedrop = false;
		end
		ontunnel = false;

		if val1 == 1 then
			ontunnel = true;
			runHaxeCode([[
				var tunnelWall = getVar("tunnelWall");
				var tunnelWallOverlay = getVar("tunnelWallOverlay");
				var tunnelTrans = getVar("tunnelTrans");
				tunnelWall.visible = true;
				tunnelWallOverlay.visible = true;
				tunnelTrans.visible = true;
				for (obj in getVar("tunnelLights"))
				{
					obj.visible = true;
				}

				var posX = 2600;
				tunnelTrans.x = FlxG.width;
			]]);
		elseif val1 == 2 then
			onthedrop = true;
			runHaxeCode([[
				var tunnelTrans = getVar("tunnelTrans");
				tunnelTrans.visible = true;
				tunnelTrans.x = FlxG.width;
				if(ClientPrefs.cutscenes) tunnelTrans.x -= 5000;
			]]);
		end
	end
end

function onMoveCamera(focus)
	if onthedrop then
		cameraSetTarget('dad');
	end
end