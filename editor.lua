
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Редактор уровней

local editor = {}

local hold = {0, 0, 0, 0, 0}
editor.selection = nil

function editor:keypressed(key)
  if key == 'left'   then hold[1] = 1 end
  if key == 'right'  then hold[2] = 1 end
  if key == 'up'     then hold[3] = 1 end
  if key == 'down'   then hold[4] = 1 end
  if key == 'lshift' then hold[5] = 1 end
end

function editor:keyreleased(key)
  if key == 'left'   then hold[1] = 0 end
  if key == 'right'  then hold[2] = 0 end
  if key == 'up'     then hold[3] = 0 end
  if key == 'down'   then hold[4] = 0 end
  if key == 'lshift' then hold[5] = 0 end
end

function editor:update(dt)
  local add = hold[5] * 12
  if hold[1] == 1 then cam:move(-4 - add, 0) end
  if hold[2] == 1 then cam:move(4 + add, 0)  end
  if hold[3] == 1 then cam:move(0, -4 - add) end
  if hold[4] == 1 then cam:move(0, 4 + add)  end
end

return editor