RotatingBodyComponent = Class{}
RotatingBodyComponent:include(BodyComponent)

function RotatingBodyComponent:init(options)
	assert(options.rps ~= nil, "options.rps is required.")
	BodyComponent.init(self, options)

	self._rps = options.rps -- rotations per second
end

function RotatingBodyComponent:setOwner(owner)
	BodyComponent.setOwner(self, owner)
end

function RotatingBodyComponent:update(dt)
	BodyComponent.update(self, dt)

    self._shape:setRotation((self._shape:rotation() + dt * self._rps * 2 * math.pi) % (2 * math.pi))
end