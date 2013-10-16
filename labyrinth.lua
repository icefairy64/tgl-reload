
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Лабиринт

local level = {}

hold = {0, 0, 0, 0}

-- Столкновения

-- Состояния: 1 - стоит, 2 - идет, 3 - бежит

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
  if key == 'left' or key == 'right' or key == 'up' or key == 'down' then
    if player.state ~= 0 then if player.state < 3 then player.state = 2 else player.state = 3 end end
  end
  if key == 'left' then  hold[1] = 1 end
  if key == 'right' then hold[2] = 1 end
  if key == 'up' then    hold[3] = 1 end
  if key == 'down' then  hold[4] = 1 end
  -- Бег
  if key == 'lshift' then
     if player.state == 2 then player.state = 3 end
  end
end

-- Обработка нажатия клавиш
function level:keyreleased(key)
  if key == 'left' then  	hold[1] = 0 player.delta = player.delta - vector(-0.5, 0) end
  if key == 'right' then 	hold[2] = 0 player.delta = player.delta - vector(0.5, 0) end
  if key == 'up' then 		hold[3] = 0 player.delta = player.delta - vector(0, -0.5) end
  if key == 'down' then 	hold[4] = 0 player.delta = player.delta - vector(0, 0.5) end
  if key == 'lshift' then	if player.state == 3 then player.state = 2 end end
  player.delta = player.delta:normalized()
  if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
    sum = 0
    for k, v in pairs(hold) do sum = sum + v end
    if sum == 0 then
      player.delta = vector(0, 0)
      if player.state > 1 then 
        player.state = 1 
      end
    end
  end
end

-- Инициализация
function level:init()
  
end

-- Выход
function level:leave()
  for i = 1, #objects do
    collider:remove(objects[i].shape)
    objects[i] = nil
  end
  for i = 1, #objects do
    table:remove()
  end
end

-- Вход на уровень
function level:enter()
  collider = hc(100, on_collide, end_collide)
  
  -- Создание объекта игрока
  player = player0(300, 200)
  
  -- Добавление объектов в таблицу
  table.insert(objects, player)
  table.insert(objects, baseObject(400, 100, 200, 100, "terrain"))
  table.insert(objects, baseObject(-100, -100, 300, 300, "terrain"))
  
  -- Плавный переход
  fade = {255, 255, 255, 255}
  timer.tween(0.5, fade, {[4] = 0}, 'out-quad')
end

-- Отрисовка
function level:draw()
  if #objects > 0 then
    for id, object in pairs(objects) do
      object.shape:draw('line')
    end
  end
end

-- Шаг
function level:update(dt)
  -- Движение
  if hold[1] == 1 then player.delta = player.delta + vector(-1, 0) end
  if hold[2] == 1 then player.delta = player.delta + vector(1, 0) end
  if hold[3] == 1 then player.delta = player.delta + vector(0, -1) end
  if hold[4] == 1 then player.delta = player.delta + vector(0, 1) end
  player.delta = player.delta:normalized()
  
  -- Ускорение
  local mult = 1
  if player.state == 3 then mult = player.runMult end
  if player.state > 1 then player.vel = player.vel + player.delta * player.acc * mult end
  player.shape:move((player.vel * dt):unpack())
  
  -- Ограничение скорости
  if player.vel:len() > player.maxspeed * mult then player.vel = player.vel:normalized() * player.maxspeed * mult end
  
  -- Трение
  if player.state == 1 then player.vel = player.vel * 0.92 end
  
  -- Плавное перемещение камеры
  local d = vector(player.shape:center()) - vector(cam:pos())
  local dist = d:len()
  cam:move((d:normalized() * (dist / 30)):unpack())
  
  -- Шаг движка столкновений
  collider:update(dt)
end

return level