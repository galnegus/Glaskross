BoxyAIComponent = Class{}
BoxyAIComponent:include(Component)

function BoxyAIComponent:init()
    self.type = "ai"

    self._beams = {}

    beamPattern = BoxyBeamPattern(self)

    beamPattern:add(1, 1, 1)
    beamPattern:add(1, 2, 0)

    beamPattern:add(3, 1, 1)
    beamPattern:add(3, 2, 0)

    beamPattern:add(2, 1, 1)
    beamPattern:add(2, 2, 0)

    beamPattern:add(4, 1, 1)
    beamPattern:add(4, 2, 0)

    beamPattern2 = BoxyBeamPattern(self)

    beamPattern2:add(1, 1, 1)
    beamPattern2:add(2, 2, 0.25)
    beamPattern2:add(3, 1, 0.25)
    beamPattern2:add(4, 2, 0.25)
    beamPattern2:add(1, 2, 0.25)
    beamPattern2:add(2, 1, 0.25)
    beamPattern2:add(3, 2, 0.25)
    beamPattern2:add(4, 1, 0.25)

    beamPattern3 = BoxyBeamPattern(self)
    beamPattern3:add(1, 1, 2)
    beamPattern3:add(2, 1, 0)
    beamPattern3:add(3, 1, 0)
    beamPattern3:add(4, 1, 0)
    beamPattern3:add(1, 2, 0)
    beamPattern3:add(2, 2, 0)
    beamPattern3:add(3, 2, 0)
    beamPattern3:add(4, 2, 0)

    chain = PatternChainer()

    chain:add(beamPattern)
    chain:add(beamPattern2)
    chain:add(beamPattern)
    chain:add(beamPattern3)

    chain:start()

    --beamPattern:start(function() beamPattern:start() end)
end

function BoxyAIComponent:update(dt)

end

