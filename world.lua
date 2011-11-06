-- World

-- Holds and manipulates the tiles that represent the world

require "loader"
require "tile"

World = {width = 0, height = 0}

bg_img = love.graphics.newImage("img/bg.png")

function World:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

text = ""
last_pos = {x=0,y=0}
last_pos2 = {x=0, y=0}

function World:drawBackground(x,y)
  love.graphics.draw(bg_img, x, y)
end

function World:draw (x,y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      tile:draw((lx*32-32)-x, (ly*32-32)-y)
    end
  end

  love.graphics.print(text, 300, 300)
  love.graphics.rectangle("fill", last_pos.x-x-3,last_pos.y-y-3,6,6)
  love.graphics.rectangle("fill", last_pos2.x-x-3,last_pos2.y-y-3,6,6)
end

function World:with(map)
  self.map = map
  self.width = #self.map[1]
  self.height = #self.map

  self.physics = love.physics.newWorld(0,0,self.width*32,self.height*32)
  self.physics:setGravity(0, 0)

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
        player.energy = player.energy + 25
      end
    end

    if book and player then
      if book.visible == true then
        book.visible = false
        player.books = player.books + 1
      end
    end

    if brain and player then
      if brain.visible == true then
        brain.visible = false
        player.brain = 1
      end
    end
  end

  self.persist = function(a, b, coll)
  end

  self.remove = function(a, b, coll)
  end

  self.result = function(a, b, coll)
  end

  self.physics:setCallbacks(self.add, self.persist, self.remove, self.result)

  -- Set up rigid bodies

  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.tile_type ~= Type.EMPTY or tile.stop then
        tile.body = love.physics.newBody(self.physics, lx*32, ly*32, 0, 0)
        local x, y = -16,-16
        if tile.tile_type == Type.STAIR_RIGHT then
          tile.shape = love.physics.newPolygonShape(tile.body, -32, -32, -24, -32, -24, -24, -16, -24, -16, -16, -8, -16, -8, -8, 0, -8, 0, 0, -32, 0)
        else
          tile.shape = love.physics.newRectangleShape(tile.body, -16, -16, 32, 32, 0)
        end
        tile.shape:setSensor(true)
        tile.shape:setFriction(1.0)
        tile.type = "wall"
        tile.shape:setData(tile)
      end
    end
  end

  return self
end

function World:foo(bar)
  text = bar
end

function World:find_stop(x, y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.stop and tile.visible then
        if tile.shape:testPoint(x,y) then
          return tile
        end
      end
    end
  end
end

function World:find_wall(x, y)
  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.tile_type ~= Type.EMPTY and tile.visible then
        if tile.shape:testPoint(x,y) then
          return tile
        end
      end
    end
  end
end

function World:find_deadly(l, r, y)
  local left = false
  local right = false

  for lx=1,self.width do
    for ly = 1,self.height do
      local tile = self.map[ly][lx]
      if tile.tile_type ~= Type.EMPTY and tile.visible then
        if tile.shape:testPoint(l,y) and tile.tile_type == Type.DEADLY then
          left = true
        end
        if tile.shape:testPoint(r,y) and tile.tile_type == Type.DEADLY then
          right = true
        end
        if left and right then
          return true
        end
      end
    end
  end

  return left and right
end