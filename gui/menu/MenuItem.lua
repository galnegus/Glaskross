MenuItem = Class{}

function MenuItem:init(text, font, callback)
  self._text = text or "placeholder"
  self._graphic = love.graphics.newText(font, self._text);
  self._callback = callback
  self._color = {255, 255, 255, 200}
  self._tweenHandler = nil
end

function MenuItem:setColor(color, transition)
  if transition then
    if self._tweenHandler then
      Timer.cancel(self._tweenHandler)
    end
    self._tweenHandler = Timer.tween(0.3, self._color, color, 'out-quad')
  else
    self._color = color
  end
end

function MenuItem:press()
  self._callback()
end

function MenuItem:draw(x, y)
  love.graphics.setColor(self._color)
  love.graphics.draw(self._graphic, x, y)
end