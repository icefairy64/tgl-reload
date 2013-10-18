
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

title = require "title"
labyrinth = require "labyrinth"

-- Глобальные переменные

objects = {}
player, cube = {}
cam = {}
fade = {255, 255, 255, 0}

-- Константы

g = -500
wnd_w = 1280
wnd_h = 720

-- Методы движка

-- Загрузка
function love.load()
  love.graphics.setMode(wnd_w, wnd_h, false, true, 2)
  love.graphics.setCaption("TGL Reload")
  
  cam = camera(0, 0)
  
  gamestate.switch(title)
  gamestate.registerEvents({'keypressed', 'keyreleased'})
  
  --font = love.graphics.newImageFont('font_01.png', 'abcdefghijklmnopqrstuvwxyz!?.;,"`()1234567890 ')
  --love.graphics.setFont(font)
end

function love.keypressed(key)
  if key == "escape" then love.event.push('quit') end
end

-- Отрисовка отладочной информации
function debug_draw()
  love.graphics.printf('TGL Reload\nUnder development', 0, wnd_h - 48, wnd_w - 32, 'right')
  local x, y = cam:pos()
  love.graphics.print('FPS ' .. tostring(love.timer.getFPS()) .. '\nCamera position ' .. tostring(math.floor(x)) .. ' ' .. tostring(math.floor(y)), 32, 32)
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