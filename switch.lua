-- Switch

-- Represents a switch object

Switch = {visible = true, state = "off"}

switch_off_img = love.graphics.newImage("img/switch_off.png")
switch_on_img = love.graphics.newImage("img/switch_on.png")

function Switch:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Switch:with(position, tag, tiles, world)
  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 0, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 32, 32, 0)
  self.tag = tag
  self.tiles = tiles
  self.shape:setFriction(1.0)
  self.shape:setSensor(true)
  self.type = "switch"
  self.shape:setData(self)

  return self
end

function Switch:is_collided_with_player(player)
  local r = player:getX()
  local b = player:getY() - 1
  local l = r - 32
  local t = b - 30

  return self.shape:testPoint(r,b) or self.shape:testPoint(r,t) or self.shape:testPoint(l,b) or self.shape:testPoint(l,t)
end

function Switch:toggle()
  if self.state == "off" then
    self.state = "on"
  else
    self.state = "off"
  end
  for i=1,#self.tiles do
    self.tiles[i].obj.visible = not self.tiles[i].obj.visible
  end
end

function Switch:draw(x, y)
  if self.visible == false then
    return
  end

  local x1,y1,x2,y2 = self.shape:getPoints()

  if self.state == "off" then
    love.graphics.draw(switch_off_img, x1-x, y1-y)
  else
    love.graphics.draw(switch_on_img, x1-x, y1-y)
  end
end