


function love.load()
--dialogue and object descriptions
require("scripts/dialogue")
--editor for creating new maps
require("scripts/editor")
--code for navigating between maps
require("scripts/drawfunctions")
--json for map files
json = require("json")


--map
	gridsize = 16
	debugView = 0
	infoView = 0
	mapExists = 0
	locationTriggers = {
										overworld = {
											{6*gridsize, 9*gridsize, "gardeningShed", 6*gridsize, 12*gridsize},
											{18*gridsize, 9*gridsize, "clinic", 4*gridsize, 10*gridsize}},
										gardeningShed = {
											{6*gridsize, 13*gridsize, "overworld", 6*gridsize, 10*gridsize}}
									}
	currentLocation = "overworld"
	mapPath = {overworld = {"C:\\Users\\Carolyn\\Documents\\GitHub\\Utopia\\utopia\\scripts\\map.txt",
	"C:\\Users\\Carolyn\\Documents\\GitHub\\Utopia\\utopia\\maps\\map1.txt"},
	gardeningShed = {"C:\\Users\\Carolyn\\Documents\\GitHub\\Utopia\\utopia\\scripts\\map.txt",
	"C:\\Users\\Carolyn\\Documents\\GitHub\\Utopia\\utopia\\maps\\map2.txt"}
}

	mapFile1 = nil
	mapFile2 = nil
--characters
	player = {
		grid_x = 8*gridsize,
		grid_y = 17*gridsize,
		act_x = 8*gridsize,
		act_y = 17*gridsize,
		speed = 32,
		canMove = 1,
		moveDir = 0,
		threshold = 0,
		facing = 2,
		name = ""
	}

	npcs = {{
		grid_x = 5*gridsize,
		grid_y = 10*gridsize,
		act_x = 5*gridsize,
		act_y = 10*gridsize,
		speed = 30,
		canMove = 0,
		moveDir = 0,
		threshold = 0,
		facing = 1,
		start = 1, --direction facing when starting
		location = "overworld",
		dialogue = 0,
		name = "Grape",
		animationkey = 5, -- where animations start
		n = 1, --stage in single conversation
		c = 1}, -- dialogue case
		{
			grid_x = 9*gridsize,
			grid_y = 21*gridsize,
			act_x = 9*gridsize,
			act_y = 21*gridsize,
			speed = 30,
			canMove = 0,
			moveDir = 0,
			threshold = 0,
			facing = 1,
			start = 2,
			location = "overworld",
			dialogue = 0,
			name = "Lark",
			animationkey = 9, -- where animations start
			n = 1, --stage in single conversation
			c = 1} -- dialogue case
}


--objects
objects = {
	{7, 11, "GardeningSign"},
	{7, 18, "KitchenSign"},
	{17, 10, "ClinicSign"},
	{10, 8, "Cauliflower"},
	{12, 8, "Cauliflower2"},
	{18, 16, "RepairSign"},
	{25, 15, "GlassSign"},
	{31, 15, "WoodworkingSign"},
	{36, 14, "MuseumSign"},
 	{28, 25, "DormitorySign"},
	{36, 24, "LibrarySign"},
	{40, 24, "ScienceSign"},
	{23, 33, "GatheringSign"},
	{33, 30, "StationSign"},
	{28, 17, "RainbowArt"},
	{27, 13, "GenderArt"}
}
--images
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setColor(0, 0, 0)
	love.graphics.setBackgroundColor(255,255,255)


	bg = {overworld = love.graphics.newImage("images/utopiabg.png"),
				gardeningShed = love.graphics.newImage("images/utopia_gardeningshedbg.png")}
	currentBackground = bg.overworld

	spritesheet1 = love.graphics.newImage("images/utopia.png")
	animsheet1 = love.graphics.newImage("images/utopia_anim.png")
	ui = {arrowright = love.graphics.newImage("images/utopiaui_0.png"),
		arrowdown = love.graphics.newImage("images/utopiaui_5.png"),
		pressz = love.graphics.newImage("images/utopiaui_6.png")
		}
	toptiles = {gardeningShed = love.graphics.newImage("images/utopia_toptiles_0.png")}

