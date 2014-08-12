PlayerRenderComponent = Class{}
PlayerRenderComponent:include(RenderComponent)

function PlayerRenderComponent:init()
    self.type = "render"

    self._x = 0
    self._y = 0
    self._width = 32
    self._height = 32
    self._rotation = 0
end

function PlayerRenderComponent:update(dt)
    local x, y = self.owner.physics._body:center()

    self._x = x - self._width / 2
    self._y = y - self._height / 2

    self._rotation = (self._rotation + dt * math.pi / 2) % (2 * math.pi)

end

function PlayerRenderComponent:draw()
    --love.graphics.rectangle("fill", self._x, self._y, self._width, self._height)

    love.graphics.push()
    love.graphics.translate(self._x, self._y) --Move the drawing origin to 300, 300

   -- love.graphics.push() --Start another Push stack
    love.graphics.translate((self._width / 2), (self._height / 2)) --Offset a negative amount half the width and height of the rectangle
    love.graphics.rotate(self._rotation) --Rotate 1 radian.

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(255, 200, 200, 255)
    love.graphics.rectangle("fill", -self._width / 2, -self._width / 2, self._width, self._height)
    love.graphics.setColor(r, g, b, a)

   -- love.graphics.pop()
    love.graphics.pop()


end