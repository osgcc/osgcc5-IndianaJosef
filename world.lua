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
      debug.debug()

      if self.map[ly][lx].type == "." then
        style = "fill"
      end

      love.graphics.rectangle(style, x+lx*32-32, y+ly*32-32, 32, 32)
    end
  end
end

function World:load(filename)
  self.map = Loader:load(filename)
  self.width = #self.map[1]
  self.height = #self.map
end