Entities = {}

local _entityArray = {}
local _bulletArray = {}
local _toRemove = {}

Signal.register(Signals.ADD_ENTITY, function(entity)
    _entityArray[entity.id] = entity
    entity:conception()
end)

Signal.register(Signals.KILL_ENTITY, function(id)
    _entityArray[id]:death()
end)

Signal.register(Signals.REMOVE_ENTITY, function(id)
    _toRemove[id] = true
end)

function Entities.update(dt)
    for entityId, _ in pairs(_toRemove) do
        _entityArray[entityId] = nil
        _toRemove[entityId] = nil
    end

    local bullets = {}
    for _, entity in pairs(_entityArray) do
        if entity:bullet() then
            table.insert(bullets, entity)
        else
            entity:update(dt)
        end
    end

    -- bullets get finer granularity (defined in Constants.lua) to avoid "tunneling"
    local dtBullet = dt
    while dtBullet > Constants.BULLET_TIMESLICE do
        dtBullet = dtBullet - Constants.BULLET_TIMESLICE

        for _, entity in pairs(bullets) do
            entity:update(Constants.BULLET_TIMESLICE)
        end
        Collider:update(Constants.BULLET_TIMESLICE)
    end
    for _, entity in pairs(bullets) do
        entity:update(dtBullet)
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

function Entities.list()
    return _entityArray
end