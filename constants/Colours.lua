Colours = {}

-- tile steps
Colours.DEFAULT_STEP = Colour(255, 255, 255, 0) --255
Colours.PLAYER_STEP = Colour(150, 100, 200, 0) --200
Colours.BULLET_STEP = Colour(200, 100, 100, 0) --100

-- tile beam
Colours.DEFAULT_BEAM = Colour(150, 50, 50, 0) --0

-- tile bgColor
Colours.BG_COLOUR = Colour(20, 20, 20, 20) --100
Colours.BG_COLOUR_RAND = Colour(10, 10, 10, 0) --0

-- boxy bg, NOTE: LAYER_ONE is in the BACK, LAYER_THREE is in the FRONT
Colours.BOXY_LAYER_ONE = Colour(125, 50, 50, 100, true) --100
Colours.BOXY_LAYER_TWO = Colour(100, 50, 100, 100, true) --100
Colours.BOXY_LAYER_THREE = Colour(50, 50, 150, 100, true) --100

-- render
Colours.DEFAULT_RENDER = Colour(255, 255, 255, 100) --100
Colours.PLAYER_RENDER = Colour(225, 200, 255, 255) --255
Colours.BULLET_RENDER = Colour(255, 200, 200, 255) --255
Colours.DEATH_WALL_RENDER = Colour(255, 150, 150, 255) --255
Colours.BOUNCER_RENDER = Colour(200, 150, 150, 255) --255
Colours.SHIELD_RENDER = Colour(255, 200, 200, 255) --255
Colours.BOUNCER_SWORD_RENDER = Colour(255, 150, 150, 255) --255

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