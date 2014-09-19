DeathWallPhysicsComponent = Class{}
DeathWallPhysicsComponent:include(PhysicsComponent)

function DeathWallPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)

    Collider:addToGroup("environment", self._body)
end

function DeathWallPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    elseif shapeCollidedWith.type == "player" then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
    end
end