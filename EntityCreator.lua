local Entity = require "Entity"

local BoxyAIComponent = require "component.ai.BoxyAIComponent"
local DeathWallBodyComponent = require "component.body.DeathWallBodyComponent"
local BoxyBackgroundComponent = require "component.background.BoxyBackgroundComponent"
local VelocityRotatingBodyComponent = require "component.body.VelocityRotatingBodyComponent"
local BouncerBodyComponent = require "component.body.BouncerBodyComponent"
local RotatingBodyComponent = require "component.body.RotatingBodyComponent"
local ShieldBodyComponent = require "component.body.ShieldBodyComponent"
local BouncerSwordBodyComponent = require "component.body.BouncerSwordBodyComponent"
local ParticleDeathEffectComponent = require "component.deatheffect.ParticleDeathEffectComponent"
local ShieldInputComponent = require "component.input.ShieldInputComponent"
local MovementComponent = require "component.movement.MovementComponent"
local ConstantMovementComponent =  require "component.movement.ConstantMovementComponent"
local BouncerMovementComponent = require "component.movement.BouncerMovementComponent"
local ShieldRenderComponent = require "component.render.ShieldRenderComponent"
local RenderComponent = require "component.render.RenderComponent"
local HPComponent = require "component.HPComponent"
local OptimizedTrailEffectComponent = require "component.OptimizedTrailEffectComponent"

local BodyTypes = require "constants.BodyTypes"
local CollisionRules = require "constants.CollisionRules"
local EntityTypes = require "constants.EntityTypes"
local Colors = require "constants.Colors"
local Signals = require "constants.Signals"
local Constants = require "constants.Constants"

EntityCreator = {}

local _idCounter = 0

local function player(x, y)
  assert(x and y, "arguments missing.")

  local collisionRules = {
    [BodyTypes.WALL] = {
      CollisionRules.StopMovement()
    }
  }

  local bodyOptions = {
    shape = HC.rectangle(x, y, Constants.TILE_SIZE, Constants.TILE_SIZE),
    bodyType = BodyTypes.PLAYER,
    collisionRules = collisionRules
  }

  local entity = Entity.new(_idCounter, EntityTypes.PLAYER)
  entity:addComponent(VelocityRotatingBodyComponent(bodyOptions))
  entity:addComponent(RenderComponent(Colors.PLAYER_RENDER, 0, Constants.DEFAULT_DEATH_DURATION, true))
  entity:addComponent(MovementComponent(false, false))
  entity:addComponent(ShieldInputComponent())
  entity:addComponent(OptimizedTrailEffectComponent(Colors.PLAYER_STEP))
  entity:addComponent(ParticleDeathEffectComponent(1))
  return entity
end

