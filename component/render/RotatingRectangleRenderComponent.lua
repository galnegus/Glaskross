RotatingRectangleRenderComponent = Class{}
RotatingRectangleRenderComponent:include(RenderComponent)

function RotatingRectangleRenderComponent:init()
    self.type = "render"

    self._x = 0
    self._y = 0
    self._width = 16
    self._height = 16
    self._rotation = 0
end

function RotatingRectangleRenderComponent:update(dt)
    local x, y = self.owner.physics._body:center()

    self._x = x
    self._y = y

    self._rotation = (self._rotation + dt * math.pi) % (2 * math.pi)

end

function RotatingRectangleRenderComponent:draw()
    love.graphics.push()
        -- set origin of coordinate system to center of rectangle
        love.graphics.translate(self._x, self._y)
        love.graphics.rotate(self._rotation)
        
        love.graphics.setColor(255, 120, 120, 255)
        love.graphics.rectangle("fill", -self._width / 2, -self._height / 2, self._width, self._height)
    love.graphics.pop()
end