--spritesheet, number of tiles in animation, starting position, length, width, height, duration
	animations = {{newAnimation(animsheet1, 0, 4, 16, 16, .6), "player.walkup"},
				 {newAnimation(animsheet1, 1*16, 4, 16, 16, .6), "player.walkdown"},
				 {newAnimation(animsheet1, 2*16, 4, 16, 16, .65), "player.walkleft"},
				 {newAnimation(animsheet1, 3*16, 4, 16, 16, .65), "player.walkright"},
			 	 {newAnimation(animsheet1, 4*16, 4, 16, 16, .6 ), "npcs[1].walkup"},
			   {newAnimation(animsheet1, 5*16, 4, 16, 16, .6 ), "npcs[1].walkdown"},
			 	 {newAnimation(animsheet1, 6*16, 4, 16, 16, .65 ), "npcs[1].walkleft"},
				 {newAnimation(animsheet1, 7*16, 4, 16, 16, .65 ), "npcs[1].walkright"},
				 {newAnimation(animsheet1, 8*16, 4, 16, 16, .6 ), "npcs[2].walkup"},
				 {newAnimation(animsheet1, 9*16, 4, 16, 16, .6 ), "npcs[2].walkdown"},
				 {newAnimation(animsheet1, 10*16, 4, 16, 16, .65 ), "npcs[2].walkleft"},
				 {newAnimation(animsheet1, 11*16, 4, 16, 16, .65 ), "npcs[2].walkright"}
			 }

--dialogue
	font = love.graphics.setNewFont("fonts/pixel.ttf", 8)
	dialogueMode = 0
	choice = {mode = 0, pos = 1, total = 1, name = "", more = 0}
	text = nil

--timer for blinking text/images
	timer = {base = .5, current = 0, trigger = 0}


--generate map
local mapFile1 = mapPath.overworld[1]
local mapFile2 = mapPath.overworld[2]
mapGen (bg.overworld, mapFile1, mapFile2)


	--table.save(initTable, "D:\\my game projects\\utopia\\scripts\\initTable.lua")
end

--generate new maps or load old ones for each area
function locationMaps()
	if currentLocation == "overworld" then
		mapFile1 = mapPath.overworld[1]
		mapFile2 = mapPath.overworld[2]
		print(currentLocation)
		mapGen (bg.overworld, mapFile1, mapFile2)
	elseif currentLocation == "gardeningShed" then
		mapFile1 = mapPath.gardeningShed[1]
		mapFile2 = mapPath.gardeningShed[2]
		print(currentLocation)
		mapGen (bg.gardeningShed, mapFile1, mapFile2)
	end
end

--change location and map to match new location
function changeMap(px, py, tbl)
  for i = 1, #tbl do
    if px == tbl[i][1] and py == tbl[i][2] then
      currentLocation = tbl[i][3]
      locationMaps()
			changeBackground(currentLocation)
			player.grid_x = tbl[i][4]
			player.act_x = player.grid_x
			player.grid_y = tbl[i][5]
			player.act_y = player.grid_y
			print(currentLocation)
    end
  end
end

--change background to match location
function changeBackground(l)
	currentBackground = bg[l]
end

function love.update(dt)
	if timer.current > 0 then
		timer.current = timer.current - dt
	else
		if timer.trigger == 0 then
			timer.trigger = 1
		else
		 timer.trigger = 0
		end
		timer.current = timer.base
	end
	--immobilize player if dialoguemode active
	if dialogueMode == 1 then
		player.canMove = 0
	end

