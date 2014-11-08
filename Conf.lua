Constants = require "constants.constants"

function love.conf(t)
    t.window.width = Constants.BEAM_COLS * 10 * Constants.TILE_SIZE
    t.window.height = Constants.BEAM_ROWS * 10 * Constants.TILE_SIZE

    t.window.fsaa = 0

    t.window.vsync = true
end