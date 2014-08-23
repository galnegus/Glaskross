BoxyBeamPattern = Class{}

function BoxyBeamPattern:init(source)
    self._beams = {}
    self._i = 1

    self._done = false
    self._source = source
end

-- x and y represent the position of the floor section that will be beamed,
-- check World:getFloorSection() for more info
function BoxyBeamPattern:add(x, y, delay)
    assert(delay >= 0, "delay must be greater than or equal to 0")

    table.insert(self._beams, {x = x, y = y, delay = delay})
end

function BoxyBeamPattern:_nextBeam(callback)
    local beam = self._beams[self._i]
    Signal.emit("area beam", beam.x, beam.y, self._source, 100, 50, 50)

    -- increment counter
    self._i = self._i + 1
    local i = self._i -- needed for conditional statement below
    self._i = self._i > #self._beams and 1 or self._i

    if i > #self._beams then
        -- and we're done! go to callback function (if there is one)
        if callback ~= nil then
            callback()
        end
    else
        beam = self._beams[self._i]

        -- next beam!
        if beam.delay == 0 then
            self:_nextBeam(callback)
        else
            gameTimer:add(beam.delay, function() self:_nextBeam(callback) end)
        end
    end
end

function BoxyBeamPattern:start(callback)
    if #self._beams == 0 then
        error("this beam pattern contains no beams! add them before starting!")
    end

    local beam = self._beams[self._i]
    if beam.delay == 0 then
        self:_nextBeam(callback)
    else
        gameTimer:add(beam.delay, function() self:_nextBeam(callback) end)
    end
end