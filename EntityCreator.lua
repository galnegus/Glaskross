EntityCreator = {}

EntityCreator._idCounter = 0

function EntityCreator.create(type, x, y, ...)
    EntityCreator._idCounter = EntityCreator._idCounter + 1
    if type == "player" then
        local entity = Entity.new(EntityCreator._idCounter, "player")
        entity:addComponent(PhysicsComponent(Collider, x, y, 1, 1))
        entity:addComponent(RenderComponent())
        entity:addComponent(MovementComponent())
        entity:addComponent(WasdComponent())
        return entity
    elseif type == "glare" then
        if select("#", ...) < 2 then
            error("Arguments missing.")
        end
        
        local a, b = select(1, ...)
        print("a: " .. a .. ", b: " .. b)
        --
    end
    error("Invalid entity type: " .. type)
end
