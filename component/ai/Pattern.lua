Pattern = Class{}

function Pattern:init()
  self._data = {}
  self._i = 1

  self._done = false
end

-- x and y represent the position of the floor section that will be beamed,
-- check World:getFloorSection() for more info
function Pattern:add(x, y, delay)
  error("override this, remember parameters x, y and delay are mandatory")
end

function Pattern:boom(entry)
  error("override this")
end

function Pattern:_nextBeam(callback)
  local beam = self._data[self._i]
  assert(beam.x and beam.y and beam.delay, "parameter missing from pattern")

  self:boom(beam)

  -- increment counter
  self._i = self._i + 1
  local i = self._i -- needed for conditional statement below
  self._i = self._i > #self._data and 1 or self._i

  if i > #self._data then
    -- and we're done! go to callback function (if there is one)
    if callback ~= nil then
      callback()
    end
  else
    beam = self._data[self._i]

    -- next beam!
    if beam.delay == 0 then
      self:_nextBeam(callback)
    else
      game.timer.after(beam.delay, function() self:_nextBeam(callback) end)
    end
  end
end

function Pattern:start(callback)
  assert(#self._data ~= 0, "this beam pattern contains no beams! add them before starting!")

  local beam = self._data[self._i]
  if beam.delay == 0 then
    self:_nextBeam(callback)
  else
    game.timer.after(beam.delay, function() self:_nextBeam(callback) end)
  end
end