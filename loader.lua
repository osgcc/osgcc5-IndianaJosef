-- Loader

-- Loads a world from a file

require "tile"

Loader = {}

function Loader:load(filename)
  local f = assert(io.open(filename, "r"))

  local ret = {}

  local y = 2
  local start = {x = 1, y = 1}

  local batteries = {}
  local books = {}
  local brain = {x = 1, y = 1}
  local energy = 150

  for line in f:lines() do
    if line:sub(1,1) == "e" then
      energy = line:sub(3, #line) + 0
    else
      local row = {}
      row[1] = Tile:new():with('.')

      for i=1,#line do
        local chr = line:sub(i,i)
        if chr == "*" then
          start = {x = i+1, y = y}
        elseif chr == "+" then
          batteries[#batteries+1] = {x = i+1, y = y}
        elseif chr == "%" then
          books[#books+1] = {x = i+1, y = y}
        elseif chr == "~" then
          brain = {x = i+1, y = y}
        end
        row[i+1] = Tile:new():with(chr)
      end

      row[#line+2] = Tile:new():with('.')

      ret[y] = row
      y = y + 1
    end
  end

  ret[1] = {}
  for i=1,#ret[2] do
    ret[1][i] = Tile:new():with('.')
  end

  local map = ret

  ret = {}
  ret.map = map
  ret.start = start
  ret.batteries = batteries
  ret.books = books
  ret.brain = brain
  ret.energy = energy

  return ret
end