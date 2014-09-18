Entity = {}
Entity.__index = Entity

function Entity.new(id, type, bullet)
    local e = {}

    e.id = id
    e.type = type
    e.events = Signal.new()

    -- more granular updates (i.e. forced 120 updates per second or something)
    -- check Entities.update() for actual shitcode
    e._bullet = bullet or false

    -- used for update() and draw()
    e._components = {}

    return setmetatable(e, Entity)
end

function Entity:bullet()
    return self._bullet
end

function Entity:addComponent(component)
    self._components[component.type] = component
    self[component.type] = component
    component:setOwner(self)
end

function Entity:update(dt)
    for _, comp in pairs(self._components) do
        if comp:isAlive() then
            comp:update(dt)
        end
    end
end

function Entity:bgDraw()
    for compType, comp in pairs(self._components) do
        if compType == "background" then
            comp:bgDraw()
        end
    end
end

function Entity:draw()
    for compType, comp in pairs(self._components) do
        if compType == "render" then
            comp:draw()
        end
    end
end

function Entity:kill()
    -- trigger component murdering
    for _, comp in pairs(self._components) do
        comp:kill()
    end
end

function Entity:suicideAttempt()
    local allComponentsDead = true
    for _, comp in pairs(self._components) do
        if comp:isAlive() then
            allComponentsDead = false
            break
        end
    end

    if allComponentsDead then
        Signal.emit("remove entity", self.id)
    end
end
