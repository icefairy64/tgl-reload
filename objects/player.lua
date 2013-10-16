
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Методы player'а

local player = {}
player.__index = player

-- Столкновение с другим объектом
function player:collide(objectShape, dx, dy)
  -- Ограничение вектора скорости по одной из осей
  if math.abs(dx) > 0 then
    self.vel = self.vel:permul(vector(0, 1))
  end
  if math.abs(dy) > 0 then
    self.vel = self.vel:permul(vector(1, 0))
  end
  -- Выключение бега
  if self.state == 3 then self.state = 2 end
  -- Устранение столкновения
  self.shape:move(dx, dy)
end

-- Шаг
function player:update(dt)
  -- Движение
  if self.hold[1] == 1 then self.delta = self.delta + vector(-1, 0) end
  if self.hold[2] == 1 then self.delta = self.delta + vector(1, 0) end
  if self.hold[3] == 1 then self.delta = self.delta + vector(0, -1) end
  if self.hold[4] == 1 then self.delta = self.delta + vector(0, 1) end
  self.delta = self.delta:normalized() 
  -- Ускорение
  local mult = 1
  if self.state == 3 then mult = self.runMult end
  if self.state > 1 then self.vel = self.vel + self.delta * self.acc * mult end
  self.shape:move((self.vel * dt):unpack()) 
  -- Ограничение скорости
  if self.vel:len() > self.maxspeed * mult then self.vel = self.vel:normalized() * self.maxspeed * mult end 
  -- Трение
  if self.state == 1 then self.vel = self.vel * 0.92 end
end

-- Вывод строки
function player:__tostring()
  return self.type .. ": " .. tonumber(self.state)
end

-- Создание объекта
function player:create(x, y)
  local fields = baseObject(x, y, 48, 32, "player")
  fields.vel = vector(0, 0)
  fields.delta = vector(0, 0)
  fields.state = 1
  fields.maxspeed = 300
  fields.runMult = 1.6
  fields.acc = 70
  fields.hold = {0, 0, 0, 0}
  return setmetatable(fields, player)
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return player:create(...) end, __index = player})