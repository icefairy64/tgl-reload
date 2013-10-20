
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Редактор уровней

local editor = {}

local hold = {0, 0, 0, 0, 0, 0}
local state = 'idle'
local dx, dy = 0, 0
local nx, ny, nw, nh  = 0, 0, 0, 0
local selection = { }
local index = 1

function editor:mousepressed(x, y, button)
  
end

function editor:mousereleased(x, y, button)
  local mx, my = cam:mousepos()
  if button == 'l' then
    if state == 'idle' or state == 'moving' then
    local sel = nil
    for id, obj in pairs(objects) do
      if obj.shape:contains(mx, my) then
        sel = obj
        break
      end
    end
    if sel then
      -- Добавление в выделение
      if hold[6] == 1 then
        table.insert(selection, sel)
      else 
      -- Замена выделения
      if selection then
          for i = 1, #selection do
            selection[i].color[4] = 128
          end
        end
        selection = { sel }
      end
      sel.color[4] = 255
      echo = bases.object.save(sel)
    else
      -- Снятие выделения
      if selection then
        for i = 1, #selection do
          selection[i].color[4] = 128
        end
        selection = { }
      end
      echo = 'Nothing is selected'
    end
    if state == 'moving' then state = 'idle' end
    end
    
    if state == 'sizing' then
      nw, nh = mx - nx, my - ny
      table.insert(objects, bases[objectNames[index]](nx, ny, nw, nh, 'base'))
      state = 'idle'
      echo = 'Placed'
    end
    
    if state == 'placing' or state == 'selecting' then
      nx, ny = mx, my
      if objectNames[index] ~= 'object' then
        table.insert(objects, bases[objectNames[index]](nx, ny))
        state = 'idle'
        echo = 'Placed'
      else
        state = 'sizing'
      end
    end
    
  end
 
 if button == 'r' and selection then
    if state == 'moving' then state = 'idle' else state = 'moving' end
    dx = mx
    dy = my
    echo = 'State: ' .. state
  end
end

function editor:keypressed(key)
  if state == 'idle' or state == 'moving' or state == 'placing' then
    if key == 'left'   then hold[1] = 1 end
    if key == 'right'  then hold[2] = 1 end
    if key == 'up'     then hold[3] = 1 end
    if key == 'down'   then hold[4] = 1 end
  end
  if key == 'lshift' then hold[5] = 1 end
  if key == 'lctrl'  then hold[6] = 1 end
end

function editor:keyreleased(key)
  if key == 'left'   then hold[1] = 0 end
  if key == 'right'  then hold[2] = 0 end
  if key == 'up'     then hold[3] = 0 end
  if key == 'down'   then hold[4] = 0 end
  if key == 'lshift' then hold[5] = 0 end
  if key == 'lctrl'  then hold[6] = 0 end
  if key == 'a' then
    if state == 'idle' then
      state = 'selecting'
      index = 1
      echo = objectNames[index]
    end
  end
  if key == 'return' then
    if state == 'selecting' then
      state = 'placing'
    end
  end
  if state == 'selecting' then
    if key == 'left'  then index = index - 1 end
    if key == 'right' then index = index + 1 end
    if index < 1 then index = #objectNames end
    if index > #objectNames then index = 1 end
    echo = objectNames[index]
  end
end

function editor:draw()
  local mx, my = cam:mousepos() 
  if state == 'sizing' then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('line', nx, ny, mx - nx, my - ny)
  end
end

function editor:update(dt)
  local add = hold[5] * 12
  if hold[1] == 1 then cam:move(-4 - add, 0) end
  if hold[2] == 1 then cam:move(4 + add, 0)  end
  if hold[3] == 1 then cam:move(0, -4 - add) end
  if hold[4] == 1 then cam:move(0, 4 + add)  end
  local mx, my = cam:mousepos()
  if state == 'moving' and #selection > 0 then
    if selection then
      for i = 1, #selection do
        selection[i].shape:move(mx - dx, my - dy)
      end
    end
  end
  dx, dy = mx, my
end

return editor