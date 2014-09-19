BoxyBeamPattern = Class{}
BoxyBeamPattern:include(Pattern)

function BoxyBeamPattern:init()
    Pattern.init(self)
end

function BoxyBeamPattern:add(x, y, delay, duration)
    assert(delay >= 0, "delay must be greater than or equal to 0")

    table.insert(self._data, {x = x, y = y, delay = delay, duration = duration})
end

function BoxyBeamPattern:boom(entry)
    Signal.emit(Signals.AREA_BEAM, entry.x, entry.y, entry.duration)
end