
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Основа для создания врагов

local base = {}

-- Создание
function base:new(x, y, w, h, type, health)
  local fields = bases.object(x, y, w, h, "enemy")
  fields.enemyType = type
  fields.health = health
  fields.color = {255, 64, 96, 128}
  return setmetatable(fields, base)
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return base:new(...) end, __index = base})