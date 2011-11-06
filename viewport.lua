-- Viewport

-- Represents the current view of the world

Viewport = {x = 0, y = 0}

function Viewport:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Viewport:draw(obj)
  obj:draw(self.x, self.y)
end