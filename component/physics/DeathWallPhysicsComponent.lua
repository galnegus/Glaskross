DeathWallPhysicsComponent = Class{}
DeathWallPhysicsComponent:include(PhysicsComponent)

function DeathWallPhysicsComponent:init(options)
    PhysicsComponent.init(self, options)
    Collider:setPassive(self._body)
end

function DeathWallPhysicsComponent:update(dt)
    local x1, y1, x2, y2 = self:bbox()
    if x1 < 0 or y1 < 0 or x2 > love.graphics.getWidth() or y2 > love.graphics.getHeight() then
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
    end
end
