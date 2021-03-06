
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Главный модуль

bases = {}

gamestate = require "hump.gamestate"
vector = require "hump.vector"
camera = require "hump.camera"
timer = require "hump.timer"

hc = require "HardonCollider"

bases.object = require "objects.base"
bases.playerLab = require "objects.player"

bases.enemy = require "objects.enemies.base"
bases.enemySample = require "objects.enemies.sample"

motion = require "motion"
anim = require "animation"
title = require "title"
labyrinth = require "labyrinth"
editor = require "editor"
motionTest = require "motionTest"

-- Глобальные переменные

objects = {}
player = {}
cam = {}
objectNames = {}
fade = {255, 255, 255, 0}
health, healthMax = 80, 80
chip, chipMax = 50, 50
echo = ''
editing = false

-- Ресурсы

resources = {}
resources.sprite = {}
resources.anim = {}
resources.motion = {}
resources.sound = {}

-- Константы

g = -500
wnd_w = 1280
wnd_h = 720

-- Методы движка

-- Загрузка
function love.load()
  --love.graphics.setMode(wnd_w, wnd_h, false, false, 2)
  --love.graphics.setCaption("TGL Reload")
  love.window.setMode(wnd_w, wnd_h, { vsync = false, fsaa = 0 })
  love.window.setTitle("TGL Reload")
  cam = camera(0, 0)
  collider = hc(100, on_collide, end_collide)
  gamestate.switch(title)
  gamestate.registerEvents({'keypressed', 'keyreleased', 'mousepressed', 'mousereleased'})
  for name, obj in pairs(bases) do
    table.insert(objectNames, name)
  end
  --font = love.graphics.newImageFont('font_01.png', 'abcdefghijklmnopqrstuvwxyz!?.;,"`()1234567890 ')
  --love.graphics.setFont(font)
end

function love.keypressed(key)
  if key == "escape" then love.event.push('quit') end
  if key == "f7" then load('state.snapshot') end
  if key == 'e' then editing = not editing end
end

-- Отрисовка отладочной информации
function debug_draw()
  love.graphics.printf('TGL Reload\nUnder development', 0, wnd_h - 48, wnd_w - 32, 'right')
  love.graphics.print(echo, 32, 128)
  local x, y = cam:pos()
  love.graphics.print('FPS ' .. tostring(love.timer.getFPS()) .. '\nCamera position ' .. tostring(math.floor(x)) .. ' ' .. tostring(math.floor(y)), 32, 32)
end

-- Сохранение
function save(filename)
  local out = io.open(filename, 'w')
  local gs = ''
  if gamestate.current() == labyrinth then
    gs = 'labyrinth'
  end
  out:write(gs .. '\n')
  out:write(tostring(health) .. ' ' .. tostring(healthMax) .. ' ' .. tostring(chip) .. ' ' .. tostring(chipMax) .. '\n')
  for i = 1, #objects do
    out:write(bases.object.save(objects[i]))
    if i < #objects then
      out:write('\n')
    end
  end
  out:close()
  echo = echo .. '\nLevel saved\n'
end

-- Загрузка
function load(filename, ...)
  local i = 0
  local gs = ''
  if #objects > 0 then
    for i = 1, #objects do
      collider:remove(objects[#objects - i + 1].shape)
      table.remove(objects)
    end
  end
  for line in io.lines(filename) do
    i = i + 1
    if i == 1 then
      gs = line
    else
    if i == 2 and not ... then
      local z = 0
      for val in string.gmatch(line, "(%w+)") do
        z = z + 1
        if z == 1 then health = tonumber(val) end
        if z == 2 then healthMax = tonumber(val) end
        if z == 3 then chip = tonumber(val) end
        if z == 4 then chipMax = tonumber(val) end
      end
    else
      local result = {}
    for val in string.gmatch(line, ":?(%w+):?") do
      table.insert(result, val)
    end
    local x, y, w, h
    local z = 0
    local fields, vals = { }, { }
    for field, val in string.gmatch(line, '(%w+)=([%-%.%w]+)') do
      z = z + 1
      if z == 1 then x = tonumber(val) end
      if z == 2 then y = tonumber(val) end
      if z == 3 then w = tonumber(val) end
      if z == 4 then h = tonumber(val) end
      if z > 4 then table.insert(fields, field) table.insert(vals, val) end
    end
    table.insert(objects, bases[result[2]](x, y, w, h, result[1]))
    local obj = objects[#objects]
    if #fields > 0 then
      for z = 1, #fields do
        echo = echo .. fields[z] .. '=' .. vals[z] .. '\n'
        if tonumber(vals[z]) then 
          obj[fields[z]] = tonumber(vals[z])
        else
          obj[fields[z]] = vals[z]
        end
      end
    end
    end
    end 
  end
  player = objects[1]
  if gs == 'labyrinth' then
    gamestate.switch(labyrinth, false)
  end
  echo = echo .. '\nLevel loaded\n'
end

-- Отрисовка
function love.draw()
  cam:attach()
  gamestate.draw()
  cam:detach()
  -- HUD
  if fade[4] > 1 then
    love.graphics.setColor(fade)
    love.graphics.rectangle('fill', 0, 0, wnd_w, wnd_h)
  end
  love.graphics.setColor(255, 255, 255, 255)
  debug_draw()
end

-- Шаг
function love.update(dt)
  gamestate.update(dt)
  timer.update(dt)
end