--set direction and destination position
	if debugView == 0 then
		if player.canMove == 1 then
			if love.keyboard.isDown("up") and player.act_y <= player.grid_y then
				changeGridy (player, 1, 0, -1, -1) -- char, dir, x-test, y-test, multiplier
			elseif love.keyboard.isDown("down") and player.act_y >= player.grid_y then
				changeGridy (player, 2, 0, 1, 1)
			elseif love.keyboard.isDown("left") and player.act_x <= player.grid_x then
				changeGridx (player, 3, -1, 0, -1)
			elseif love.keyboard.isDown("right") and player.act_x >= player.grid_x then
				changeGridx (player, 4, 1, 0, 1)
			end
		end
	elseif debugView == 1 then
		if player.canMove == 1 then
			if love.keyboard.isDown("up") and player.act_y <= player.grid_y then
				player.facing = 1
				if math.abs(player.grid_x - player.act_x) <= player.threshold then
					player.act_x = player.grid_x
					player.grid_y = player.grid_y - gridsize
					player.moveDir = 1
				end
			elseif love.keyboard.isDown("down") and player.act_y >= player.grid_y then
				player.facing = 2
				if math.abs(player.grid_x - player.act_x) <= player.threshold then
					player.act_x = player.grid_x
					player.grid_y = player.grid_y + gridsize
					player.moveDir = 2
				end
			elseif love.keyboard.isDown("left") and player.act_x <= player.grid_x then
				player.facing = 3
				if math.abs(player.grid_y - player.act_y) <= player.threshold then
					player.act_y = player.grid_y
					player.grid_x = player.grid_x - gridsize
					player.moveDir = 3
				end
			elseif love.keyboard.isDown("right") and player.act_x >= player.grid_x  then
				player.facing = 4
				if math.abs(player.grid_y - player.act_y) <= player.threshold then
					player.act_y = player.grid_y
					player.grid_x = player.grid_x + gridsize
					player.moveDir = 4
				end
			end
		end
	end

	player.moveDir, player.act_x, player.act_y = moveChar(player.moveDir, player.act_x, player.grid_x, player.act_y, player.grid_y, (player.speed *dt))

	if player.canMove == 1 then
		changeMap(player.act_x, player.act_y, locationTriggers[currentLocation])
	end
	--animation time update
	for k, v in pairs(animations) do
		animations[k][1]["currentTime"] = animations[k][1]["currentTime"] + dt
    if animations[k][1]["currentTime"] >= animations[k][1]["duration"] then
        animations[k][1]["currentTime"] = animations[k][1]["currentTime"] - animations[k][1]["duration"]
    end
	end
end


-- DRAW --
---------------

function love.draw()
	local width = love.graphics.getWidth( )
	local height = love.graphics.getHeight()
	local scale = {x=4, y=4}
	local translate = {x = (width - gridsize*scale.x) / 2, y = (height - gridsize*scale.y) /2}
	love.graphics.push()
	--camera move and scale
	love.graphics.translate(-player.act_x*scale.x + translate.x, -player.act_y*scale.y + translate.y)
	love.graphics.scale( scale.x, scale.y )

	-- draw background
	love.graphics.setBackgroundColor(93, 43, 67)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(currentBackground, 16, 16)

	--draw map
	if debugView == 1 then
		love.graphics.setColor(0, 0, 0)
		drawEditor (initTable)
	end

	--draw extra infoView
	if infoView == 1 then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(currentLocation, player.act_x - 48, player.act_y - 48)
		love.graphics.print("x: " .. player.act_x .." y: " .. player.act_y, player.act_x - 48, player.act_y - 40)
	end

	--render player
	love.graphics.setColor(255, 255, 255)
	drawPlayer()

	--render npcs
	drawNPCs()

	-- render tiles on top of player
	if currentLocation ~= "overworld" then
		drawTop(currentLocation, locationTriggers)
	end

	--render dialogue box and text
	if text ~= nil and dialogueMode == 1 then
		local width = love.graphics.getWidth( )/4
		local height = love.graphics.getHeight( )/4
		local recheight = 24
		local recwidth = width-8
		local xnudge = 12
		local ynudge = 2
		local boxposx = player.act_x - (width/2) + xnudge
		local boxposy = player.act_y + (height/2) - recheight + ynudge
		love.graphics.setColor(93, 43, 67)
		love.graphics.rectangle("fill", boxposx, boxposy, recwidth, recheight) -- outside box (dark)
		love.graphics.setColor(255, 247, 220)
		love.graphics.rectangle("fill", boxposx+2, boxposy+2, recwidth-4, recheight-4) -- inside box (light colored)

		--draw z or arrow if more text
		drawArrow()

		--draw arrow for choices, shift text if arrow present
		drawText()

	end

	love.graphics.pop()
end


function love.keypressed(key)

--initiate debug mode
  if key == "p" then
	 	if debugView == 0 then
    	debugView = 1
		elseif debugView == 1 then
			debugView = 0
		end
  end
--print additional info about game on screen for debugging
	if key == "i" then
		if infoView == 0 then
			infoView = 1
		else
			infoView = 0
		end
	end
--- interact with objects or people
  if key == "z" then
		DialogueSetup(npcs)
		faceObject(player.facing)
	end
-- add block to editor
	if key == "space" and debugView == 1 then
		addBlock (initTable, player.grid_x, player.grid_y)
	end

	if key == "s" and debugView == 1 then
		if mapExists == 1 then
			print("saved over old map")
			f = assert(io.open(mapFile2, "w"))
			initTableFile = json.encode(initTable)
			f:write(initTableFile)
			f:close(initTableFile)
		else
			print("saved over new map")
			f = assert(io.open(mapFile1, "w"))
			initTableFile = json.encode(initTable)
			f:write(initTableFile)
			f:close(initTableFile)
		end
	end




