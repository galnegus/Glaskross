BouncerSwordPhysicsComponent = Class{}
BouncerSwordPhysicsComponent:include(RotatingPhysicsComponent)

function BouncerSwordPhysicsComponent:init(master, bodyType, collisionRules)
	local x, y = master.physics:center()
	RotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, 5, Constants.TILE_SIZE * 10), 1, bodyType, collisionRules)
	Collider:addToGroup(CollisionGroups.HOSTILE, self._body)
	Collider:addToGroup(CollisionGroups.IGNORE_WALLS, self._body)

	self._masterEntity = master
end

function BouncerSwordPhysicsComponent:update(dt)
	RotatingPhysicsComponent.update(self, dt)

	self._x, self._y = self._masterEntity.physics:center()
	self._body:moveTo(self._x, self._y)
end
