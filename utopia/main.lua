


function love.load()
--dialogue and object descriptions
require("scripts/dialogue")
--editor for creating new maps
require("scripts/editor")
--json for map files
json = require("json")

--characters
	player = {
		grid_x = 8*16,
		grid_y = 17*16,
		act_x = 8*16,
		act_y = 17*16,
		speed = 32,
		canMove = 1,
		moveDir = 0,
		threshold = 0,
		facing = 2,
		name = ""
	}

	npcs = {{
		grid_x = 5*16,
		grid_y = 10*16,
		act_x = 5*16,
		act_y = 10*16,
		speed = 30,
		canMove = 0,
		moveDir = 0,
		threshold = 0,
		facing = 1,
		start = 1,
		dialogue = 0,
		name = "Grape",
		animationkey = 5, -- where animations start
		n = 1, --stage in single conversation
		c = 1}, -- dialogue case
		{
			grid_x = 9*16,
			grid_y = 21*16,
			act_x = 9*16,
			act_y = 21*16,
			speed = 30,
			canMove = 0,
			moveDir = 0,
			threshold = 0,
			facing = 1,
			start = 2,
			dialogue = 0,
			name = "Lark",
			animationkey = 9, -- where animations start
			n = 1, --stage in single conversation
			c = 1} -- dialogue case
}


--map
	gridsize = 16
	debugview = 0


--objects
objects = {
	{7, 11, "GardeningSign"},
	{7, 18, "KitchenSign"},
	{17, 11, "ClinicSign"},
	{10, 8, "Cauliflower"},
	{12, 8, "Cauliflower2"},
	{18, 16, "RepairSign"},
	{25, 15, "GlassSign"},
	{31, 15, "WoodworkingSign"}

}
--images
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setColor(0, 0, 0)
	love.graphics.setBackgroundColor(255,255,255)

	bg = love.graphics.newImage("images/utopiabg.png")
	spritesheet1 = love.graphics.newImage("images/utopia.png")
	animsheet1 = love.graphics.newImage("images/utopia_anim.png")
	arrow = love.graphics.newImage("images/utopiaui_0.png")

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
	dialogueChoice = 0
	choicePos = 1
	text = nil



	initTable = mapSize (bg, gridsize)
	fillEdges(initTable)

-- camera
	require("scripts/camera")
	mouseTranslate = {}


	f = assert(io.open("D:\\my game projects\\utopia\\scripts\\abc.txt", "w"))
	initTableFile = json.encode(initTable)
	f:write(initTableFile)
	f:close(initTableFile)

	file = assert(io.open("D:\\my game projects\\utopia\\maps\\abc1.txt", "r"))
	local content = file:read("*a")
	initTable = json.decode(content)
	io.close(file)


	--table.save(initTable, "D:\\my game projects\\utopia\\scripts\\initTable.lua")
end






function love.update(dt)


	--immobilize player if dialoguemode active
	if dialogueMode == 1 then
		player.canMove = 0
	end

--set direction and destination position
	if debugview == 0 then
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
	elseif debugview == 1 then
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

	--initDialogue


	--animation time update
	for k, v in pairs(animations) do
		animations[k][1]["currentTime"] = animations[k][1]["currentTime"] + dt
	    if animations[k][1]["currentTime"] >= animations[k][1]["duration"] then
	        animations[k][1]["currentTime"] = animations[k][1]["currentTime"] - animations[k][1]["duration"]
	    end
	end

	--- mouse transform
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	mouseTranslate.x = -player.act_x*4 + ((width - gridsize*4)/4)
	mouseTranslate.y = -player.act_y*4 + ((height - gridsize*4)/4)
