BulletPhysicsComponent = Class{}
BulletPhysicsComponent:include(RotatingPhysicsComponent)

function BulletPhysicsComponent:init(x, y, width, height, rps)
    RotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, width, height), rps)
end

function BulletPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == EntityTypes.BOUNCER then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        shapeCollidedWith.parent.owner.events:emit(Signals.BOUNCER_HIT)
    elseif shapeCollidedWith.type == EntityTypes.DEATH_WALL then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
    elseif shapeCollidedWith.type == BodyTypes.WALL then 
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end