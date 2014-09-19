Colours = {}

-- tile steps
Colours.DEFAULT_STEP = function() return Colour(255, 255, 255, 0) end
Colours.PLAYER_STEP = function() return Colour(150, 100, 200, 0) end
Colours.BULLET_STEP = function() return Colour(200, 100, 100, 0) end

-- tile beam
Colours.DEFAULT_BEAM = function() return Colour(100, 50, 50, 0) end

-- tile bgColor
Colours.BG_COLOUR = function() return Colour(30, 30, 30, 100) end
Colours.BG_COLOUR_RAND = function() return Colour(30, 30, 30, 0, true) end

-- boxy bg
Colours.BOXY_LAYER_ONE = function() return Colour(150, 50, 50, 150) end
Colours.BOXY_LAYER_TWO = function() return Colour(150, 50, 150, 150) end
Colours.BOXY_LAYER_THREE = function() return Colour(0, 50, 150, 150) end

-- render
Colours.DEFAULT_RENDER = function() return Colour(255, 255, 255, 100) end
Colours.PLAYER_RENDER = function() return Colour(200, 150, 255, 255) end
Colours.BULLET_RENDER = function() return Colour(255, 200, 200, 255) end
Colours.DEATH_WALL_RENDER = function() return Colour(255, 150, 150, 255) end

return Colours