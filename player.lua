-- Player

-- Represents the player

Player = {x = 0, y = 0, start = {x=0, y=0}}

function Player:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Player:with(position)
  self.start = position
  self.x = position.x*32-32
  self.y = position.y*32-32
  return self
end

function Player:draw(x, y)
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", self.x-x, self.y-y, 32, 32)
  love.graphics.setColor(255,255,255)
end