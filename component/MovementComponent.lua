Vector = require "hump.vector"
Class = require "hump.class"
require 'component.Component'

MovementComponent = Class{}
MovementComponent:include(Component)

function MovementComponent:init(physicsComponent)
    self.type = "movement"

    self.body = physicsComponent.body

    self.direction = Vector(0, 0)
    self.velocity = Vector(0, 0)

    self.friction = 2000
    self.terminalVelocity = 1500
    self.acceleration = MovementComponent.calcAcceleration(self.terminalVelocity, self.friction)
end

function MovementComponent:moveUp()
    self.direction.y = -1
end

function MovementComponent:moveRight()
    self.direction.x = 1
end

function MovementComponent:moveDown()
    self.direction.y = 1
end

function MovementComponent:moveLeft()
    self.direction.x = -1
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
    self.direction.x = 0
    self.direction.y = 0
end

function MovementComponent:update(dt)
    local oldVelocity = self.velocity:clone()

    local diagonal = (self.direction.x ^ 2 + self.direction.y ^ 2) ^ 0.5
    if diagonal ~= 0 then
        self.direction.x = self.direction.x / diagonal
        self.direction.y = self.direction.y / diagonal
    end

    self.velocity.x = MovementComponent.newVelocity(self.velocity.x, self.direction.x * self.acceleration, self.friction, dt)
    self.velocity.y = MovementComponent.newVelocity(self.velocity.y, self.direction.y * self.acceleration, self.friction, dt)

    local movement = Vector((oldVelocity.x + self.velocity.x) * dt / 2, (oldVelocity.y + self.velocity.y) * dt / 2)
    self.body:move(movement.x, movement.y)

    self:resetAcceleration()
end