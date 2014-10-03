Constants = require "constants.constants"

function love.conf(t)
    t.window.width = 40 * Constants.TILE_SIZE
    t.window.height = 30 * Constants.TILE_SIZE

    t.window.fsaa = 0
end