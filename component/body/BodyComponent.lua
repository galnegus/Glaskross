BodyComponent = Class{}
BodyComponent:include(Component)

function BodyComponent:init(options)
    assert(options.shape ~= nil, "options.shape is required.")
    assert(options.bodyType ~= nil, "options.bodyType is required.")
    --assert(options.collisionGroups ~= nil, "options.collisionGroups is required.")
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

    self.type = ComponentTypes.BODY
    self._shape = options.shape
    self._shape.parent = self
    self._shape.type = options.bodyType
    self._collisionRules = options.collisionRules

    --[[for _, group in pairs(options.collisionGroups) do
        Colider:addToGrup(group, self._shape)
    end]]
end

function BodyComponent:center()
    return self._shape:center()
end

function BodyComponent:bbox()
    return self._shape:bbox()
end

function BodyComponent:rotation()
    return self._shape:rotation()
end

--[[function BodyComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    if self._collisionRules[shapeCollidedWith.type] ~= nil then
        for _, rule in pairs(self._collisionRules[shapeCollidedWith.type]) do
            rule(self, dt, shapeCollidedWith, dx, dy)
        end
    end
end]]

function BodyComponent:conception()
    --Collider:setGhost(self._shape)
    Component.conception(self)
end

function BodyComponent:birth()
    Component.birth(self)
    --Collider:setSolid(self._shape)

    self.owner.events.register(Signals.MOVE_SHAPE, function(x, y)
        self._shape:move(x, y)
    end)  
end

function BodyComponent:death()
    HC.remove(self._shape)
    Component.death(self)
end

function BodyComponent:update(dt)
    for shapeCollidedWith, delta in pairs(HC.collisions(self._shape)) do
        if self._collisionRules[shapeCollidedWith.type] ~= nil then
            for _, rule in pairs(self._collisionRules[shapeCollidedWith.type]) do
                rule(self, dt, shapeCollidedWith, delta.x, delta.y)
            end
        end
    end
    -- override
end

function BodyComponent:draw(mode)
    mode = mode or "fill"
    self._shape:draw(mode)
end