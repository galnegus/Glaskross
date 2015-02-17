RotatingPhysicsComponent = Class{}
RotatingPhysicsComponent:include(PhysicsComponent)

function RotatingPhysicsComponent:init(options)
	assert(options.rps ~= nil, "options.rps is required.")
	PhysicsComponent.init(self, options)

	self._rps = options.rps -- rotations per second
end

function RotatingPhysicsComponent:setOwner(owner)
	PhysicsComponent.setOwner(self, owner)
end

function RotatingPhysicsComponent:update(dt)
	PhysicsComponent.update(self, dt)

    self._body:setRotation((self._body:rotation() + dt * self._rps * 2 * math.pi) % (2 * math.pi))
end