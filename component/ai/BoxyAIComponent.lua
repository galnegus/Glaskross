BoxyAIComponent = Class{}
BoxyAIComponent:include(Component)

function BoxyAIComponent:init()
    Component.init(self)

    self.type = "ai"


    self._beams = {}
    -- first beam needs to have 2 sec delay

    s_x1y1r = BoxyBeamPattern()
    s_x1y1r:add(1, 1, 2)
    s_x1y1r:add(2, 1, 0.5)
    s_x1y1r:add(3, 1, 0.5)
    s_x1y1r:add(4, 1, 0.5)

    x4y3l = BoxyBeamPattern()
    x4y3l:add(4, 3, 1)
    x4y3l:add(3, 3, 0.5)
    x4y3l:add(2, 3, 0.5)
    x4y3l:add(1, 3, 0.5)

    x1y2r = BoxyBeamPattern()
    x1y2r:add(1, 2, 1)
    x1y2r:add(2, 2, 0.5)
    x1y2r:add(3, 2, 0.5)
    x1y2r:add(4, 2, 0.5)

    chain = PatternChainer()

    chain:add(s_x1y1r)
    chain:add(x4y3l)
    chain:add(x1y2r)

    chain:start()

    death1 = DeathWallPattern()
    death1:add(1, 0, 0, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 2, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)

    death1:start()

    gameTimer:add(6, function() 
        Signal.emit(Signals.BOXY_NEXT_PHASE)
        gameTimer:add(6, function() 
            Signal.emit(Signals.BOXY_NEXT_PHASE)
            gameTimer:add(6, function() 
                Signal.emit(Signals.BOXY_NEXT_PHASE) 
                gameTimer:add(6, function() 
                    Signal.emit(Signals.BOXY_NEXT_PHASE) 
                end)
            end)
        end)
    end)
    
    
    

    --Signal.emit("add entity", EntityCreator.create("death wall", 0, 1))
    --Signal.emit("add entity", EntityCreator.create("death wall", 0, -1))

    --beamPattern:start(function() beamPattern:start() end)
end