
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
  -- Устранение столкновения
  self.shape:move(dx, dy)
end

-- Вывод строки
function player:__tostring()
  return self.type .. ": " .. tonumber(self.state)
end

-- Создание объекта
function player:create(x, y)
  --player.shape = collider:addRectangle(x, y, 48, 32)
  --player.shape.parent = player
  --player.type = "player"
  --collider:addToGroup(player.type, player.shape)
  --player = setmetatable(baseObject(x, y, 48, 32, "player"), player)
  player.vel = vector(0, 0)
  player.delta = vector(0, 0)
  player.state = 1
  player.maxspeed = 300
  player.runMult = 1.6
  player.acc = 70
  return setmetatable(baseObject(x, y, 48, 32, "player"), player)
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return player:create(...) end, __index = player})