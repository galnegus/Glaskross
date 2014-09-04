VelocityRectangleRenderComponent = Class{}
VelocityRectangleRenderComponent:include(RenderComponent)

function VelocityRectangleRenderComponent:init()
    self.type = "render"

    self._width = 32
    self._height = 32
    self._rotation = 0
    self._rotationDirection = 1

    -- not sure what unit, since rotation is exponential
    self._rotationSpeed = 10
end

function VelocityRectangleRenderComponent:update(dt)
    local vX, vY = self.owner.movement:getVelocity()

    local limit = 200
    if math.sqrt(math.abs(vX) ^ 2 + math.abs(vY) ^ 2) > limit then
        -- get angle of velocity vector
        local targetRotation = math.atan2(vY, vX)
        if targetRotation < 0 then 
            targetRotation = targetRotation + 2 * math.pi 
        end

        -- find closest 2 / pi angle to face the velocity angle perpendicularly
        while math.abs(targetRotation - self._rotation) >= math.pi / 4 and math.abs(targetRotation - self._rotation) <= 7 * math.pi / 4 do
            targetRotation = (targetRotation + math.pi / 2) % (math.pi * 2)
        end

        -- update rotation
        local distanceToTarget = self._distanceToTargetRotation(targetRotation, self._rotation)
        --print(distanceToTarget .. "\t math.abs(..) = " .. math.abs(targetRotation - self._rotation) .. "\t targetRotation: " .. targetRotation .. "\t self._rotation: " .. self._rotation)
        self._rotationDirection = distanceToTarget > 0 and 1 or -1
        self._rotation = (self._rotation + distanceToTarget * self._rotationSpeed * dt) % (2 * math.pi)
    else
        -- rotate automatically if idle
        self._rotation = (self._rotation + self._rotationDirection * dt * math.pi) % (2 * math.pi)
    end

end

-- needed to deal with situations when going crossing the 2 * pi rad mark,
-- i.e. when numeric difference between current rotation and target rotation is greater than pi, 
-- but actual rotation difference is less than pi
function VelocityRectangleRenderComponent._distanceToTargetRotation(targetRotation, currRotation)
    if math.abs(targetRotation - currRotation) > 7 * math.pi / 4 then
        if currRotation > math.pi then
            currRotation = currRotation - 2 * math.pi
        elseif targetRotation > math.pi then
            targetRotation = targetRotation - 2 * math.pi
        end
    end
    return targetRotation - currRotation
end

function VelocityRectangleRenderComponent:draw()
    love.graphics.push()
        local x, y = self.owner.physics:center()
        love.graphics.translate(x, y)
        love.graphics.rotate(self._rotation)
        love.graphics.setColor(255, 225, 225, 255)
        love.graphics.rectangle("fill", -self._width / 2, -self._height / 2, self._width, self._height)
    love.graphics.pop()
end