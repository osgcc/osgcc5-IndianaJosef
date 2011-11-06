-- Book

-- Represents a book object

Book = {visible = true}

--book_img = love.graphics.newImage("img/book.png")

function Book:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Book:with(position, world)
  self.body = love.physics.newBody(world.physics, position.x*32, position.y*32, 0, 0)
  self.shape = love.physics.newRectangleShape(self.body, -16, -16, 16, 16, 0)
  self.shape:setFriction(1.0)
  self.shape:setSensor(true)
  self.type = "book"
  self.shape:setData(self)

  return self
end

function Book:draw(x, y)
  if self.visible == false then
    return
  end

  local x1,y1,x2,y2 = self.shape:getPoints()

  love.graphics.setColor(255,255,0)
  love.graphics.rectangle("fill", x1-x, y1-y, 16, 16)
  --love.graphics.draw(book_img, x1-x, y1-y)
  love.graphics.setColor(255,255,255)
end