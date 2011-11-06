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
      local tile = self.map[ly][lx]
      tile:draw((lx*32-32)-x, (ly*32-32)-y)
    end
  end
end

function World:with(map)
  self.map = map
  self.width = #self.map[1]
  self.height = #self.map

  self.physics = love.physics.newWorld(0,0,self.width*32,self.height*32)
  self.physics:setGravity(0, 1000)

  -- Set up rigid bodies

  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.type == Type.WALL then
        tile.body = love.physics.newBody(self.physics, lx*32, ly*32, 0, 0)
        tile.shape = love.physics.newRectangleShape(tile.body, -16, -16, 32, 32, 0)
        tile.shape:setFriction(1.0)
        tile.type = "wall"
        tile.shape:setData(tile)
      end
    end
  end

  return self
end