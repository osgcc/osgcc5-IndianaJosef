-- Tile

-- Describes a single tile in the world

Tile = {type = 0, action = 0}

function Tile:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tile:with(type)
  self.type = type
  return self
end