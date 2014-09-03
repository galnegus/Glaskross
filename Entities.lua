Entities = {}

local _entityArray = {}
local _toRemove = {}

Signal.register("add entity", function(entity)
    _entityArray[entity.id] = entity
end)

Signal.register("kill entity", function(id)
    _toRemove[id] = true
end)

function Entities.update(dt)
    for entityId, _ in pairs(_toRemove) do
        _entityArray[entityId]:kill()
        _entityArray[entityId] = nil
        _toRemove[entityId] = nil
    end

    for _, entity in pairs(_entityArray) do
        -- bullets get finer granularity (atm 120 updates/second) to avoid "tunneling"
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