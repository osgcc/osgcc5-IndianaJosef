-- Tile

-- Describes a single tile in the world

Type = {WALL = 0, EMPTY = 1, START = 2}

Tile = {tile_type = 0, action = 0}

function Tile:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tile:with(type)
  if type == "." then
    self.tile_type = Type.WALL
  elseif type == "*" then
    self.tile_type = Type.EMPTY
  else
    self.tile_type = Type.EMPTY
  end

  return self
end

function Tile:draw(x,y)
  local style = "line"

  if self.tile_type == Type.WALL then
    style = "fill"
  end

  if self.tile_type == Type.WALL then
    love.graphics.rectangle(style, x, y, 32, 32)
  end
end