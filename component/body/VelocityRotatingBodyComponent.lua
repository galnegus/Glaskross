VelocityRotatingBodyComponent = Class{}
VelocityRotatingBodyComponent:include(BodyComponent)

function VelocityRotatingBodyComponent:init(options)
	BodyComponent.init(self, options)

	self._rotationDirection = 1

    -- not sure what unit, since rotation is exponential
    self._rotationSpeed = 10
end

function VelocityRotatingBodyComponent:conception()
	BodyComponent.conception(self)

	assert(self.owner.movement ~= nil, "owner entity " .. tostring(self.owner) .. " must have movement component!")
end

function VelocityRotatingBodyComponent:update(dt)
    BodyComponent.update(self, dt)

    local vX, vY = 0, 0
    if self.owner.movement ~= nil then
        vX, vY = self.owner.movement:getVelocity()
    end

    local limit = 200
    if math.sqrt(math.abs(vX) ^ 2 + math.abs(vY) ^ 2) > limit then
        -- get angle of velocity vector
        local targetRotation = math.atan2(vY, vX)
        if targetRotation < 0 then 
            targetRotation = targetRotation + 2 * math.pi 
        end

        -- find closest 2 / pi angle to face the velocity angle perpendicularly
        while math.abs(targetRotation - self._shape:rotation()) >= math.pi / 4 and math.abs(targetRotation - self._shape:rotation()) <= 7 * math.pi / 4 do
            targetRotation = (targetRotation + math.pi / 2) % (math.pi * 2)
        end

        -- update rotation
        local distanceToTarget = self._distanceToTargetRotation(targetRotation, self._shape:rotation())
        --print(distanceToTarget .. "\t math.abs(..) = " .. math.abs(targetRotation - self._shape:rotation()) .. "\t targetRotation: " .. targetRotation .. "\t self._shape:rotation(): " .. self._shape:rotation())
        self._rotationDirection = distanceToTarget > 0 and 1 or -1
        self._shape:setRotation((self._shape:rotation() + distanceToTarget * self._rotationSpeed * dt) % (2 * math.pi))
    else
        -- rotate automatically if idle
        if not self._dying then
            self._shape:setRotation((self._shape:rotation() + self._rotationDirection * dt * math.pi) % (2 * math.pi))
        end
    end

end

-- needed to deal with situations when going crossing the 2 * pi rad mark,
-- i.e. when numeric difference between current rotation and target rotation is greater than pi, 
-- but actual rotation difference is less than pi
function VelocityRotatingBodyComponent._distanceToTargetRotation(targetRotation, currRotation)
    if math.abs(targetRotation - currRotation) > 7 * math.pi / 4 then
        if currRotation > math.pi then
            currRotation = currRotation - 2 * math.pi
        elseif targetRotation > math.pi then
            targetRotation = targetRotation - 2 * math.pi
        end
    end
    return targetRotation - currRotation
end