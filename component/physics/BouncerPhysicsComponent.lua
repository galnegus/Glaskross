BouncerPhysicsComponent = Class{}
BouncerPhysicsComponent:include(PhysicsComponent)

function BouncerPhysicsComponent:init(x, y, width, height, bodyType, collisionRules)
    PhysicsComponent.init(self, Collider:addRectangle(x, y, width, height), bodyType, collisionRules)
    Collider:addToGroup(CollisionGroups.HOSTILE, self._body)
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
