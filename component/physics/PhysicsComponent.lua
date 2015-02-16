PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(shape, bodyType, collisionRules)
    assert(bodyType ~= nil, "body type is required")
    assert(collisionRules ~= nil, "collision rules are required")

    Component.init(self)

    self.type = ComponentTypes.PHYSICS

    self._body = shape
    self._body.parent = self
    self._body.type = bodyType

    self._collisionRules = collisionRules
end

function PhysicsComponent:center()
    return self._body:center()
end

function PhysicsComponent:bbox()
    return self._body:bbox()
end

function PhysicsComponent:rotation()
    return self._body:rotation()
end

function PhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    for _, rule in pairs(self._collisionRules) do
        rule(self, dt, shapeCollidedWith, dx, dy)
    end
end

function PhysicsComponent:conception()
    Collider:setGhost(self._body)
    Component.conception(self)
end

function PhysicsComponent:birth()
    Component.birth(self)
    Collider:setSolid(self._body)

    self.owner.events:register(Signals.MOVE_SHAPE, function(x, y)
        self._body:move(x, y)
    end)  
end

function PhysicsComponent:death()
    Collider:remove(self._body)
    Component.death(self)
end

function PhysicsComponent:update(dt)
    -- override
end

function PhysicsComponent:draw(mode)
    mode = mode or "fill"
    --print("debug drawing in physicsComponent activated")
    self._body:draw(mode)
end