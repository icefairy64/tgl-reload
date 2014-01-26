
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2014
-- Анимация спрайтов

local anim = {}

function anim:new()
  local temp = {}
  temp.points = {}
  temp.frames = {}
  temp.loop = true
  temp.timer = nil
  temp.speed = 1.0
  temp.parent = nil
  temp.currentPoint = 1
  return temp
end

function anim:nextFrame(target)
  local nextPoint = target.currentPoint + 1
  if (nextPoint > #(target.points)) then
    if target.loop then
      target.currentPoint = 1
      nextPoint = 2
    else
      anim:stop(target)
      return nil
    end
  end
  local cP, nP = target.points[target.currentPoint], target.points[nextPoint]
  if target.speed > 0.0001 then
    dt = (nP - cP) * target.speed
    target.timer = timer.add(dt, function() anim:nextFrame(target) end)
  end
  target.currentPoint = nextPoint
end

function anim:start(target)
  target.speed = 1.0
  anim:nextFrame(target)
end

function anim:stop(target)
  timer.cancel(target.timer)
  target.speed = 0.0
  target = nil
end

function anim:draw(target, x, y)
  love.graphics.draw(target.frames[target.currentPoint - 1], x, y, 0, 1, 1, 0, target.frames[target.currentPoint - 1]:getHeight())
end

return anim
