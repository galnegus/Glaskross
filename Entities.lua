Entities = {}

local _entityArray = {}
local _toKill = {}
local _toRemove = {}

Signal.register(Signals.ADD_ENTITY, function(entity)
    _entityArray[entity.id] = entity
    entity:conception()
end)

Signal.register(Signals.KILL_ENTITY, function(id)
    _toKill[id] = true
end)

Signal.register(Signals.REMOVE_ENTITY, function(id)
    _toRemove[id] = true
end)

function Entities.update(dt)
    for entityId, _ in pairs(_toKill) do
        _entityArray[entityId]:death()
        _toKill[entityId] = nil
    end

    for entityId, _ in pairs(_toRemove) do
        _entityArray[entityId] = nil
        _toRemove[entityId] = nil
    end

    for _, entity in pairs(_entityArray) do
        -- bullets get finer granularity (defined in Constants.lua) to avoid "tunneling"
        if entity:bullet() then
            local dtBullet = dt
            while dtBullet > Constants.BULLET_TIMESLICE do
                dtBullet = dtBullet - Constants.BULLET_TIMESLICE

                entity:update(Constants.BULLET_TIMESLICE)
                Collider:update(Constants.BULLET_TIMESLICE)
            end
            entity:update(dtBullet)
        else
            entity:update(dt)
        end
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