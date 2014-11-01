BouncerPhysicsComponent = Class{}
BouncerPhysicsComponent:include(PhysicsComponent)

function BouncerPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)
end

function BouncerPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0

    if shapeCollidedWith.type == BodyTypes.WALL then
        self._body:move(dx, dy) 
        self.owner.events:emit(Signals.BOUNCER_BOUNCE, dx, dy)
    elseif shapeCollidedWith.type == EntityTypes.BULLET then
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
        self.owner.events:emit(Signals.BOUNCER_HIT)
    elseif shapeCollidedWith.type == EntityTypes.PLAYER then
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end