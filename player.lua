-- Player

-- Represents the player

Player = {start = {x=0, y=0}, direction = 1, direction_y = 1, energy = 180, books = 0, brain = 0}

function Player:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Player:with(position, world)
  self.start = position

  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 10, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 32, 32, 0)
  self.shape:setFriction(1.0)

  self.type = "player"
  self.shape:setData(self)

  return self
end

function Player:draw(x, y)
  local r, b = self.body:getPosition()
  local l, t = r-32, b-32

  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", l-x, t-y, 32, 32)
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", l-x-3, t-y-3, 6, 6)
  love.graphics.rectangle("fill", r-x-3, b-y-3, 6, 6)
end

function Player:move_y(delta, world)
  local y = self.body:getY()

  if delta > 0 then
    self.direction_y = 1
  else
    self.direction_y = -1
  end

  world:foo("IS_COLLIDED?!?"..os.clock().." : "..delta.. " : ".. y+delta)
  self.body:setY(y + delta)
  wall = self:is_collided_y(y+delta,world)
  if wall then
    self:avoid_y(wall)
    return true
  end
end

function Player:move(delta, world)
  local x = self.body:getX()

  if delta > 0 then
    self.direction = 1
  else
    self.direction = -1
  end

  self.body:setX(x + delta)
  wall = self:is_collided(x+delta,world)
  if wall then
    self:avoid(wall)
  end
end

function Player:is_collided(x, world)
  local xp, y = self.body:getPosition()

  if self.direction == 1 then
    wall = world:find_wall(x+1,y-1)
    if wall then
      return wall
    end

    wall = world:find_wall(x+1,y-31)
    if wall then
      return wall
    end
  end

  if self.direction == -1 then
    wall = world:find_wall(x-33,y-1)
    if wall then
      return wall
    end

    wall = world:find_wall(x-33,y-31)
    if wall then
      return wall
    end
  end
end

function Player:is_collided_y(y,world)
  local x, yp = self.body:getPosition()

  if self.direction_y == 1 then
    wall = world:find_wall(x-1,y+1)
    if wall then
      return wall
    end

    wall = world:find_wall(x-31,y+1)
    if wall then
      return wall
    end
  end

  if self.direction_y == -1 then
    wall = world:find_wall(x-1,y-33)
    if wall then
      return wall
    end

    wall = world:find_wall(x-31,y-33)
    if wall then
      return wall
    end
  end
end

function Player:rest()
  local vx, vy = self.body:getLinearVelocity()
  self.body:setLinearVelocity(0, vy)
end

function Player:align()
  local x, y = self.body:getPosition()

  x = math.floor(x+0.5)

  local diff = x % 4

  if diff < 2 then
    x = x - diff
  else
    x = x + (4-diff)
  end

  self.body:setX(x)
end

function Player:burn(world)
  local x, y = self.body:getPosition()
  local px = x

  if self.direction < 0 then
    x = x - 4
    px = px - 31
  else
    x = x - 32 + 4
    px = px - 1
  end

  local wall = world:find_wall(px, y+1)
  local wall_break = world:find_wall(x, y+1)

  if wall == nil or wall.visible == false or wall.tile_type == Type.EMPTY or wall == wall_break then
    return
  end

  if wall_break and wall_break.tile_type == Type.BREAKABLE then
    wall_break.visible = false
  end
end

function Player:avoid(wall)
  local r, b = self.body:getPosition()
  local l, t = r - 32, b - 32
  local wr, wb = wall.body:getPosition()
  local wl, wt = wr - 32, wb - 32

  if (l > wl and l < wr) or (r > wl and r < wr) then
    if self.direction == 1 then
      self.body:setX(wr-32)
    else
      self.body:setX(wr+32)
    end
  end
end

function Player:avoid_y(wall)
  local r, b = self.body:getPosition()
  local l, t = r - 32, b - 32
  local wr, wb = wall.body:getPosition()
  local wl, wt = wr - 32, wb - 32

  if (t > wt and t < wb) or (b > wt and b < wb) then
    if self.direction_y == 1 then
      self.body:setY(wb-32)
    else
      self.body:setY(wb+32)
    end
  end
end