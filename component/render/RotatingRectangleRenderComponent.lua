RotatingRectangleRenderComponent = Class{}
RotatingRectangleRenderComponent:include(RenderComponent)

function RotatingRectangleRenderComponent:init()
    self.type = "render"

    self._x = 0
    self._y = 0
    self._width = 32
    self._height = 32
    self._rotation = 0
end

function RotatingRectangleRenderComponent:update(dt)
    local x, y = self.owner.physics._body:center()

    self._x = x - self._width / 2
    self._y = y - self._height / 2

    self._rotation = (self._rotation + dt * math.pi / 2) % (2 * math.pi)

end

function RotatingRectangleRenderComponent:draw()
    love.graphics.push()
        -- set origin of coordinate system to center of rectangle
        love.graphics.translate(self._x, self._y)
        love.graphics.translate(self._width / 2, self._height / 2)
        love.graphics.rotate(self._rotation)

        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(255, 200, 200, 255)
        love.graphics.rectangle("fill", -self._width / 2, -self._width / 2, self._width, self._height)
        love.graphics.setColor(r, g, b, a)
    love.graphics.pop()
end