-- move between dialogue options
	if choice.mode == 1 then
		if key == "down" then
			if choice.pos >= 1 and choice.pos < choice.total then
				choice.pos = choice.pos + 1
				choiceText(playerDialogue[choice.name], choice.pos, choice.total)
			end
		elseif key == "up" then
			if choice.pos > 1 then
				choice.pos = choice.pos - 1
				choiceText(playerDialogue[choice.name], choice.pos, choice.total)
			end
		end
	end

end


--testmap for collision testing, update using map table
function testMap(x, y)
	if initTable[(player.grid_y / 16) + y][(player.grid_x / 16) + x] == 1 then
		return false
	end
	return true
end

function testNPC(dir, x, y)
	for i = 1, #npcs do
		if currentLocation == npcs[i].location then
			local x2 = npcs[i].act_x
			local y2 = npcs[i].act_y
			if dir == 1 then
				if x == x2 and y - gridsize == y2 then
					return true
				end
			elseif dir == 2 then
				if x == x2 and y + gridsize == y2 then
					return true
				end
			elseif dir == 3 then
				if y == y2 and x - gridsize == x2 then
					return true
				end
			elseif dir == 4 then
				if y == y2 and x + gridsize == x2 then
					return true
				end
			end
		end
	end
	return false
end

--change grid coordinates, up and down
function changeGridy(char, dir, x, y, s)
	char.facing = dir
	if testMap(x, y) then
		if testNPC(dir, char.grid_x, char.grid_y) == false then
			if math.abs(char.grid_x - char.act_x) <= char.threshold then
				char.act_x = char.grid_x
				char.grid_y = char.grid_y + (s * gridsize)
				char.moveDir = dir
			end
		end
	end
	return
end

--change grid coordinates, left and right
function changeGridx(char, dir, x, y, s)
	char.facing = dir
	if testMap(x, y) then
		if testNPC(dir, char.grid_x, char.grid_y) == false then
			if math.abs(char.grid_y - char.act_y) <= char.threshold then
				char.act_y = char.grid_y
				char.grid_x = char.grid_x + (s * gridsize)
				char.moveDir = dir
			end
		end
	end
	return
end


-- test to see if player next to object, return object name
function testObject(x, y)
	local m = (player.grid_x / 16) + x
	local n = (player.grid_y / 16) + y
	for i = 1, #objects do
		if m == objects[i][1] and n == objects[i][2] then
			return true, objects[i][3]
		end
	end
	return false, nil
end

--pass object description to text, change dialogue mode
function printObjText(b)
	if dialogueMode == 0 then
		dialogueMode = 1
		text = objectText[b]
		return
	else
		dialogueMode = 0
		player.canMove = 1
		return
	end
end

--test to see if player facing object, retrieve description
function faceObject(dir)
	if dir == 1 then -- up
		local a, b = testObject(0, -1)
		if a and b ~= nil then
			printObjText(b)
			return
		end
	elseif dir == 2 then -- down
		local a, b = testObject(0, 1)
		if a and b ~= nil then
			printObjText(b)
			return
		end
	elseif dir == 3 then -- left
		local a, b = testObject(-1, 0)
		if a and b ~= nil then
			printObjText(b)
			return
		end
	elseif dir == 4 then -- right
		local a, b = testObject(1, 0)
		if a and b ~= nil then
			printObjText(b)
			return
		end
	end
end


--move character in direction of destination
function moveChar(m, x1, x2, y1, y2, s)
	if m == 1 then
		if y1 > y2 then
			y1 = y1 - s
		elseif y1 < y2 then
			y1 = y2
		elseif y1 == y2 then
			m = 0
		end
	elseif m == 2 then
		if y1 < y2 then
			y1 = y1 + s
		elseif y1 > y2 then
			y1 = y2
		elseif y1 == y2 then
			m = 0
		end
	elseif m == 3 then
		if x1 > x2 then
			x1 = x1 - s
		elseif x1 < x2 then
			x1 = x2
		elseif x1 == x2 then
			m = 0
		end
	elseif m == 4 then
		if x1 < x2 then
			x1 = x1 + s
		elseif x1 > x2 then
			x1 = x2
		elseif x1 == x2 then
			m = 0
		end
	end
	return m, x1, y1
