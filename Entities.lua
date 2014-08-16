Entities = {}

local _entityArray = {}
local _toRemove = {}

Signal.register("add entity", function(entity)
    _entityArray[entity.id] = entity
end)

Signal.register("kill entity", function(id)
    table.insert(_toRemove, id)
end)

function Entities.update(dt)
    if #_toRemove ~= 0 then
        for removeKey, entityId in pairs(_toRemove) do
            --print("removing entity with id: " .. entityId .. ", active entities: " .. #_entityArray)
            _entityArray[entityId]:kill()
            _entityArray[entityId] = nil
            _toRemove[removeKey] = nil
        end
    end

    for _, entity in pairs(_entityArray) do
        entity:update(dt)
    end
end

function Entities.bgDraw()
    for _, entity in pairs(_entityArray) do
        entity:bgDraw()
    end
end
function Entities.draw()
    for _, entity in pairs(_entityArray) do
        entity:draw()
    end
end