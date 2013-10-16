
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

-- Создание объекта
function base:create(x, y, w, h, group)
  return setmetatable({ shape = createShape(x, y, w, h, group), type = group }, base)
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return base:create(...) end })