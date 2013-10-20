
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Пример реализации врага

local sample = {}
sample.__index = sample

-- Шаг
function sample:update(dt)
  self.phase = self.phase + 0.07
  if self.phase > 6.28 then self.phase = 0 end
  self.shape:moveTo(self.bx + math.sin(self.phase) * self.amp, self.by)
end

-- Создание
function sample:new(x, y)
  local fields = bases.enemy(x, y, 48, 32, "sample", 10000)
  fields.bx, fields.by = x, y
  fields.phase = 0
  fields.amp = 300
  table.insert(fields.saveFields, 'bx')
  table.insert(fields.saveFields, 'by')
  table.insert(fields.saveFields, 'phase')
  table.insert(fields.saveFields, 'amp')
  return setmetatable(fields, sample)
end

-- Модуль
return setmetatable({ }, { __call = function(_, ...) return sample:new(...) end, __index = sample})