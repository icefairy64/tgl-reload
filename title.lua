
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Стартовый экран

local title = {}
local stars = {}
local text_opacity = 0
local text_phase = 0

-- Помощники

start = function ()
  gamestate.switch(labyrinth) 
end

-- Методы

-- Инициализация
function title:init()
  for i = 1, 2000 do
    table.insert(stars, {math.random(wnd_w), math.random(wnd_h), math.random(255), math.random(255), math.random(255) + 256})
  end
end

-- Вход в меню
function title:enter()
  cam:lookAt(wnd_w / 2, wnd_h / 2)
  fade = {0, 0, 0, 255}
    timer.tween(2, fade, {[4] = 0}, 'out-quad')
end

-- Шаг
function title:update(dt)
  for i = 1, #stars do
    stars[i][4] = stars[i][4] + stars[i][5] / 10240
    stars[i][1] = (stars[i][1] - stars[i][3] / 70) % wnd_w
  end
  text_phase = text_phase + 0.05
  text_opacity = (math.sin(text_phase) * 128) + 127
end

-- Отрисовка
function title:draw()
  for i = 1, #stars do
    love.graphics.setColor(255, 255, 255, ((math.sin(stars[i][4]) * (stars[i][3] / 2)) + (stars[i][3] / 2)) * 0.7)
    love.graphics.point(stars[i][1], stars[i][2])
  end
  love.graphics.setColor(255, 255, 255, text_opacity)
  love.graphics.print('Press Enter', 128, wnd_h / 2)
end

-- Нажатие кнопки
function title:keypressed(key)
  if key == 'return' then
    fade = {255, 255, 255, 0}
    timer.tween(0.5, fade, {[4] = 255}, 'out-quad', start)
  end
end

function title:keyreleased(key)
  
end

return title