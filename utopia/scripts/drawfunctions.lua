--render player
function drawPlayer()
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
end

function drawNPCs()
  for i = 1, #npcs do
    if currentLocation == npcs[i].location then
      local k = npcs[i].animationkey
      local f = npcs[i].facing-1
      local s = npcs[i].start-1
      if npcs[i].dialogue == 1 then
        love.graphics.draw(animations[k+f][1]["spriteSheet"], animations[k+f][1]["quads"][1], npcs[i].act_x, npcs[i].act_y, 0, 1)
      else
        love.graphics.draw(animations[k+s][1]["spriteSheet"], animations[k+s][1]["quads"][1], npcs[i].act_x, npcs[i].act_y, 0, 1)
      end
    end
  end
end

function drawTop(l, tbl)
  love.graphics.draw(toptiles[l], tbl[l][1][1], tbl[l][1][2])
end

function drawText()
  if choice.mode == 1 then
    love.graphics.setColor(255, 255, 255)
    if choice.pos % 2 == 0 then
      love.graphics.draw(ui.arrowright, player.act_x-48, player.act_y+54)
    else
      love.graphics.draw(ui.arrowright, player.act_x-48, player.act_y+46)
    end
    love.graphics.setColor(93, 43, 67)
    love.graphics.printf(text, player.act_x-42, player.act_y+46, 112)
  else
    love.graphics.setColor(93, 43, 67)
    love.graphics.printf(text, player.act_x-48, player.act_y+46, 112)
  end
end


function drawArrow()
  if timer.trigger == 1 then
    love.graphics.setColor(255, 255, 255)
    if choice.more == 1 then
      love.graphics.draw(ui.pressz, player.act_x+58, player.act_y+58)
    elseif choice.more == 2 then
      love.graphics.draw(ui.arrowdown, player.act_x+58, player.act_y+58)
    end
  end
end
