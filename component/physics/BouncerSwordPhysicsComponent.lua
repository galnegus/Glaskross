BouncerSwordPhysicsComponent = Class{}
BouncerSwordPhysicsComponent:include(RotatingPhysicsComponent)

function BouncerSwordPhysicsComponent:init(options)
	assert(options.masterEntity ~= nil, "options.masterEntity is required.")
	RotatingPhysicsComponent.init(self, options)

	self._masterEntity = options.masterEntity
end

function BouncerSwordPhysicsComponent:update(dt)
	RotatingPhysicsComponent.update(self, dt)

	self._x, self._y = self._masterEntity.physics:center()
	self._body:moveTo(self._x, self._y)
end
