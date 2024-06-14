function onCreate()
	addHaxeLibrary('Character');
	runHaxeCode([[
		game = PlayState.instance;
		pump = new Character(game.dad.x + 230, game.dad.y - 80, 'pump');
		game.insert(game.members.indexOf(game.dadGroup) - 1, pump);

		function isLooking(char) {
			return char.animation.name == "look" || char.animation.name == "idle-alt";
		}
	]]);
end

function onCreatePost()
	runHaxeCode([[
		skid = game.dad;
	]]);
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	note = 'notes.members['..id..']';
	if noteType == 'Alt Character' or noteType == 'Both Characters' then
		anim = getProperty('singAnimations['..direction..']');
		runHaxeCode([[
			//if(isLooking(pump)) {
				pump.idleSuffix = "";
			//}
			pump.holdTimer = 0;
			pump.playAnim(']]..anim..[[', true);
		]]);
	end

	if noteType == "Both Characters" then
		runHaxeCode([[
			skid.idleSuffix = "";
		]])
	end
end

function onEvent(name, val1, val2)
	if name == "Skid Pump Looking" then
		if val1 == "0" then
			runHaxeCode([[
				if(isLooking(skid)) {
					skid.playAnim("look2idle", true);
					skid.specialAnim = true;
					skid.idleSuffix = "";
				}
				if(isLooking(pump)) {
					pump.playAnim("look2idle", true);
					pump.specialAnim = true;
					pump.idleSuffix = "";
				}
			]])
		elseif val1 == "1" then
			runHaxeCode([[
				if(!isLooking(skid)) {
					skid.playAnim("look", true);
					skid.specialAnim = true;
					skid.idleSuffix = "-alt";
				}
				if(isLooking(pump)) {
					pump.playAnim("look2idle", true);
					pump.specialAnim = true;
					pump.idleSuffix = "";
				}
			]])
		elseif val1 == "2" then
			runHaxeCode([[
				if(isLooking(skid)) {
					skid.playAnim("look2idle", true);
					skid.specialAnim = true;
					skid.idleSuffix = "";
				}
				if(!isLooking(pump)) {
					pump.playAnim("look", true);
					pump.specialAnim = true;
					pump.idleSuffix = "-alt";
				}
			]])
		elseif val1 == "3" then
			runHaxeCode([[
				if(!isLooking(skid)) {
					skid.playAnim("look", true);
					skid.specialAnim = true;
					skid.idleSuffix = "-alt";
				}
				if(!isLooking(pump)) {
					pump.playAnim("look", true);
					pump.specialAnim = true;
					pump.idleSuffix = "-alt";
				}
			]])
		end
	end
end

function onCountdownTick(counter)
	if counter % 2 == 0 then
		pumpDance();
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		if not getProperty('inCutscene') then
			runHaxeCode([[
				singing = StringTools.startsWith(pump.animation.curAnim.name, 'sing');
				if((singing && pump.holdTimer > Conductor.stepCrochet * 0.0011 * pump.singDuration) || !singing)
				{
					pump.dance();
				}
			]]);
		end
	end
end

function pumpDance()
	if not getProperty('inCutscene') then
		runHaxeCode([[
			pump.dance();
		]]);
	end
end