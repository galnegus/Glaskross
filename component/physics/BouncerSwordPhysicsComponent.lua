BouncerSwordPhysicsComponent = Class{}
BouncerSwordPhysicsComponent:include(RotatingPhysicsComponent)

function BouncerSwordPhysicsComponent:init(master)
	local x, y = master.physics:center()
	RotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, 5, Constants.TILE_SIZE * 10), 1)

	self._masterEntity = master
end

function BouncerSwordPhysicsComponent:update(dt)
	RotatingPhysicsComponent.update(self, dt)

	self._x, self._y = self._masterEntity.physics:center()
	self._body:moveTo(self._x, self._y)
end

function BouncerSwordPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == EntityTypes.PLAYER then
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
    end
end