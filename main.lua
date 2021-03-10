local createCirc, changeCircle

function love.load()
  -- play-around values for randomness
  FUN_VAL = {1, 1, 200, 500, .1, .1, .1, 1, 1, 1, 6}
  SPLIT_SIZE = 1.2
  MAX_CIRCLES = 400
  
  lg = love.graphics
  lim = false
  Circs = {createCirc(400, 100, 110, {x=1, y=1}, 500)} -- initial circle
end

function love.update(dt)
  if dt <= 1 then
    if #Circs > MAX_CIRCLES then
      lim = true
    end
    for i = 1, #Circs do
      local circ = Circs[i]
        if circ.x >= lg.getWidth() - circ.r then
          changeCircle(Circs, circ, i, -3, lim, -1, 'x')
        elseif circ.x <= circ.r then
          changeCircle(Circs, circ, i, 3, lim, -1, 'x')
        end
        if circ.y >= lg.getHeight() - circ.r then
          changeCircle(Circs, circ, i, -3, lim, 1, 'y')
        elseif circ.y <= circ.r then
          changeCircle(Circs, circ, i, 3, lim, 1, 'y')
        end
      circ.x = circ.x + dt*circ.dir.x*circ.speed
      circ.y = circ.y + dt*circ.dir.y*circ.speed
    end
  end
end


function love.draw()
  if #Circs % math.random(FUN_VAL[11]) == 0 then
    local r, g, b = math.random(FUN_VAL[5], FUN_VAL[8]), math.random(FUN_VAL[6], FUN_VAL[9]), math.random(FUN_VAL[7], FUN_VAL[10])
    lg.setColor(r, g, b)
  end
  for i = 1, #Circs do
    lg.circle(Circs[i].mode, Circs[i].x, Circs[i].y, Circs[i].r)
  end
end


createCirc = function(x, y, r, dir, speed) -- dir - 2D key-val table
  return {mode="fill", x=x, y=y, r=r, dir=dir, speed=speed}
end

changeCircle = function(Circs, circ, i, inc, lim, inv_y, xy)
  local spd = math.random(FUN_VAL[3], FUN_VAL[4])
  if lim then
    circ[xy] = circ[xy] + inc
    circ.dir[xy] = -circ.dir[xy]
    circ.speed = spd
  else
    Circs[#Circs+1] = createCirc(circ.x, circ.y+inc, circ.r/SPLIT_SIZE, {x=-circ.dir.x*math.random(FUN_VAL[1], FUN_VAL[2]), y=-circ.dir.y*inv_y*math.random(FUN_VAL[1], FUN_VAL[2])}, spd)
    Circs[#Circs+1] = createCirc(circ.x, circ.y+inc, circ.r/SPLIT_SIZE, {x=-circ.dir.x*-inv_y*math.random(FUN_VAL[1], FUN_VAL[2]), y=-circ.dir.y*math.random(FUN_VAL[1], FUN_VAL[2])}, spd)
    table.remove(Circs, i)
  end
end