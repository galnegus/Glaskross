VelocityRectangleRenderComponent = Class{}
VelocityRectangleRenderComponent:include(RenderComponent)

function VelocityRectangleRenderComponent:init()
    self.type = "render"

    self._x = 0
    self._y = 0
    self._width = 32
    self._height = 32
    self._rotation = 0
    self._rotationDirection = 1
end

function VelocityRectangleRenderComponent:update(dt)
    local x, y = self.owner.physics._body:center()

    self._x = x - self._width / 2
    self._y = y - self._height / 2

    local vX, vY = self.owner.movement._velocity:unpack()

    local limit = 200
    if math.sqrt(math.abs(vX) ^ 2 + math.abs(vY) ^ 2) > limit then
        -- get angle of velocity vector with atan2
        local targetRotation = math.atan2(math.abs(vY), math.abs(vX)) 

        -- find closest 2 / pi angle
        while math.abs(targetRotation - self._rotation) >= math.pi / 4 and math.abs(targetRotation - self._rotation) <= 7 * math.pi / 4 do
            targetRotation = (targetRotation + math.pi / 2) % (math.pi * 2)
        end

        -- update rotation
        local distanceToTarget = self._distanceToTargetRotation(targetRotation, self._rotation)
        self._rotationDirection = distanceToTarget > 0 and 1 or -1
        self._rotation = self._rotation + distanceToTarget * 10 * dt
    else
        -- rotate automatically if idle
        self._rotation = (self._rotation + self._rotationDirection * 2 * dt * math.pi / 2) % (2 * math.pi)
    end

end

-- needed to deal with situations when going crossing the 2 * pi rad mark,
-- e.g. going from 0 rad to 7 * pi / 4 rad clockwise.
function VelocityRectangleRenderComponent._distanceToTargetRotation(targetRotation, currRotation)
    if math.abs(targetRotation - currRotation) <= 7 * math.pi / 4 then
        return targetRotation - currRotation
    else
        return (4 * math.pi - targetRotation - currRotation) % (2 * math.pi)
    end
end

function VelocityRectangleRenderComponent:draw()
    love.graphics.push()
    love.graphics.translate(self._x, self._y)
    love.graphics.translate(self._width / 2, self._height / 2)
    love.graphics.rotate(self._rotation)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(255, 225, 225, 255)
    love.graphics.rectangle("fill", -self._width / 2, -self._height / 2, self._width, self._height)
    love.graphics.setColor(r, g, b, a)

    love.graphics.pop()
end