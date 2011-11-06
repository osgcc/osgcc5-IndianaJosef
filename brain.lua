-- Brain

-- Represents a Brain object

Brain = {visible = true}

function Brain:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Brain:with(position, world)
  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 0, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 16, 16, 0)
  self.shape:setFriction(1.0)
  self.shape:setSensor(true)
  self.type = "brain"
  self.shape:setData(self)

  return self
end

function Brain:draw(x, y)
  if self.visible == false then
    return
  end

  local x1,y1,x2,y2 = self.shape:getPoints()

  love.graphics.setColor(255,0,255)
  love.graphics.rectangle("fill", x1-x, y1-y, 16, 16)
  love.graphics.setColor(255,255,255)
end