Entity = {}
Entity.__index = Entity

function Entity.new(id, type)
    local e = {}

    e.id = id
    e.type = type
    e.events = Signal.new()

    -- user for update() and draw()
    e._components = {}

    return setmetatable(e, Entity)
end

function Entity:addComponent(component)
    self._components[component.type] = component
    self[component.type] = component
    component:setOwner(self)
end

function Entity:update(dt)
    for compType, comp in pairs(self._components) do
        comp:update(dt)
    end
end

function Entity:draw()
    for compType, comp in pairs(self._components) do
        if compType == "render" then
            comp:draw()
        end
    end
end