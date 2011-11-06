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

text = "foo"

function World:draw (x,y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      tile:draw((lx*32-32)-x, (ly*32-32)-y)
    end
  end

  love.graphics.print(text, 300, 300)
end

function World:with(map)
  self.map = map
  self.width = #self.map[1]
  self.height = #self.map

  self.physics = love.physics.newWorld(0,0,self.width*32,self.height*32)
  self.physics:setGravity(0, 1000)

  self.determine = function(a, b)
    local player, battery, wall, book, brain
    if a.type == "player" then
      player = a
    elseif b.type == "player" then
      player = b
    end

    if a.type == "battery" then
      battery = a
    elseif b.type == "battery" then
      battery = b
    end

    if a.type == "book" then
      book = a
    elseif b.type == "book" then
      book = b
    end

    if a.type == "brain" then
      brain = a
    elseif b.type == "brain" then
      brain = b
    end
    
    if a.type == "wall" then
      wall = a
    elseif b.type == "wall" then
      wall = b
    end
    return player,battery,wall,book,brain
  end

  self.add = function(a, b, coll)
    local player, battery, wall, book, brain = self.determine(a,b)

    if battery and player then
      if battery.visible == true then
        battery.visible = false
      end
    end

    if book and player then
      if book.visible == true then
        book.visible = false
      end
    end

    if brain and player then
      if brain.visible == true then
        brain.visible = false
      end
    end
  end

  self.persist = function(a, b, coll)
  end

  self.remove = function(a, b, coll)
    local player, battery, wall, book, brain = self.determine(a,b)

    if player and wall then
      -- determine if this is a wall blocking left and right velocity... if so, suppress forces!
      x = wall.body:getX()
      y = wall.body:getY()
      px = player.body:getX()
      py = player.body:getY()
      dist = math.sqrt((py-y)*(py-y))

      if dist > 32 then
      else
        if px > x then
          player:suppress_movement(-1)
        else
          player:suppress_movement(1)
        end
      end
    end
  end

  self.result = function(a, b, coll)
  end

  self.physics:setCallbacks(self.add, self.persist, self.remove, self.result)

  -- Set up rigid bodies

  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.tile_type == Type.WALL then
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

function World:find_wall(x, y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.tile_type == Type.WALL then
        if tile.shape:testPoint(x,y) then
          return tile
        end
      end
    end
  end
end