-- Viewport

-- Represents the current view of the world

Viewport = {x = 0, y = 0}

function Viewport:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Viewport:with(world_width, world_height, width, height)
  self.world_width = world_width
  self.world_height = world_height
  self.width = width
  self.height = height

  return self
end

function Viewport:center(x, y)
  self.x = x - (self.width/2)
  self.y = y - (self.height/2)

  if self.x < 0 then
    self.x = 0
  end

  if self.y < 0 then
    self.y = 0
  end

  if self.x + self.width > self.world_width then
    self.x = self.world_width - self.width
  end

  if self.y + self.height > self.world_height then
    self.y = self.world_height - self.height
  end
end

function Viewport:draw(obj)
  obj:draw(self.x, self.y)
end