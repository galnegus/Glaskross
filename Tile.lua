Tile = Class{}
Tile:include(Shape)

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
        Colours.BG_COLOUR:r() + love.math.random(Colours.BG_COLOUR_RAND:r()), 
        Colours.BG_COLOUR:g() + love.math.random(Colours.BG_COLOUR_RAND:g()), 
        Colours.BG_COLOUR:b() + love.math.random(Colours.BG_COLOUR_RAND:b()), 
        Colours.BG_COLOUR:alpha())
    love.graphics.rectangle("fill", self._x, self._y, self._width, self._height)
end