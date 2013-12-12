
-- TGL Reload
-- icefairy64 (ishido.uu@gmail.com), 2013
-- Анимация объектов

local motion = {}

function motion:new()
  local temp = {}
  temp.points = {}
  temp.loop = false
  temp.active = false
  temp.clearSnap = false
  temp.timer = nil
  temp.anim = nil
  temp.parent = nil
  temp.state = { x = 0, y = 0, rotation = 0 }
  temp.snap = { x = 0, y = 0, rotation = 0 }
  temp.currentPoint = 1
  return temp
end

function motion:nextPart(target)
  local nextPoint = target.currentPoint + 1
  if (nextPoint <= #(target.points)) or target.loop then
    if target.loop and (nextPoint > #(target.points)) then 
      target.currentPoint = 1
      nextPoint = 2
      target.state = { x = 0, y = 0, rotation = 0 }
      if target.clearSnap then
        target.snap = { x = 0, y = 0, rotation = 0 }
      end
    end
    local nP, cP = target.points[nextPoint], target.points[target.currentPoint]
    local dt = nP.time - cP.time
    target.timer = timer.tween(dt, target.state, { x = nP.x, y = nP.y, rotation = nP.rotation }, nP.method, function() motion:nextPart(target) end)
    target.currentPoint = nextPoint
  end
end

function motion:start(target)
  target.active = true
  motion:nextPart(target)
end

function motion:stop(target)
  timer.cancel(target.timer)
  target.active = false
  target = nil
end

function motion:update(target, dt)
  if target.active then
    local delta = {}
    delta.x = target.state.x - target.snap.x
    delta.y = target.state.y - target.snap.y
    delta.rotation = target.state.rotation - target.snap.rotation
    target.parent.shape:move(delta.x, delta.y)
    target.parent.shape:rotate(delta.rotation / 180.0 * math.pi)
    target.snap.x = target.state.x
    target.snap.y = target.state.y
    target.snap.rotation = target.state.rotation
  end
end

return motion
