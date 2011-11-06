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
  local elevators = {}

  local last_elevator = nil
  local switches = {}

  for i=1,4 do
    switches[i] = {}
    switches[i].tags = {}
  end

  for line in f:lines() do
    if line:sub(1,1) == "e" then
      energy = line:sub(3, #line) + 0
    else
      local row = {}
      row[1] = Tile:new():with('.')

      for i=1,#line do
        local chr = line:sub(i,i)

        row[i+1] = Tile:new():with(chr)
        if last_elevator and last_elevator.chr == chr then
          last_elevator.obj.width = last_elevator.obj.width + 1
        else
          last_elevator = nil
          if chr == "o" then
            start = {x = i+1, y = y}
          elseif chr == "+" then
            batteries[#batteries+1] = {x = i+1, y = y}
          elseif chr == "{" then
            books[#books+1] = {x = i+1, y = y}
          elseif chr == "G" then
            brain = {x = i+1, y = y}
          elseif chr == "w" or chr == "a" or chr == "s" or chr == "d" then
            local elevator = {x = i+1, y = y, width = 1, direction = chr, ignore_tile = row[i+1]}
            last_elevator = {chr=chr, obj=elevator}

            elevators[#elevators+1] = elevator
          elseif chr == "Q" then
            switches[1].tags[#switches[1].tags+1] = {x = i+1, y = y, obj = row[i+1]}
          elseif chr == "W" then
            switches[2].tags[#switches[2].tags+1] = {x = i+1, y = y, obj = row[i+1]}
          elseif chr == "E" then
            switches[3].tags[#switches[3].tags+1] = {x = i+1, y = y, obj = row[i+1]}
          elseif chr == "R" then
            switches[4].tags[#switches[4].tags+1] = {x = i+1, y = y, obj = row[i+1]}
          elseif chr == "1" or chr == "2" or chr == "3" or chr == "4" then
            switches[chr + 0].pos = {x=i+1, y = y}
          end
        end
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
  ret.switches = switches
  ret.elevators = elevators

  return ret
end