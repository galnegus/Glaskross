BouncerSwordBodyComponent = Class{}
BouncerSwordBodyComponent:include(RotatingBodyComponent)

function BouncerSwordBodyComponent:init(options)
	assert(options.masterEntity ~= nil, "options.masterEntity is required.")
	self._masterEntity = options.masterEntity
	
	RotatingBodyComponent.init(self, options)
end

function BouncerSwordBodyComponent:update(dt)
	self._x, self._y = self._masterEntity.body:center()
	self._shape:moveTo(self._x, self._y)

	RotatingBodyComponent.update(self, dt)
end
