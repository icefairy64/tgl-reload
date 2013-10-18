
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Базовый объект

local base = {}
base.__index = base

-- Создание тела
local function createShape(x, y, w, h, group)
  local shape = collider:addRectangle(x, y, w, h)
  collider:addToGroup(group, shape)
  return shape
end

--Шаг
function base:update(dt)
  
end

function base:init()
  self.shape.parent = self
  return self
end

-- Создание объекта
function base:new(x, y, w, h, group)
  fields = {}
  fields.shape = createShape(x, y, w, h, group)
  if not group then group = "base" end
  fields.type = group
  fields.color = {64, 255, 96, 128}
  return setmetatable(fields, base):init()
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return base:new(...) end })