VelocityRotatingBodyComponent = Class{}
VelocityRotatingBodyComponent:include(BodyComponent)

function VelocityRotatingBodyComponent:init(options, rotationSpeed)
	self._rotationDirection = 1

    -- not sure what unit, since rotation is exponential
    self._rotationSpeed = rotationSpeed or 10

    BodyComponent.init(self, options)
end

function VelocityRotatingBodyComponent:conception()
	assert(self.owner.movement ~= nil, "owner entity " .. tostring(self.owner) .. " must have movement component!")

    BodyComponent.conception(self)
end

function VelocityRotatingBodyComponent:update(dt)
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
        local distanceToTarget = Helpers.distanceToTargetRotation(self._shape:rotation(), targetRotation)
        --print(distanceToTarget .. "\t math.abs(..) = " .. math.abs(targetRotation - self._shape:rotation()) .. "\t targetRotation: " .. targetRotation .. "\t self._shape:rotation(): " .. self._shape:rotation())
        self._rotationDirection = distanceToTarget > 0 and 1 or -1
        self._shape:setRotation((self._shape:rotation() + distanceToTarget * self._rotationSpeed * dt) % (2 * math.pi))
    else
        -- rotate automatically if idle
        if not self._dying then
            self._shape:setRotation((self._shape:rotation() + self._rotationDirection * self._rotationSpeed / math.pi * dt) % (2 * math.pi))
        end
    end

    BodyComponent.update(self, dt)
end
