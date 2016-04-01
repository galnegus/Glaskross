BoxyAIComponent = Class{}
BoxyAIComponent:include(Component)

function BoxyAIComponent:init()
    Component.init(self)

    self.type = ComponentTypes.AI


    self._beams = {}
    -- first beam needs to have 2 sec delay

    s_x1y1r = BoxyBeamPattern()
    s_x1y1r:add(1, 1, 2)
    s_x1y1r:add(2, 1, 0.5)
    s_x1y1r:add(3, 1, 0.5)
    s_x1y1r:add(4, 1, 0.5)
    s_x1y1r:add(5, 1, 0.5)

    x5y3l = BoxyBeamPattern()
    x5y3l:add(5, 3, 1)
    x5y3l:add(4, 3, 0.5)
    x5y3l:add(3, 3, 0.5)
    x5y3l:add(2, 3, 0.5)
    x5y3l:add(1, 3, 0.5)

    x1y2r = BoxyBeamPattern()
    x1y2r:add(1, 2, 1)
    x1y2r:add(2, 2, 0.5)
    x1y2r:add(3, 2, 0.5)
    x1y2r:add(4, 2, 0.5)
    x1y2r:add(5, 2, 0.5)

    chain = PatternChainer()

    chain:add(s_x1y1r)
    chain:add(x5y3l)
    chain:add(x1y2r)
    chain:add(s_x1y1r)
    chain:add(x5y3l)
    chain:add(x1y2r)

    --chain:start()

    death1 = DeathWallPattern()
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.9)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)
    death1:add(1, 0, 0.5, 0.1)
    death1:add(0, 1, 0.5, 0.1)
    death1:add(-1, 0, 0.5, 0.1)
    death1:add(0, -1, 0.5, 0.1)

    deathChain = PatternChainer()
    deathChain:add(death1)
    deathChain:add(death1)
    deathChain:add(death1)
    deathChain:add(death1)
    deathChain:start()

    Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("bouncer", Constants.TILE_SIZE * 10, Constants.TILE_SIZE * 10, 1, 0.5))

    game.timer.after(15, function() 
        Signal.emit(Signals.BOXY_NEXT_PHASE)
        game.timer.after(15, function() 
            Signal.emit(Signals.BOXY_NEXT_PHASE)
            game.timer.after(15, function() 
                Signal.emit(Signals.BOXY_NEXT_PHASE) 
                game.timer.after(15, function() 
                    Signal.emit(Signals.BOXY_NEXT_PHASE) 
                end)
            end)
        end)
    end)

    --beamPattern:start(function() beamPattern:start() end)
end