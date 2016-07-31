RotatingBodyComponent = Class{}
RotatingBodyComponent:include(BodyComponent)

function RotatingBodyComponent:init(options)
  assert(options.rps ~= nil, "options.rps is required.")
  self._rps = options.rps -- rotations per second
  
  BodyComponent.init(self, options)
end

function RotatingBodyComponent:setOwner(owner)
  BodyComponent.setOwner(self, owner)
end

function RotatingBodyComponent:update(dt)
  self._shape:setRotation((self._shape:rotation() + dt * self._rps * 2 * math.pi) % (2 * math.pi))

  BodyComponent.update(self, dt)
end