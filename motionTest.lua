
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Просмотр анимаций

local motionTest = {}

local test = {}

function motionTest:enter()
  cam:lookAt(0, 0)
  player = bases.playerLab(0, 0)
  test = motion:new()
  local meth = 'linear'
  table.insert(test.points, { time = 0.0, x = 0, y = 0, rotation = 0, method = meth })
  table.insert(test.points, { time = 0.1, x = 70, y = 0, rotation = 0, method = meth })
  table.insert(test.points, { time = 0.4, x = 210, y = 0, rotation = 0, method = meth })
  table.insert(test.points, { time = 0.5, x = 280, y = 0, rotation = 0, method = meth })
  table.insert(test.points, { time = 0.8, x = 420, y = 0, rotation = 0, method = meth })
  test.loop = true
  --test.clearSnap = true
  test.parent = player
  motion:start(test)
end

function motionTest:leave()
  player = nil
end

function motionTest:update(dt)
  motion:update(test, dt)
end

function motionTest:draw()
  player.shape:draw('line')
end

function motionTest:keypressed(key)
  if key == 'm' then
    gamestate.switch(title)
  end
end

return motionTest
