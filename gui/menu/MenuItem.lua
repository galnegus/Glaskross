MenuItem = Class{}

function MenuItem:init(text, callback)
  local font = love.graphics.newFont("assets/fonts/Share/Share-Regular.ttf", 60)
  
  self._text = text or "placeholder"
  self._graphic = love.graphics.newText(font, self._text);
  self._callback = callback
end

function MenuItem:press()
  self._callback()
end

function MenuItem:draw(x, y)
  love.graphics.draw(self._graphic, x, y)
end