BouncerPhysicsComponent = Class{}
BouncerPhysicsComponent:include(PhysicsComponent)

function BouncerPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, Collider:addRectangle(x, y, width, height))
    Collider:addToGroup(ColliderGroups.HOSTILE, self._body)
end

function BouncerPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0

    if shapeCollidedWith.type == BodyTypes.WALL then
        self._body:move(dx, dy) 
        self.owner.events:emit(Signals.BOUNCER_BOUNCE, dx, dy)
    elseif shapeCollidedWith.type == EntityTypes.PLAYER then
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end