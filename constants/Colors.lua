local Color = require "Color"
local Signals = require "constants.Signals"

local Colors = {}

-- tile steps
Colors.DEFAULT_STEP = Color(1, 1, 1, 0) --255
Colors.PLAYER_STEP = Color(0.58, 0.38, 0.78, 0) --200
Colors.BULLET_STEP = Color(0.78, 0.38, 0.38, 0) --100

-- tile beam
Colors.DEFAULT_BEAM = Color(0.58, 0.19, 0.19, 0) --0

-- tile bgColor
Colors.BG_COLOR = Color(0.19, 0.19, 0.19, 0.08) --100
Colors.BG_COLOR_RAND = Color(0.08, 0.08, 0.08, 0) --0

-- boxy bg, NOTE: LAYER_ONE is in the BACK, LAYER_THREE is in the FRONT
Colors.BOXY_LAYER_ONE = Color(0.98, 0.38, 0.38, 0.58, true) --100
Colors.BOXY_LAYER_TWO = Color(0.78, 0.38, 0.78, 0.58, true) --100
Colors.BOXY_LAYER_THREE = Color(0.38, 0.38, 0.98, 0.58, true) --100

-- render
Colors.DEFAULT_RENDER = Color(1, 1, 1, 0.38) --100
Colors.PLAYER_RENDER = Color(0.88, 0.78, 1, 1) --255
Colors.BULLET_RENDER = Color(1, 0.78, 0.78, 1) --255
Colors.DEATH_WALL_RENDER = Color(1, 0.58, 0.58, 1) --255
Colors.BOUNCER_RENDER = Color(0.78, 0.58, 0.58, 1) --255
Colors.SHIELD_RENDER = Color(1, 0.78, 0.78, 1) --255
Colors.BOUNCER_SWORD_RENDER = Color(1, 0.58, 0.58, 1) --255

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