local function bullet(x, y, targetDirX, targetDirY)
  assert(x and y and targetDirX and targetDirY, "arguments missing.")
  local xTile, yTile = game.world:closestTileCenter(x, y)
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
    shape = HC.rectangle(startX, startY, width, height),
    bodyType = BodyTypes.PLAYER_WEAPON,
    collisionRules = collisionRules,
    rps = 1
  }

  local entity = Entity.new(_idCounter, EntityTypes.BULLET, true)
  entity:addComponent(RotatingBodyComponent(bodyOptions))
  entity:addComponent(RenderComponent(Colors.BULLET_RENDER, Constants.BULLET_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, false))
  entity:addComponent(ConstantMovementComponent(targetDirX, targetDirY, false))
  entity:addComponent(OptimizedTrailEffectComponent(Colors.BULLET_STEP))
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

  local startX, startY, width, height

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

  local collisionRules = {
    [BodyTypes.PLAYER] = {
      CollisionRules.Destroy(),
      CollisionRules.SelfDestruct()
    }
  }

  local bodyOptions = {
    shape = HC.rectangle(startX, startY, width, height),
    bodyType = BodyTypes.ENEMY,
    collisionRules = collisionRules
  }

  local entity = Entity.new(_idCounter, EntityTypes.DEATH_WALL, true)
  entity:addComponent(DeathWallBodyComponent(bodyOptions))
  entity:addComponent(ConstantMovementComponent(x, y, Constants.TERMINAL_VELOCITY * maxVelFactor))
  entity:addComponent(RenderComponent(Colors.DEATH_WALL_RENDER, Constants.DEATH_WALL_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
  entity:addComponent(ParticleDeathEffectComponent(1))
  return entity
end

local function bouncer(x, y, targetDirX, targetDirY)
  assert(x and y and targetDirX and targetDirY, "arguments missing.")

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
    shape = HC.rectangle(x, y, Constants.TILE_SIZE * 2, Constants.TILE_SIZE * 2),
    bodyType = BodyTypes.ENEMY,
    collisionRules = collisionRules
  }

  local entity = Entity.new(_idCounter, EntityTypes.BOUNCER, false)
  entity:addComponent(BouncerMovementComponent(targetDirX, targetDirY, Constants.TERMINAL_VELOCITY / 3, 10))
  entity:addComponent(BouncerBodyComponent(bodyOptions))
  entity:addComponent(HPComponent(Constants.BOUNCER_HP, Signals.BOUNCER_HIT))
  entity:addComponent(RenderComponent(Colors.BOUNCER_RENDER, Constants.BOUNCER_BIRTH_DURATION, Constants.DEFAULT_DEATH_DURATION, true))
  entity:addComponent(ParticleDeathEffectComponent(1))
  return entity
end

local function shield(masterEntity)
  assert(masterEntity, "arguments missing.")

  local collisionRules = {
    [BodyTypes.ENEMY] = {
      CollisionRules.Destroy()
    }
  }

  local x, y = masterEntity.body:center()
  local bodyOptions = {
    shape = HC.polygon(x - Constants.TILE_SIZE * 1.5, y, 
                  x, y - Constants.TILE_SIZE * 1.5, 
                  x + Constants.TILE_SIZE * 1.5, y),
    bodyType = BodyTypes.PLAYER_WEAPON,
    collisionRules = collisionRules,
    masterEntity = masterEntity
  }

  local entity = Entity.new(_idCounter, EntityTypes.SHIELD, true)
  entity:addComponent(ShieldBodyComponent(bodyOptions))
  entity:addComponent(ShieldRenderComponent(Colors.SHIELD_RENDER, 0.5, 0.5, Constants.TILE_SIZE))

  return entity
end

local function bouncerSword(masterEntity)
  assert(masterEntity, "argument missing.")

  local collisionRules = {
    [BodyTypes.PLAYER] = {
      CollisionRules.Destroy()
    }
  }

  local x, y = masterEntity.body:center()
  local tileSize = Constants.TILE_SIZE
  local swordLength = tileSize * 5
  local swordWidth = 2
  local centerHeight = tileSize / 5
  local centerWidth = tileSize

  --[[ 
  it looks like this:
    ___ _ ___
    ___|_|___
  ]]
  local bodyOptions = {
    shape = HC.polygon(x - swordLength, y + centerHeight,
      x - swordLength, y + centerHeight - swordWidth,
      x - centerWidth, y + centerHeight - swordWidth, 
      x - centerWidth, y - centerHeight + swordWidth, 
      x - swordLength, y - centerHeight + swordWidth, 
      x - swordLength, y - centerHeight, 
      x + swordLength, y - centerHeight, 
      x + swordLength, y - centerHeight + swordWidth, 
      x + centerWidth, y - centerHeight + swordWidth, 
      x + centerWidth, y + centerHeight - swordWidth, 
      x + swordLength, y + centerHeight - swordWidth, 
      x + swordLength, y + centerHeight),
    bodyType = BodyTypes.ENEMY_WEAPON,
    collisionRules = collisionRules,
    masterEntity = masterEntity,
    rps = 1
  }

  local entity = Entity.new(_idCounter, EntityTypes.BOUNCER_SWORD, false)
  entity:addComponent(BouncerSwordBodyComponent(bodyOptions))
  entity:addComponent(RenderComponent(Colors.BOUNCER_SWORD_RENDER, 0.5, 0.5, true))

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