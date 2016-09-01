MenuList = Class{}

function MenuList:init()
  self._menuItems = {}
  self._selected = 1
  self._length = 0
end

function MenuList:add(text, callback)
  self._length = self._length + 1
end

function MenuList:press()
  self._onPress()
end

-- if this._length == 3, n == 0 -> 3, n == 4 -> 1
function MenuList:_cyclicalPos(n)
  return ((n - 1) % this._length) + 1
end

function MenuList:up()
  self._selected = self:_cyclicalPos(self._selected - 1)
end

function MenuList:right()

end

function MenuList:down()
  self._selected = self:_cyclicalPos(self._selected + 1)
end

function MenuList:left()

end

function MenuList:draw(x, y)
  love.graphics.draw(self._graphic, x, y)
end