-- Loader

-- Loads a world from a file

require "tile"

Loader = {}

function Loader:load(filename)
  local f = assert(io.open(filename, "r"))

  local ret = {}

  local y = 2

  for line in f:lines() do
    local row = {}
    row[1] = Tile:new():with('.')

    for i=1,#line do
      local chr = line:sub(i,i)
      row[i+1] = Tile:new():with(chr)
    end

    row[#line+2] = Tile:new():with('.')

    ret[y] = row
    y = y + 1
  end
  
  ret[1] = {}
  for i=1,#ret[2] do
    ret[1][i] = Tile:new():with('.')
  end

  return ret
end