end

--animation
function newAnimation(image, start, length, width, height, duration)
  local animation = {}
  animation.spriteSheet = image;
  animation.quads = {};
	for y = start, start, height do
    for x = 0, length * width - width, width do
      table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end
  animation.duration = duration or 1
  animation.currentTime = 0
  return animation
end

--initiate dialogue
function initDialogue (char)
	if currentLocation == char.location then
		if player.act_y == char.act_y then
			if player.act_x == char.act_x - gridsize and player.facing == 4 then
				char.dialogue = 1
				char.facing = 3
				return true
			elseif player.act_x == char.act_x + gridsize and player.facing == 3 then
				char.dialogue = 1
				char.facing = 4
				return true
			end
		end
		if player.act_x == char.act_x then
			if player.act_y == char.act_y - gridsize and player.facing == 2 then
				char.dialogue = 1
				char.facing = 1
				return true
			elseif player.act_y == char.act_y + gridsize and player.facing == 1 then
				char.dialogue = 1
				char.facing = 2
				return true
			end
		end
	end
char.dialogue = 0
return false
end

--change text
function textUpdate (num, name, dialOpt, case)
	dialogueMode = 1
	player.canMove = 0
	if case ~= 3 then
		if NPCdialogue[name][3] ~= nil and case == 1 then
			if num == #dialOpt then
			choice.more = 1
			end
		end
		if num < #dialOpt then
			print("more choices case " .. case)
			choice.more = 1
		else
			print("no more choices case " .. case)
			choice.more = 0
		end
	else
		choice.more = 0
	end
	text = name .. ": " .. dialOpt[num]
end

--dialogue off
function dialogueOff(tbl, i)
	choice.more = 0
	dialogueMode = 0
	player.canMove = 1
	tbl[i].n = 1
	tbl[i].dialogue = 0
end


--choice text
function choiceText(tbl, pos, total)
	dialogueMode = 1
	player.canMove = 0
	local n = 0
	if total % 2 == 0 then
		n = 1
	else
		n = 0
	end
	if pos < total - n then
		choice.more = 2
	else
		choice.more = 0
	end
	if total % 2 == 0 then
		if pos % 2 == 0 then
			text = tbl[pos-1] .. "\n" .. tbl[pos]
		else
			text = tbl[pos] .. "\n" .. tbl[pos+1]
		end
	else
		if pos == total then
			text = tbl[pos]
		else
			if pos % 2 == 0 then
				text = tbl[pos-1] .. "\n" .. tbl[pos]
			else
				text = tbl[pos] .. "\n" .. tbl[pos+1]
			end
		end
	end
end
--feed npc to dialogue
function DialogueSetup (tbl)
	for i = 1, #tbl do
		if initDialogue(tbl[i]) == true then
			local name = tbl[i].name
			local num = tbl[i].n
			local case = tbl[i].c
			local dialOpt = NPCdialogue[name][case]
			if case == 1 then
				if num <= #dialOpt then
					textUpdate(num, name, dialOpt, case)
					tbl[i].n = num + 1
					return
				else
					if NPCdialogue[name][3] ~= nil then
						tbl[i].c = 3
						dialogueOff(tbl, i)
					else
						tbl[i].c = 2
						print("case 1 off")
						dialogueOff(tbl, i)
						return
					end
				end
			end
			if case == 2 and dialOpt then
				if num <= #dialOpt then
					textUpdate(num, name, dialOpt, case)
					tbl[i].n = num + 1
					return
				else
					print("case 2 off")
					dialogueOff(tbl, i)
					return
				end
			end
			if case == 3 then
				if num == 1 then
					textUpdate(num, name, dialOpt[1], case)
					tbl[i].n = num + 1
					return
				elseif num == 2 then
					if choice.mode == 0 then
						choice.mode = 1
						choice.total = #playerDialogue[name]
						choice.name = name -- set total number of choices available based on number of values in table
						choiceText(playerDialogue[name], choice.pos, choice.total)
						return
					elseif choice.mode == 1 then
						textUpdate (choice.pos, name, dialOpt[2], case)
						choice.mode = 0
						tbl[i].n = num + 1
						return
					end
				elseif num == 3 then
					print("case 3 off")
					tbl[i].c = 2
					dialogueOff(tbl, i)
					return
				end
			end
		end
	end
end
