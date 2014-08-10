Entities = {}

Entities._entityArray = {}
Entities._toRemove = {}

Signal.register("add entity", function(entity)
    table.insert(Entities._entityArray, entity)
end)

Signal.register("kill entity", function(entity)
    for index, value in ipairs(Entities._entityArray) do
        if entity == value then
            table.insert(Entities._toRemove, index)
        end
    end
end)

function Entities.update(dt)
    for _, entity in pairs(Entities._entityArray) do
        entity:update(dt)
    end
end

function Entities.draw()
    for _, entity in pairs(Entities._entityArray) do
        entity:draw()
    end
end