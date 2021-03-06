
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Лабиринт

local level = {}

-- Столкновения

-- Состояния: 1 - idle, 2 - ходьба

function on_collide(dt, shape_one, shape_two, dx, dy)
  if shape_one == player.shape or shape_two == player.shape then
    -- Игрок vs Другой Объект
    if shape_one == player.shape then
      other = shape_two
      ddx, ddy = dx, dy
    else
      other = shape_one
      ddx, ddy = -dx, -dy
    end
    player:collide(other, ddx, ddy)
  end
end

function end_collide(dt, shape_one, shape_two, dx, dy)
  
end

-- Методы уровня

-- Обработка нажатия клавиш
function level:keypressed(key)
  if not editing then
    if key == 'left' or key == 'right' or key == 'up' or key == 'down' then
      if player.state ~= 0 then if player.state < 3 then player.state = 2 else player.state = 3 end end
    end
    if key == 'left' then  player.hold[1] = 1 end
    if key == 'right' then player.hold[2] = 1 end
    if key == 'up' then    player.hold[3] = 1 end
    if key == 'down' then  player.hold[4] = 1 end
  else
    editor:keypressed(key)
  end
  if key == 'f5' then
    save('state.snapshot')
  end
end

-- Обработка нажатия клавиш
function level:keyreleased(key)
  if not editing then
    if key == 'left' then  	player.hold[1] = 0 player.delta = player.delta - vector(-0.5, 0) end
    if key == 'right' then 	player.hold[2] = 0 player.delta = player.delta - vector(0.5, 0) end
    if key == 'up' then 		player.hold[3] = 0 player.delta = player.delta - vector(0, -0.5) end
    if key == 'down' then 	player.hold[4] = 0 player.delta = player.delta - vector(0, 0.5) end
    player.delta = player.delta:normalized()
    if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
      sum = 0
      for k, v in pairs(player.hold) do sum = sum + v end
      if sum == 0 then
        -- Никакие из стрелок не нажаты - останавливаем движение
        player.delta = vector(0, 0)
        if player.state > 1 then 
          player.state = 1 
        end
      end
    end
  else
    editor:keyreleased(key)
  end
end

function level:mousepressed(x, y, button)
  if editing then
    editor:mousepressed(x, y, button)
  end
end

function level:mousereleased(x, y, button)
  if editing then
    editor:mousereleased(x, y, button)
  end
end

-- Инициализация
function level:init()
  
end

-- Выход
function level:leave()
  --for i = 1, #objects do
  --  collider:remove(objects[i].shape)
  --  objects[i] = nil
  --end
  --for i = 1, #objects do
  --  table:remove()
  --end
end

-- Вход на уровень
function level:enter(previous, createObjects)
  if createObjects == true then
    -- Добавление объектов в таблицу
    table.insert(objects, bases.playerLab(300, 200))
    table.insert(objects, bases.object(400, 100, 200, 100, "terrain"))
    table.insert(objects, bases.object(-100, -100, 300, 300, "terrain"))
    table.insert(objects, bases['enemySample'](100, 400))
    player = objects[1]
  end
  -- Плавный переход
  fade = {255, 255, 255, 255}
  timer.tween(0.5, fade, {[4] = 0}, 'out-quad')
end

-- Отрисовка
function level:draw()
  if #objects > 0 then
    for id, object in pairs(objects) do
      if object.visible then 
        love.graphics.setColor(object.color)
        object.shape:draw('line')
      end
    end
  end
  editor:draw()
end

-- Шаг
function level:update(dt)
  if not editing then
    for id, object in pairs(objects) do
      if object.type ~= "base" then object:update(dt) end
    end
    -- Плавное перемещение камеры
    local d = vector(player.shape:center()) - vector(cam:pos())
    local dist = d:len()
    cam:move((d:normalized() * (dist / 10) * (dt * 60)):unpack())
    if dist < 0.5 then
      cam:move(d:unpack())
    end
    -- Шаг движка столкновений
    collider:update(dt)
  else
    editor:update(dt)
  end
end

return level
