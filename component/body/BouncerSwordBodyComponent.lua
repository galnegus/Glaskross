BouncerSwordBodyComponent = Class{}
BouncerSwordBodyComponent:include(RotatingBodyComponent)

function BouncerSwordBodyComponent:init(options)
	assert(options.masterEntity ~= nil, "options.masterEntity is required.")
	RotatingBodyComponent.init(self, options)

	self._masterEntity = options.masterEntity
end

function BouncerSwordBodyComponent:update(dt)
	RotatingBodyComponent.update(self, dt)

	self._x, self._y = self._masterEntity.body:center()
	self._shape:moveTo(self._x, self._y)
end