end

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

		-- local width = love.graphics.getWidth( )
		-- local height = love.graphics.getHeight()
		-- camera.x = (width - gridsize*4) / 2
		-- camera.y = (height - gridsize*4) / 2
		-- camera:scale(4)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(bg, 16, 16)

	--draw map
	if debugview == 1 then
		love.graphics.setColor(0, 0, 0)
		drawEditor (initTable)
		-- for y=1, #map do
		-- 	for x=1, #map[y] do
		-- 		if map[y][x] == 1 then
		-- 			love.graphics.rectangle("line", x * 16, y * 16, 16, 16)
		-- 		end
		-- 	end
		-- end
	end

	--render player
	love.graphics.setColor(255, 255, 255)
	for i = 1, 4 do
		if player.moveDir == i then
			local spriteNum = math.floor(animations[i][1]["currentTime"] / animations[i][1]["duration"] * #animations[i][1]["quads"]) + 1
	   		love.graphics.draw(animations[i][1]["spriteSheet"], animations[i][1]["quads"][spriteNum], player.act_x, player.act_y, 0, 1)
	 	elseif player.moveDir == 0 then
			if player.facing == i then
				love.graphics.draw(animations[i][1]["spriteSheet"], animations[i][1]["quads"][1], player.act_x, player.act_y, 0, 1)
			end
		end
	end

	--render npcs
		for i = 1, #npcs do
			local k = npcs[i].animationkey
			local f = npcs[i].facing-1
			local s = npcs[i].start-1
			if npcs[i].dialogue == 1 then
				love.graphics.draw(animations[k+f][1]["spriteSheet"], animations[k+f][1]["quads"][1], npcs[i].act_x, npcs[i].act_y, 0, 1)
			else
				love.graphics.draw(animations[k+s][1]["spriteSheet"], animations[k+s][1]["quads"][1], npcs[i].act_x, npcs[i].act_y, 0, 1)
			end
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
		love.graphics.rectangle("fill", boxposx, boxposy, recwidth, recheight)
		love.graphics.setColor(255, 247, 220)
		love.graphics.rectangle("fill", boxposx+2, boxposy+2, recwidth-4, recheight-4)
		if dialogueChoice == 1 then
			love.graphics.setColor(255, 255, 255)
			if choicePos == 1 then
				love.graphics.draw(arrow, player.act_x-48, player.act_y+46)
			elseif choicePos == 2 then
				love.graphics.draw(arrow, player.act_x-48, player.act_y+54)
			end
			love.graphics.setColor(93, 43, 67)
			love.graphics.printf(text, player.act_x-42, player.act_y+46, 112)
		else
			love.graphics.setColor(93, 43, 67)
			love.graphics.printf(text, player.act_x-48, player.act_y+46, 112)
		end
	end
	love.graphics.pop()
end


function love.keypressed(key)

--initiate debug mode
 if key == "p" then
	 	if debugview == 0 then
    	debugview = 1
		elseif debugview == 1 then
			debugview = 0
		end
 end
--- interact with objects or people
  if key == "z" then
		DialogueSetup(npcs)
		faceObject(player.facing)
	end
-- add block to editor
	if key == "space" and debugview == 1 then
		addBlock (initTable, player.grid_x, player.grid_y)
	end

	if key == "s" and debugview == 1 then
		f = assert(io.open("D:\\my game projects\\utopia\\scripts\\abc.txt", "w"))
		initTableFile = json.encode(initTable)
		f:write(initTableFile)
		f:close(initTableFile)
	end

	if dialogueChoice == 1 then
		if key == "up" then
			if choicePos == 2 then
				choicePos = 1
			end
		elseif key == "down" then
			if choicePos == 1 then
				choicePos = 2
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
		x2 = npcs[i].act_x
		y2 = npcs[i].act_y
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
char.dialogue = 0
return false
end

--change text
function textUpdate (num, name, dialOpt)
	dialogueMode = 1
	player.canMove = 0
	text = name .. ": " .. dialOpt[num]
end

--dialogue off
function dialogueOff(tbl, i)
	dialogueMode = 0
	player.canMove = 1
	tbl[i].n = 1
	tbl[i].dialogue = 0
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
					textUpdate(num, name, dialOpt)
					tbl[i].n = num + 1
					return
				else
					if NPCdialogue[name][3] ~= nil then
						print(tbl[i].n)
						tbl[i].n = 1
						tbl[i].c = 3
						num = tbl[i].n
						case = tbl[i].c
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
					textUpdate(num, name, dialOpt)
					tbl[i].n = num + 1
					return
				else
					print("case 2 off")
					dialogueOff(tbl, i)
					return
				end
			end
			if case == 3 then
				if num < #playerDialogue[name] then
					if dialogueChoice == 0 then
						print(tbl[i].n)
						dialogueMode = 1
						player.canMove = 0
						dialogueChoice = 1
						text = playerDialogue[name][num] .. "\n" .. playerDialogue[name][num + 1]
						return
					elseif dialogueChoice == 1 then
						text = dialOpt[choicePos]
						tbl[i].n = num + 1
						dialogueChoice = 0
						return
					end
				else
					print("case 3 off")
					dialogueChoice = 0
					tbl[i].c = 2
					dialogueOff(tbl, i)
					return
				end
			end
		end
	end
end
