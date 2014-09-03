MovementComponent = Class{}
MovementComponent:include(Component)

local function terminalVelocity(acceleration, friction)
    return -acceleration / ((1 / friction) - 1)
end

local function calcAcceleration(terminalVelocity, friction)
    return -terminalVelocity / friction + terminalVelocity
end

function MovementComponent:init()
    self.type = "movement"

    self._direction = Vector(0, 0)
    self._velocity = Vector(0, 0)

    -- terminal velocity needs to be less than 960 pixels per second to avoid
    -- collision bugs (walls being 32 pixels) at 60 fps (lower fps breaks game)
    self._terminalVelocity = 950
    self._friction = 100000
    self._acceleration = calcAcceleration(self._terminalVelocity, self._friction)
end

local function setDirection(self, direction)
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

function MovementComponent:setOwner(owner)
    Component.setOwner(self, owner)

    self.owner.events:register("set movement direction", function(direction)
        setDirection(self, direction)
    end)    
end

function MovementComponent:getVelocity()
    return self._velocity:unpack()
end

function MovementComponent:stopMoving()
    self._velocity.x = 0
    self._velocity.y = 0
end

local function resetAcceleration(self)
    self._direction.x = 0
    self._direction.y = 0
end

local function newVelocity(oldVelocity, acceleration, friction, dt)
    local newVelocity = (oldVelocity / friction ^ dt)
    if friction == 1 then
        return newVelocity + acceleration * dt
    else
        return newVelocity + acceleration * ((1 / friction^dt - 1) / ((1 / friction) - 1))
    end
end

function MovementComponent:update(dt)
    local oldVelocity = self._velocity:clone()

    local diagonal = math.sqrt((self._direction.x ^ 2 + self._direction.y ^ 2))
    if diagonal ~= 0 then
        self._direction.x = self._direction.x / diagonal
        self._direction.y = self._direction.y / diagonal
    end

    self._velocity.x = newVelocity(self._velocity.x, self._direction.x * self._acceleration, self._friction, dt)
    self._velocity.y = newVelocity(self._velocity.y, self._direction.y * self._acceleration, self._friction, dt)

    -- heun's method
    local movement = Vector((oldVelocity.x + self._velocity.x) * dt / 2, (oldVelocity.y + self._velocity.y) * dt / 2)
    self.owner.events:emit("move", movement.x, movement.y)

    resetAcceleration(self)
end