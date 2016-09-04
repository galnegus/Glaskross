Colors = {}

-- tile steps
Colors.DEFAULT_STEP = Color(255, 255, 255, 0) --255
Colors.PLAYER_STEP = Color(150, 100, 200, 0) --200
Colors.BULLET_STEP = Color(200, 100, 100, 0) --100

-- tile beam
Colors.DEFAULT_BEAM = Color(150, 50, 50, 0) --0

-- tile bgColor
Colors.BG_COLOR = Color(50, 50, 50, 20) --100
Colors.BG_COLOR_RAND = Color(20, 20, 20, 0) --0

-- boxy bg, NOTE: LAYER_ONE is in the BACK, LAYER_THREE is in the FRONT
Colors.BOXY_LAYER_ONE = Color(250, 100, 100, 150, true) --100
Colors.BOXY_LAYER_TWO = Color(200, 100, 200, 150, true) --100
Colors.BOXY_LAYER_THREE = Color(100, 100, 250, 150, true) --100

-- render
Colors.DEFAULT_RENDER = Color(255, 255, 255, 100) --100
Colors.PLAYER_RENDER = Color(225, 200, 255, 255) --255
Colors.BULLET_RENDER = Color(255, 200, 200, 255) --255
Colors.DEATH_WALL_RENDER = Color(255, 150, 150, 255) --255
Colors.BOUNCER_RENDER = Color(200, 150, 150, 255) --255
Colors.SHIELD_RENDER = Color(255, 200, 200, 255) --255
Colors.BOUNCER_SWORD_RENDER = Color(255, 150, 150, 255) --255

-- indicates if colors are affected by some modulating signal, e.g. Signals.COLOR_INVERT
Colors.state = nil
Colors.stateColor = nil

local function setState(state, color)
  Colors.state = state
  Colors.stateColor = color
end

-- signals
Signal.register(Signals.COLOR_INVERT, function()
  setState(Signals.COLOR_INVERT)
end)
Signal.register(Signals.COLOR_MIX, function(color)
  setState(Signals.COLOR_MIX, color)
end)

return Colors