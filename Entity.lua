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

-- string representation of this entity, calling print(thisEntity) will print the following:
function Entity:__tostring()
    return "{id: " .. self.id .. ", type: " .. self.type .. "}"
end

function Entity:addComponent(component)
    assert(component ~= nil, "component is nil!")
    assert(component.type ~= nil, "component has no type.")

    self._components[component.type] = component
    self[component.type] = component
    component:setOwner(self)
end

function Entity:update(dt)
    for _, comp in pairs(self._components) do
        if comp:isAlive() or not comp:isReadyForBirth() then
            comp:update(dt)
        end
    end
end

function Entity:bgDraw()
    for compType, comp in pairs(self._components) do
        if compType == ComponentTypes.BACKGROUND then
            comp:bgDraw()
        end
    end
end

function Entity:draw()
    for compType, comp in pairs(self._components) do
        if comp:renderable() then
            comp:draw()
        end
    end
end

function Entity:conception()
    -- trigger component conception
    for _, comp in pairs(self._components) do
        comp:conception()
    end
end

function Entity:birthAttempt()
    local allComponentsReady = true
    for _, comp in pairs(self._components) do
        if not comp:isReadyForBirth() then
            allComponentsReady = false
            break
        end
    end
    if allComponentsReady then
        for _, comp in pairs(self._components) do
            comp:birth()
        end
    end
end

function Entity:death()
    -- trigger component murdering
    for _, comp in pairs(self._components) do
        comp:death()
    end
end

function Entity:burialAttempt()
    local allComponentsDead = true
    for _, comp in pairs(self._components) do
        if comp:isAlive() then
            allComponentsDead = false
            break
        end
    end
    if allComponentsDead then
        Signal.emit(Signals.REMOVE_ENTITY, self.id)
    end
end
