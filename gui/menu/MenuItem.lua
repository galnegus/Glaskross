MenuItem = Class{}

function MenuItem:init(text, font)
  self._text = text or "placeholder"
  self._font = font or love.graphics.newFont(20)
  self._graphic = love.graphics.newText(self._font, self._text);

  self._onPress = function() end
end

function MenuItem:onPress(callback)
  self._onPress = callback
end

function MenuItem:press()
  self._onPress()
end

function MenuItem:draw(x, y)
  love.graphics.draw(self._graphic, x, y)
end