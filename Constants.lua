local Constants = {}

Constants.TILE_SIZE = 32
Constants.BEAM_ROWS = 3
Constants.BEAM_COLS = 4

-- terminal velocity needs to be less than 960 pixels per second to avoid
-- collision bugs (walls being 32 pixels) at 60 fps (lower fps breaks game)
Constants.DEFAULT_TERMINAL_VELOCITY = 950

-- 120 collision updates per second ensures that two entities (one being a bullet) travelling at  
-- 960 pixels per second, one of them being at least 16 pixels wide will always collide without any "tunneling"
Constants.BULLET_TIMESLICE = 1/120

-- how many seconds are spent on transitions between phases, i.e. colour transitions
Constants.BOXY_PHASE_TRANS_TIME = 1

return Constants
