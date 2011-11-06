-- Player

-- Represents the player

Player = {start = {x=0, y=0}}

function Player:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Player:with(position, world)
  self.start = position

  self.body = love.physics.newBody(world.physics, (position.x*32-32)+16, (position.y*32-32)+16, 10, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 32, 32, 0)
  return self
end

function Player:draw(x, y)
  local x1,y1,x2,y2 = self.shape:getPoints()

  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", x1-x, y1-y, 32, 32)
  love.graphics.setColor(255,255,255)
end

function Player:move(delta)
  local x = self.body:getX()
  x = x + delta

  self.body:setX(x)
end