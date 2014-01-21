
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Стартовый экран

local title = {}
local stars = {}
local text_opacity = 0
local text_phase = 0
local speed = {0}
local angle = (math.pi) - 0.3

-- Помощники

start = function ()
  gamestate.switch(labyrinth, true) 
end

-- Методы

-- Инициализация
function title:init()
  for i = 1, 700 do
    table.insert(stars, { math.random(wnd_w + math.abs(2 * wnd_w * math.sin(angle))) - math.abs(wnd_w * math.sin(angle)),
                          math.random(wnd_h),
                          math.random(255),
                          math.random(255),
                          math.random(255) + 256 })
  end
end

-- Вход в меню
function title:enter()
  cam:lookAt(wnd_w / 2, wnd_h / 2)
  fade = {0, 0, 0, 255}
  timer.tween(2, fade, {[4] = 0}, 'out-quad')
  timer.tween(5, speed, {[1] = 4}, 'out-quad')
end

-- Шаг
function title:update(dt)
  for i = 1, #stars do
    stars[i][4] = stars[i][4] + (stars[i][5] / 10240 * dt * 60)
    stars[i][2] = (stars[i][2] - stars[i][3] * speed[1] * (dt * 60) / 70) % (wnd_h / math.cos(angle))
  end
  text_phase = text_phase + 0.05 * (dt * 60)
  text_opacity = (math.sin(text_phase) * 128) + 127
end

-- Отрисовка
function title:draw()
  love.graphics.setColor(255, 255, 255, 255)
  for i = 1, #stars do
    love.graphics.setColor(255, 255, 255, ((math.sin(stars[i][4]) * (stars[i][3] / 2)) + (stars[i][3] / 2)) * 0.7)
    love.graphics.rectangle("fill", stars[i][1] + (stars[i][2] * math.sin(angle)), stars[i][2] * math.cos(angle), 2, 2)
  end
  love.graphics.setColor(255, 255, 255, text_opacity)
  love.graphics.print('Press Enter to enter game ("E" in-game: editor)\nPress M to open motion test', 128, wnd_h / 2)
end

-- Нажатие кнопки
function title:keypressed(key)
  if key == 'return' then
    fade = {255, 255, 255, 0}
    timer.tween(0.5, fade, {[4] = 255}, 'out-quad', start)
  end if key == 'm' then
    gamestate.switch(motionTest)
  end
end

function title:keyreleased(key)
  
end

return title
