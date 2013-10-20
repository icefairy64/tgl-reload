
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

local function getField(self, name)
  return name .. '=' .. tostring(self[name])
end

local function save(self)
  local temp = self.type .. ':' .. self.module .. ' '
  local x, y, w, h = self.shape:bbox()
  x = math.floor(x)
  y = math.floor(y)
  w = math.floor(w) - x
  h = math.floor(h) - y
  temp = temp .. 'x=' .. tostring(x) .. ' y=' .. tostring(y) .. ' w=' .. tostring(w) .. ' h=' .. tostring(h)
  if #self.saveFields > 0 then
    temp = temp .. ' '
    for i = 1, #self.saveFields do
      temp = temp .. getField(self, self.saveFields[i])
      if i < #self.saveFields then
        temp = temp .. ' '
      end
    end
  end
  return temp
end

--Шаг
function base:update(dt)
  
end

function base:init()
  self.shape.parent = self
  return self
end

function base:__tostring()
  return save(self)
end

-- Создание объекта
function base:new(x, y, w, h, group)
  fields = {}
  fields.shape = createShape(x, y, w, h, group)
  if not group then group = "base" end
  fields.type = group
  fields.color = {64, 255, 96, 128}
  fields.visible = true
  fields.module = 'object'
  fields.saveFields = { }
  return setmetatable(fields, base):init()
end

-- Модуль
return setmetatable({ save = save }, { __call = function(_, ...) return base:new(...) end })