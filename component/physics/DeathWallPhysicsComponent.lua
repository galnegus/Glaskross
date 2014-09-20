DeathWallPhysicsComponent = Class{}
DeathWallPhysicsComponent:include(PhysicsComponent)

function DeathWallPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)
    Collider:setPassive(self._body)
end

function DeathWallPhysicsComponent:update(dt)
    local x1, y1, x2, y2 = self:bbox()
    if x1 < 0 or y1 < 0 or x2 > love.graphics.getWidth() or y2 > love.graphics.getHeight() then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end

function DeathWallPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "player" then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
    end
end