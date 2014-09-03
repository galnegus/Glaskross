local Constants = {}

Constants.TILE_SIZE = 32
Constants.BEAM_ROWS = 3
Constants.BEAM_COLS = 4

-- 120 collision updates per second ensures that two entities (one being a bullet) travelling at  
-- 960 pixels per second, one of them being at least 16 pixels wide will always collide without any "tunneling"
Constants.BULLET_TIMESLICE = 1/120

return Constants
