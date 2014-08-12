MovementComponent = Class{}
MovementComponent:include(Component)

function MovementComponent:init()
    self.type = "movement"

    self._direction = Vector(0, 0)
    self._velocity = Vector(0, 0)

    self._friction = 1000000
    self._terminalVelocity = 1000
    self._acceleration = MovementComponent.calcAcceleration(self._terminalVelocity, self._friction)
end

function MovementComponent:setOwner(owner)
    Component.setOwner(self, owner)

    self.owner.events:register("set movement direction", function(direction)
        self:setDirection(direction)
    end)    
end

function MovementComponent:setDirection(direction)
    if direction == "up" then
        self._direction.y = -1
    elseif direction == "right" then
        self._direction.x = 1
    elseif direction == "down" then
        self._direction.y = 1
    elseif direction == "left" then
        self._direction.x = -1
    end
end

function MovementComponent:stopMoving()
    self._velocity.x = 0
    self._velocity.y = 0
end

function MovementComponent.newVelocity(oldVelocity, acceleration, friction, dt)
    local newVelocity = (oldVelocity / friction^dt)
    if friction == 1 then
        return newVelocity + acceleration * dt
    else
        return newVelocity + acceleration * (( 1 / friction^dt - 1) / ((1 / friction) - 1))
    end
end

function MovementComponent.terminalVelocity(acceleration, friction)
    return -acceleration / ((1 / friction) - 1)
end

function MovementComponent.calcAcceleration(terminalVelocity, friction)
    return -terminalVelocity / friction + terminalVelocity
end

function MovementComponent:resetAcceleration()
    self._direction.x = 0
    self._direction.y = 0
end

function MovementComponent:fullStop()
    if self._direction.x == 0 then
        self._velocity.x = 0
    elseif self._direction.y == 0 then
        self._velocity.y = 0
    end
end

function MovementComponent:update(dt)
    local oldVelocity = self._velocity:clone()

    local diagonal = (self._direction.x ^ 2 + self._direction.y ^ 2) ^ 0.5
    if diagonal ~= 0 then
        self._direction.x = self._direction.x / diagonal
        self._direction.y = self._direction.y / diagonal
    end

    self._velocity.x = MovementComponent.newVelocity(self._velocity.x, self._direction.x * self._acceleration, self._friction, dt)
    self._velocity.y = MovementComponent.newVelocity(self._velocity.y, self._direction.y * self._acceleration, self._friction, dt)

    --self:fullStop()

    local movement = Vector((oldVelocity.x + self._velocity.x) * dt / 2, (oldVelocity.y + self._velocity.y) * dt / 2)
    self.owner.events:emit("move", movement.x, movement.y)

    self:resetAcceleration()
end