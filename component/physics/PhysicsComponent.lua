PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(options)
    assert(options.shape ~= nil, "options.shape is required.")
    assert(options.bodyType ~= nil, "options.bodyType is required.")
    assert(options.collisionGroups ~= nil, "options.collisionGroups is required.")
    assert(options.collisionRules ~= nil, "options.collisionRules is required.")

    -- assert that the format on the collisionRules table is okay
    for bodyType, rules in pairs(options.collisionRules) do
        local bodyTypeExists = false
        for _, existingBodyType in pairs(BodyTypes) do
            if bodyType == existingBodyType then
                bodyTypeExists = true
            end
        end
        if not bodyTypeExists then
            error("Body type: \"" .. bodyType .. "\" does not exist, please enter a valid body type or add your new type in BodyTypes.lua.")
        end
        assert(#rules > 0, "No rules found for body type " .. bodyType .. ".")
        for _, rule in pairs(rules) do
            assert(type(rule) == "function", "Rule must be a function.")
        end
    end

    Component.init(self)

    self.type = ComponentTypes.PHYSICS
    self._body = options.shape
    self._body.parent = self
    self._body.type = options.bodyType
    self._collisionRules = options.collisionRules

    for _, group in pairs(options.collisionGroups) do
        Collider:addToGroup(group, self._body)
    end
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
    if self._collisionRules[shapeCollidedWith.type] ~= nil then
        for _, rule in pairs(self._collisionRules[shapeCollidedWith.type]) do
            rule(self, dt, shapeCollidedWith, dx, dy)
        end
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