-- World

-- Holds and manipulates the tiles that represent the world

require "loader"
require "tile"

World = {width = 0, height = 0}

function World:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function World:draw (x,y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local style = "line"

      self.map[ly][lx]:draw((lx*32-32)-x, (ly*32-32)-y)
    end
  end
end

function World:with(map)
  self.map = map
  self.width = #self.map[1]
  self.height = #self.map

  self.physics = love.physics.newWorld(0,0,self.width*32,self.height*32)
  self.physics:setGravity(0, 250)
  self.physics:setMeter(32)
  
  -- Set up rigid bodies

  return self
end