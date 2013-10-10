
-- TGL Reload
-- scootahoof (ishido.uu@gmail.com), 2013
-- Главный модуль

print('Loading HUMP')
gamestate = require "hump.gamestate"
vector = require "hump.vector"
camera = require "hump.camera"
timer = require "hump.timer"

print('Loading HardonCollider')
hc = require "HardonCollider"

print('Loading title screen')
title = require "title"
print('Loading Labyrinth')
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
  
  cam = camera(0, 0)
  
  gamestate.switch(title)
  gamestate.registerEvents({'keypressed', 'keyreleased'})
  
  font = love.graphics.newImageFont('font_01.png', 'abcdefghijklmnopqrstuvwxyz!?.;,"`()1234567890 ')
  love.graphics.setFont(font)
end

-- Отрисовка отладочной информации
function debug_draw()
  love.graphics.printf('tgl reload\nunder development', 0, wnd_h - 64, wnd_w - 32, 'right')
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