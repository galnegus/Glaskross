Colours = {}

-- tile steps
Colours.DEFAULT_STEP = function() return Colour(255, 255, 255, 0) end
Colours.PLAYER_STEP = function() return Colour(150, 100, 200, 0) end
Colours.BULLET_STEP = function() return Colour(200, 100, 100, 0) end

-- tile beam
Colours.DEFAULT_BEAM = function() return Colour(100, 50, 50, 0) end

-- tile bgColor
Colours.BG_COLOUR = function() return Colour(30, 30, 30, 100) end
Colours.BG_COLOUR_RAND = function() return Colour(15, 15, 15, 0, true) end

-- boxy bg
Colours.BOXY_LAYER_ONE = function() return Colour(150, 50, 50, 100, true) end
Colours.BOXY_LAYER_TWO = function() return Colour(150, 50, 150, 100, true) end
Colours.BOXY_LAYER_THREE = function() return Colour(0, 50, 150, 100, true) end

-- render
Colours.DEFAULT_RENDER = function() return Colour(255, 255, 255, 100) end
Colours.PLAYER_RENDER = function() return Colour(225, 200, 255, 255) end
Colours.BULLET_RENDER = function() return Colour(255, 200, 200, 255) end
Colours.DEATH_WALL_RENDER = function() return Colour(255, 150, 150, 255) end

-- indicates if colours are affected by some modulating signal, e.g. Signals.COLOR_INVERT
Colours.state = nil
Colours.stateColour = nil

local function setState(state, colour)
    Colours.state = state
    Colours.stateColour = colour
end

-- signals
Signal.register(Signals.COLOUR_INVERT, function()
    setState(Signals.COLOUR_INVERT)
end)
Signal.register(Signals.COLOUR_MIX, function(colour)
    setState(Signals.COLOUR_MIX, colour)
end)

return Colours