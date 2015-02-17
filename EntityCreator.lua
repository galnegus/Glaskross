EntityCreator = {}

local _idCounter = 0

local function player(x, y)
    assert(x and y, "arguments missing.")

    local collisionGroups = {
        CollisionGroups.FRIENDLY
    }

    local collisionRules = {
        [BodyTypes.WALL] = {
            CollisionRules.StopMovement()
        }
    }

    local bodyOptions = {
        shape = Collider:addRectangle(x, y, Constants.TILE_SIZE, Constants.TILE_SIZE),
        bodyType = BodyTypes.PLAYER,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules
    }

    local entity = Entity.new(_idCounter, EntityTypes.PLAYER)
    entity:addComponent(VelocityRotatingPhysicsComponent(bodyOptions))
    entity:addComponent(RenderComponent(Colours.PLAYER_RENDER, 0, Constants.DEFAULT_DEATH_DURATION, true))
    entity:addComponent(MovementComponent(false, false))
    entity:addComponent(ShieldInputComponent())
    entity:addComponent(OptimizedTrailEffectComponent(Colours.PLAYER_STEP))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function bullet(x, y, targetDirX, targetDirY)
    assert(x and y and targetDirX and targetDirY, "arguments missing.")
    local xTile, yTile = world:closestTileCenter(x, y)
    assert(xTile >= 0 and yTile >= 0, "Couldn't find any tiles =(") -- TODO: ADD LESS THAN HEIGHT / WIDTH

    -- adjust height and width
    local tileSize = Constants.TILE_SIZE
    local width = tileSize / 2
    local height = tileSize / 2

    -- adjust starting position
    local startX = xTile - tileSize / 4 * math.abs(targetDirY) + tileSize / 4 * targetDirX
    local startY = yTile - tileSize / 4 * math.abs(targetDirX) + tileSize / 4 * targetDirY

    if targetDirX == 1 then
        startX = startX - tileSize / 2
    elseif targetDirY == 1 then
        startY = startY - tileSize / 2
    end

    local collisionGroups = {
        CollisionGroups.FRIENDLY
    }

    local collisionRules = {
        [BodyTypes.WALL] = {
            CollisionRules.SelfDestruct()
        }, 
        [BodyTypes.ENEMY] = {
            CollisionRules.SelfDestruct(),
            CollisionRules.Destroy()
        }
    }

    local bodyOptions = {
        shape = Collider:addRectangle(startX, startY, width, height),
        bodyType = BodyTypes.PLAYER_WEAPON,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules,
        rps = 1
    }

    local entity = Entity.new(_idCounter, EntityTypes.BULLET, true)
    entity:addComponent(RotatingPhysicsComponent(bodyOptions))
    entity:addComponent(RenderComponent(Colours.BULLET_RENDER, Constants.BULLET_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, false))
    entity:addComponent(ConstantMovementComponent(targetDirX, targetDirY, false))
    entity:addComponent(OptimizedTrailEffectComponent(Colours.BULLET_STEP))
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

    local collisionGroups = {
        CollisionGroups.HOSTILE
    }

    local collisionRules = {
        [BodyTypes.PLAYER] = {
            CollisionRules.Destroy(),
            CollisionRules.SelfDestruct()
        }
    }

    local bodyOptions = {
        shape = Collider:addRectangle(startX, startY, width, height),
        bodyType = BodyTypes.ENEMY,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules
    }

    local entity = Entity.new(_idCounter, EntityTypes.DEATH_WALL, true)
    entity:addComponent(DeathWallPhysicsComponent(bodyOptions))
    entity:addComponent(ConstantMovementComponent(x, y, Constants.TERMINAL_VELOCITY * maxVelFactor))
    entity:addComponent(RenderComponent(Colours.DEATH_WALL_RENDER, Constants.DEATH_WALL_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function bouncer(x, y, targetDirX, targetDirY)
    assert(x and y and targetDirX and targetDirY, "arguments missing.")

    local collisionGroups = {
        CollisionGroups.HOSTILE
    }

    local collisionRules = {
        [BodyTypes.WALL] = {
            CollisionRules.Bounce()
        },
        [BodyTypes.PLAYER] = {
            CollisionRules.Destroy(),
            CollisionRules.SelfDestruct()
        }
    }

    local bodyOptions = {
        shape = Collider:addRectangle(x, y, Constants.TILE_SIZE * 2, Constants.TILE_SIZE * 2),
        bodyType = BodyTypes.ENEMY,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules
    }

    local entity = Entity.new(_idCounter, EntityTypes.BOUNCER, false)
    entity:addComponent(BouncerMovementComponent(targetDirX, targetDirY, Constants.TERMINAL_VELOCITY / 5, 10))
    entity:addComponent(BouncerPhysicsComponent(bodyOptions))
    entity:addComponent(HPComponent(Constants.BOUNCER_HP, Signals.BOUNCER_HIT))
    entity:addComponent(RenderComponent(Colours.BOUNCER_RENDER, Constants.BOUNCER_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
    entity:addComponent(ParticleDeathEffectComponent(1))
    return entity
end

local function shield(masterEntity)
    assert(masterEntity, "arguments missing.")

    local collisionGroups = {
        CollisionGroups.FRIENDLY
    }

    local collisionRules = {
        [BodyTypes.ENEMY] = {
            CollisionRules.Destroy()
        }
    }

    local x, y = masterEntity.physics:center()
    local bodyOptions = {
        shape = Collider:addPolygon(x - Constants.TILE_SIZE * 1.5, y, 
                                    x, y - Constants.TILE_SIZE * 1.5, 
                                    x + Constants.TILE_SIZE * 1.5, y),
        bodyType = BodyTypes.PLAYER_WEAPON,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules,
        masterEntity = masterEntity
    }

    local entity = Entity.new(_idCounter, EntityTypes.SHIELD, true)
    entity:addComponent(ShieldPhysicsComponent(bodyOptions))
    entity:addComponent(ShieldRenderComponent(Colours.SHIELD_RENDER, 0.5, 0.5, Constants.TILE_SIZE))

    return entity
end

local function bouncerSword(masterEntity)
    assert(masterEntity, "argument missing.")

    local collisionGroups = {
        CollisionGroups.HOSTILE,
        CollisionGroups.IGNORE_WALLS
    }

    local collisionRules = {
        [BodyTypes.PLAYER] = {
            CollisionRules.Destroy()
        }
    }

    local x, y = masterEntity.physics:center()
    local bodyOptions = {
        shape = Collider:addRectangle(x, y, 5, Constants.TILE_SIZE * 10),
        bodyType = BodyTypes.ENEMY_WEAPON,
        collisionGroups = collisionGroups,
        collisionRules = collisionRules,
        masterEntity = masterEntity,
        rps = 1
    }

    local entity = Entity.new(_idCounter, EntityTypes.BOUNCER_SWORD, false)
    entity:addComponent(BouncerSwordPhysicsComponent(bodyOptions))
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