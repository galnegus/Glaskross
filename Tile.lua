local Class = require "lib.hump.Class"
local Colors = require "constants.Colors"

local Tile = Class{}
--Tile:include(Shape)

function Tile:init(x, y, width, height)
  self._x = x
  self._y = y
  self._width = width
  self._height = height
end

function Tile:update(dt)

end

function Tile:draw()
  love.graphics.setColor(
    Colors.BG_COLOR:r() + love.math.random(Colors.BG_COLOR_RAND:r()), 
    Colors.BG_COLOR:g() + love.math.random(Colors.BG_COLOR_RAND:g()), 
    Colors.BG_COLOR:b() + love.math.random(Colors.BG_COLOR_RAND:b()), 
    Colors.BG_COLOR:alpha())
  love.graphics.rectangle("fill", self._x, self._y, self._width, self._height)
end

return Tile
