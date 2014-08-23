EntityCreator = {}

local _idCounter = 0

function EntityCreator.create(type, x, y, ...)
    _idCounter = _idCounter + 1
    if type == "player" then
        local entity = Entity.new(_idCounter, "player")
        entity:addComponent(PhysicsComponent(x, y, 0.1, 0.1))
        entity:addComponent(VelocityRectangleRenderComponent())
        entity:addComponent(MovementComponent())
        entity:addComponent(WasdComponent())
        return entity
    elseif type == "bullet" then
        if select("#", ...) < 2 then
            error("Arguments missing.")
        end
        local targetDirX, targetDirY = select(1, ...)

        local x1, y1, x2, y2 = -1, -1, -1, -1
        for _, shape in pairs(Collider:shapesAt(x,y)) do
            if shape.type == "tile" then
                x1, y1, x2, y2 = shape:bbox()
            end
        end

        if x1 ~= -1 and x2 ~= -1 and y1 ~= -1 and y2 ~= -1 then
            -- adjust size and position of bullet's collider shape so that it has the
            -- dimensions of a stick going in a direction perpendicular to its (longer) side

            -- adjust height and width
            local width = x2 - x1 - 2
            local height = y2 - y1 - 2
            if targetDirX ~= 0 then
                width = 1
            elseif targetDirY ~= 0 then
                height = 1
            end

            -- adjust starting position
            local startX = x1 + 1
            local startY = y1 + 1
            if targetDirX == -1 then
                startX = x2 - 2
            elseif targetDirY == -1 then
                startY = y2 - 2
            end

            local entity = Entity.new(_idCounter, "bullet")
            entity:addComponent(BulletPhysicsComponent(startX, startY, width, height))
            entity:addComponent(RotatingRectangleRenderComponent())
            entity:addComponent(ConstantMovementComponent(targetDirX, targetDirY))
            return entity
        else
            error("Couldn't find any tiles =(")
        end
    elseif type == "boxy" then
        local entity = Entity.new(_idCounter, "boxy")
        entity:addComponent(BoxyBackgroundComponent())
        entity:addComponent(BoxyAIComponent())
        return entity
    end
    error("Invalid entity type: " .. type)
end
