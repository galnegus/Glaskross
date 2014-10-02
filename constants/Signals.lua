local Signals = {}

-- global signals

-- Entities.lua
Signals.ADD_ENTITY = "add entity"
Signals.KILL_ENTITY = "kill entity"
Signals.REMOVE_ENTITY = "remove entity"

-- Tile.lua
Signals.BACKGROUND_COLOR = "background color"

-- World.lua
Signals.AREA_BEAM = "area beam"

-- Colour.lua
Signals.COLOUR_INVERT = "color invert"
Signals.COLOUR_MIX = "color mix"

-- entity signals

-- MovementComponent.lua
Signals.SET_MOVEMENT_DIRECTION = "set movement direction"

-- PhysicsComponent.lua
Signals.MOVE_SHAPE = "move shape"

-- BoxyBackgroundComponent.lua, + others potentially
Signals.BOXY_NEXT_PHASE = "boxy next phase"

-- BouncerMovementComponent.lua
Signals.BOUNCER_BOUNCE = "bouncer bounce"

return Signals