BouncerPhysicsComponent = Class{}
BouncerPhysicsComponent:include(PhysicsComponent)

function BouncerPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, Collider:addRectangle(x, y, width, height))
    Collider:addToGroup(ColliderGroups.HOSTILE, self._body)
end

function BouncerPhysicsComponent:conception()
    PhysicsComponent.conception(self)
    
    -- create sword
    self._sword = EntityCreator.create(EntityTypes.BOUNCER_SWORD, self.owner)
    Signal.emit(Signals.ADD_ENTITY, self._sword)
end

function BouncerPhysicsComponent:death()
    Signal.emit(Signals.KILL_ENTITY, self._sword.id)

    PhysicsComponent.death(self)
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