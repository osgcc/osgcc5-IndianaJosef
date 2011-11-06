-- Hud

-- Represents the heads-up-display content

Hud = {}

function Hud:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Hud:draw(x, y, energy, knowledge, kmax, brain)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", x,y, 800, 40)
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle("fill", x,y, 800, 40)
  love.graphics.setColor(255, 255, 255)

  energy = math.floor(energy + 0.5)
  local estr = energy
  if estr < 0 then
    estr = "000"
  elseif estr < 10 then
    estr = "00" .. energy
  elseif estr < 100 then
    estr = "0" .. energy
  end

  kmaxstr = kmax
  if kmaxstr < 10 then
    kmaxstr = "00" .. kmax
  elseif kmaxstr < 100 then
    kmaxstr = "0" .. kmax
  end

  kstr = knowledge
  if kstr < 10 then
    kstr = "00" .. knowledge
  elseif kstr < 100 then
    kstr = "0" .. knowledge
  end

  love.graphics.print("Energy: " .. estr, x+40, y+15)
  love.graphics.print("Knowledge: " .. kstr .. "/" .. kmaxstr, x+170, y+15)

  if energy <= 0 then
    love.graphics.print("You LOSE!", x+350, y+15)
  elseif brain and knowledge == kmax then
    love.graphics.print("You WIN!", x+350, y+15)
  elseif brain then
    love.graphics.print("Found the BRAIN!", x+350, y+15)
  else
    love.graphics.print("Find: ", x+350, y+15)
    love.graphics.print("BRAIN", x+385, y+15)
  end
end