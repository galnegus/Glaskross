local Constants = {}

Constants.TILE_SIZE = 32 -- 32
Constants.BEAM_ROWS = 3
Constants.BEAM_COLS = 5

-- terminal velocity needs to be less than (tile_size * frame_rate / 2 => tile_size / 30) pixels per second to avoid
-- collision bugs (walls being tile_sizel pixels) at 60 fps (lower fps breaks game)
Constants.TERMINAL_VELOCITY = Constants.TILE_SIZE * 20

-- 120 collision updates per second ensures that two entities (one being a bullet) travelling at  
-- terminal velocity, one of them being at least (tile_size / 2) wide will always collide without any "tunneling"
Constants.BULLET_TIMESLICE = 1/120

-- how often the player can shoot bullets
Constants.BULLET_COOLDOWN = 0.2

-- how many seconds are spent on transitions between phases, i.e. colour transitions
Constants.BOXY_PHASE_TRANS_TIME = 1

-- birth durations
Constants.BULLET_BIRTH_DURATION = 0
Constants.DEATH_WALL_BIRTH_DURATION = 0.5
Constants.BOUNCER_BIRTH_DURATION = 1

-- death durations
Constants.DEFAULT_DEATH_DURATION = 0.25

-- bouncer hp (hits to death)
Constants.BOUNCER_HP = 3

return Constants
