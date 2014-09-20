RotatingRectangleRenderComponent = Class{}
RotatingRectangleRenderComponent:include(RenderComponent)

function RotatingRectangleRenderComponent:init(colour, fadeIn)
    RenderComponent.init(self, colour, fadeIn, false)

    self._x = 0
    self._y = 0
    self._width = 16
    self._height = 16
    self._rotation = 0
end

function RotatingRectangleRenderComponent:update(dt)
    RenderComponent.update(self, dt)

    local x, y = self.owner.physics:center()

    self._x = x
    self._y = y

    if not self._dying then
        local vX, vY = self.owner.movement:getVelocity()
        local dir = vX > 0 and 1 or -1
        self._rotation = (self._rotation + dir * dt * math.pi) % (2 * math.pi)
    end

end

function RotatingRectangleRenderComponent:draw()
    love.graphics.push()
        -- set origin of coordinate system to center of rectangle
        love.graphics.translate(self._x, self._y)
        love.graphics.rotate(self._rotation)

        love.graphics.setColor(self._colour.r, self._colour.g, self._colour.b, self._colour.a)
        love.graphics.rectangle("fill", -self._width / 2, -self._height / 2, self._width, self._height)
    love.graphics.pop()
end