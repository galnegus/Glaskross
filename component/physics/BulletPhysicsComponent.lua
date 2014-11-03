BulletPhysicsComponent = Class{}
BulletPhysicsComponent:include(PhysicsComponent)

function BulletPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, Collider:addRectangle(x, y, width, height))

    self._floorColour = Colours.BULLET_STEP()
end

function BulletPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == BodyTypes.TILE then
        local tile = shapeCollidedWith.parent
        if shapeCollidedWith ~= self._lastCollidedWith then
            self._lastCollidedWith = shapeCollidedWith
            tile:step(0.03, 5, self._floorColour)
        end
    elseif shapeCollidedWith.type == EntityTypes.BOUNCER then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        shapeCollidedWith.parent.owner.events:emit(Signals.BOUNCER_HIT)
    elseif shapeCollidedWith.type == EntityTypes.DEATH_WALL then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
    elseif shapeCollidedWith.type == BodyTypes.WALL then 
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end