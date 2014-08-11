Entities = {}

Entities._entityArray = {}
Entities._toRemove = {}

Signal.register("add entity", function(entity)
    Entities._entityArray[entity.id] = entity
end)

Signal.register("kill entity", function(id)
    table.insert(Entities._toRemove, id)
end)

function Entities.update(dt)
    if #Entities._toRemove ~= 0 then
        for removeKey, entityId in pairs(Entities._toRemove) do
            --print("removing entity with id: " .. entityId .. ", active entities: " .. #Entities._entityArray)
            Entities._entityArray[entityId]:kill()
            Entities._entityArray[entityId] = nil
            Entities._toRemove[removeKey] = nil
        end
    end

    for _, entity in pairs(Entities._entityArray) do
        entity:update(dt)
    end
end

function Entities.draw()
    for _, entity in pairs(Entities._entityArray) do
        entity:draw()
    end
end