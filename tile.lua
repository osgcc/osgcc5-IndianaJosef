-- Tile

-- Describes a single tile in the world

Type = {WALL = 0, EMPTY = 1, START = 2, BREAKABLE = 3, STAIR_LEFT = 4, STAIR_RIGHT = 5}

Tile = {tile_type = 0, action = 0, visible = true}

wall_img = love.graphics.newImage("img/wall.png")
breakable_img = love.graphics.newImage("img/breakable.png")
stair_left_img = love.graphics.newImage("img/stair_left.png")
stair_right_img = love.graphics.newImage("img/stair_right.png")

function Tile:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tile:with(type)
  if type == "." then
    self.tile_type = Type.WALL
  elseif type == "," then
    self.tile_type = Type.BREAKABLE
  elseif type == "/" then
    self.tile_type = Type.STAIR_LEFT
  elseif type == "\\" then
    self.tile_type = Type.STAIR_RIGHT
  elseif type == "*" then
    self.tile_type = Type.EMPTY
  elseif type == "%" then
    self.tile_type = Type.EMPTY
  elseif type == "+" then
    self.tile_type = Type.EMPTY
  elseif type == "~" then
    self.tile_type = Type.EMPTY
  else
    self.tile_type = Type.EMPTY
  end

  return self
end

function Tile:draw(x,y)
  if self.visible == false then
    return
  end

  if self.tile_type == Type.WALL then
    love.graphics.draw(wall_img, x, y)
  elseif self.tile_type == Type.BREAKABLE then
    love.graphics.draw(breakable_img, x, y)
  elseif self.tile_type == Type.STAIR_RIGHT then
    love.graphics.draw(stair_right_img, x, y)
  elseif self.tile_type == Type.STAIR_LEFT then
    love.graphics.draw(stair_left_img, x, y)
  end
end