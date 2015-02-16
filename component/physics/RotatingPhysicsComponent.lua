RotatingPhysicsComponent = Class{}
RotatingPhysicsComponent:include(PhysicsComponent)

function RotatingPhysicsComponent:init(shape, rps, bodyType, collisionRules)
	PhysicsComponent.init(self, shape, bodyType, collisionRules)

	self._rps = rps -- rotations per second
end

function RotatingPhysicsComponent:setOwner(owner)
	PhysicsComponent.setOwner(self, owner)
end

function RotatingPhysicsComponent:update(dt)
	PhysicsComponent.update(self, dt)

    self._body:setRotation((self._body:rotation() + dt * self._rps * 2 * math.pi) % (2 * math.pi))
end