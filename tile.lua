-- Tile

-- Describes a single tile in the world

Type = {WALL = 0, EMPTY = 1, START = 2, BREAKABLE = 3, STAIR_LEFT = 4, STAIR_RIGHT = 5, DEADLY = 6}

Tile = {tile_type = 0, action = 0, visible = true, stop = false, width = 1}

wall_img = love.graphics.newImage("img/wall.png")
breakable_img = love.graphics.newImage("img/breakable.png")
stair_left_img = love.graphics.newImage("img/stair_left.png")
stair_right_img = love.graphics.newImage("img/stair_right.png")
deadly_imgs = {lava = love.graphics.newImage("img/lava.png"), spikes = love.graphics.newImage("img/spikes.png")}

function Tile:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tile:with(type)
  self.tile_type = Type.EMPTY
  if type == "." or type == "Q" or type == "W" or type == "E" or type == "R" then
    self.tile_type = Type.WALL
  elseif type == "!" or type == "@" or type == "#" or type == "$" then
    self.tile_type = Type.WALL
    self.visible = false
  elseif type == "," then
    self.tile_type = Type.BREAKABLE
  elseif type == "/" then
    self.tile_type = Type.STAIR_LEFT
  elseif type == "\\" then
    self.tile_type = Type.STAIR_RIGHT
  elseif type == "|" then
    self.stop = true
  elseif type == "w" then
    self.stop = true
  elseif type == "a" then
    self.stop = true
  elseif type == "s" then
    self.stop = true
  elseif type == "d" then
    self.stop = true
  elseif type == "~" then
    self.tile_type = Type.DEADLY
    self.deadly_type = "lava"
  elseif type == "X" then
    self.tile_type = Type.DEADLY
    self.deadly_type = "spikes"
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
  elseif self.tile_type == Type.DEADLY then
    love.graphics.draw(deadly_imgs[self.deadly_type], x, y)
  end
end