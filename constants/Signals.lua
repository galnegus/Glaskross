local Signals = {}

-- check the relevant files where the signals are registered to learn what arguments they take

-- GLOBAL SIGNALS
-- Entities.lua
Signals.ADD_ENTITY = "add entity"
Signals.KILL_ENTITY = "kill entity"
Signals.REMOVE_ENTITY = "remove entity"
-- Tile.lua
Signals.BACKGROUND_COLOR = "background color"
-- World.lua
Signals.AREA_BEAM = "area beam"
-- Color.lua
Signals.COLOR_INVERT = "color invert"
Signals.COLOR_MIX = "color mix"

-- ENTITY SIGNALS
-- MovementComponent.lua
Signals.SET_MOVEMENT_DIRECTION = "set movement direction"
-- BodyComponent.lua
Signals.MOVE = "move"
Signals.MOVE_TO = "moveTo"
-- BoxyBackgroundComponent.lua, + others potentially
Signals.BOXY_NEXT_PHASE = "boxy next phase"
-- BouncerMovementComponent.lua
Signals.BOUNCE = "bounce"
-- BouncerHPComponent.lua
Signals.BOUNCER_HIT = "bouncer hit"
-- ShieldRenderComponent.lua, ShieldPhysicsComponent.lua
Signals.SHIELD_ACTIVE = "shield active"
Signals.SHIELD_INACTIVE = "shield inactive"

return Signals