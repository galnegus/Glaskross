Entity = {}
Entity.__index = Entity

function Entity.new(tag)
    local e = {}

    e.tag = tag
    e.components = {}

    return setmetatable(e, Entity)
end

function Entity:addComponent(component)
    self.components[component.type] = component
    self[component.type] = component
    component:setOwner(self)
end

function Entity:getComponent(type)
    for compType, comp in pairs(self.components) do
        if type == compType then
            return comp
        end
    end
end

function Entity:update(dt)
    for compType, comp in pairs(self.components) do
        comp:update(dt)
    end
end

function Entity:draw()
    for compType, comp in pairs(self.components) do
        if compType == "render" then
            comp:draw()
        end
    end
end