EntityCreator = {}

local _idCounter = 0

local function player(x, y)
    assert(x and y, "arguments missing.")

    local entity = Entity.new(_idCounter, EntityTypes.PLAYER)
    entity:addComponent(PlayerPhysicsComponent(x, y))
    entity:addComponent(RenderComponent(Colours.PLAYER_RENDER, 0, Constants.DEFAULT_DEATH_DURATION, false))
    entity:addComponent(MovementComponent(false, false))
    entity:addComponent(ShieldInputComponent())
    entity:addComponent(TrailEffectComponent(Colours.PLAYER_STEP))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function bullet(x, y, targetDirX, targetDirY)
    assert(x and y and targetDirX and targetDirY, "arguments missing.")

    local x1, y1, x2, y2 = -1, -1, -1, -1
    for _, body in pairs(Collider:shapesAt(x,y)) do
        if body.type == BodyTypes.TILE then
            x1, y1, x2, y2 = body:bbox()
            break
        end
    end

    assert(x1 ~= -1 and x2 ~= -1 and y1 ~= -1 and y2 ~= -1, "Couldn't find any tiles =(")

    -- adjust size and position of bullet's collider body so that it has the
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

    local entity = Entity.new(_idCounter, EntityTypes.BULLET, true)
    entity:addComponent(BulletPhysicsComponent(startX, startY, Constants.TILE_SIZE / 2, Constants.TILE_SIZE / 2, 1))
    entity:addComponent(RenderComponent(Colours.BULLET_RENDER, Constants.BULLET_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, false))
    entity:addComponent(ConstantMovementComponent(targetDirX, targetDirY, false))
    entity:addComponent(TrailEffectComponent(Colours.BULLET_STEP))
    return entity
end

local function boxy()
    local entity = Entity.new(_idCounter, EntityTypes.BOXY)
    entity:addComponent(BoxyBackgroundComponent())
    entity:addComponent(BoxyAIComponent())
    return entity
end

local function deathWall(x, y, maxVelFactor)
    assert(x and y and maxVelFactor, "arguments missing.")

    x = x or 1
    y = y or 0

    -- x and y is the velocity direction, and also determines the starting position
    -- the only valid values of (x,y) are (0,-1), (0, 1), (-1, 0) and (1, 0)
    assert((x == 0 and y == -1) or (x == 0 and y == 1) or 
        (x == -1 and y == 0) or (x == 1 and y == 0), 
        "Invalid values of 'x' and 'y' parameters of death wall")

    local startX = 0
    local startY = 0
    local width = 0
    local height = 0

    if x ~= 0 then
        width = Constants.TILE_SIZE
        height = love.graphics.getHeight() - 2

        startY = 1
        if x == 1 then
            startX = 1
        else
            startX = love.graphics.getWidth() - width - 1
        end
    else
        width = love.graphics.getWidth() - 2
        height = Constants.TILE_SIZE

        startX = 1
        if y == 1 then
            startY = 1
        else
            startY = love.graphics.getHeight() - height - 1
        end
    end

    local entity = Entity.new(_idCounter, EntityTypes.DEATH_WALL, true)
    entity:addComponent(DeathWallPhysicsComponent(startX, startY, width, height))
    entity:addComponent(ConstantMovementComponent(x, y, Constants.TERMINAL_VELOCITY * maxVelFactor))
    entity:addComponent(RenderComponent(Colours.DEATH_WALL_RENDER, Constants.DEATH_WALL_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function bouncer(x, y, targetDirX, targetDirY)
    assert(x and y and targetDirX and targetDirY, "arguments missing.")

    local entity = Entity.new(_idCounter, EntityTypes.BOUNCER, false)
    entity:addComponent(BouncerMovementComponent(targetDirX, targetDirY, Constants.TERMINAL_VELOCITY / 5, 10))
    entity:addComponent(BouncerPhysicsComponent(x, y, Constants.TILE_SIZE * 2, Constants.TILE_SIZE * 2))
    entity:addComponent(HPComponent(Constants.BOUNCER_HP, Signals.BOUNCER_HIT))
    entity:addComponent(RenderComponent(Colours.BOUNCER_RENDER, Constants.BOUNCER_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function shield(masterEntity)
    assert(masterEntity, "arguments missing.")

    local entity = Entity.new(_idCounter, EntityTypes.SHIELD, true)

    entity:addComponent(ShieldPhysicsComponent(masterEntity))
    entity:addComponent(ShieldRenderComponent(Colours.SHIELD_RENDER, 0.5, 0.5, Constants.TILE_SIZE))

    return entity
end

local function bouncerSword(masterEntity)
    assert(masterEntity, "argument missing.")

    local entity = Entity.new(_idCounter, EntityTypes.BOUNCER_SWORD, false)

    entity:addComponent(BouncerSwordPhysicsComponent(masterEntity))
    entity:addComponent(BouncerSwordRenderComponent(Colours.BOUNCER_SWORD_RENDER, 0.5, 0.5))

    return entity
end

function EntityCreator.create(entityType, ...)
    _idCounter = _idCounter + 1
    if entityType == EntityTypes.PLAYER then
        return player(...)
    elseif entityType == EntityTypes.BULLET then
        return bullet(...)
    elseif entityType == EntityTypes.BOXY then
        return boxy(...)
    elseif entityType == EntityTypes.DEATH_WALL then
        return deathWall(...)
    elseif entityType == EntityTypes.BOUNCER then
        return bouncer(...)
    elseif entityType == EntityTypes.SHIELD then
        return shield(...)
    elseif entityType == EntityTypes.BOUNCER_SWORD then
        return bouncerSword(...)
    end

    -- function should've returned an entity by this point,
    -- if this row is reached, the specified type doesn't exist
    error("Invalid entity entityType: " .. entityType)
end