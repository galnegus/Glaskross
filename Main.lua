-- libs
Class = require "lib.hump.class"
Signal = require 'lib.hump.signal'
Timer = require "lib.hump.timer"
Vector = require "lib.hump.vector"
HC = require "lib.hardoncollider"
Gamestate = require "lib.venus.venus"
require "lib.gradient"

-- constants/enums
Constants = require "constants.constants"
Signals = require "constants.Signals"
EntityTypes = require "constants.EntityTypes"
BodyTypes = require "constants.BodyTypes"
ComponentTypes = require "constants.ComponentTypes"
ColliderGroups = require "constants.ColliderGroups"

require "Colour"
Colours = require "constants.Colours"

require "Entities"
require "Entity"
require "EntityCreator"
require "Tile"
require "World"

require "component.Component"
require "component.ai.Pattern"
require "component.ai.BoxyAIComponent"
require "component.ai.BoxyBeamPattern"
require "component.ai.DeathWallPattern"
require "component.ai.PatternChainer"
require "component.background.BoxyBackgroundComponent"
require "component.background.BoxyBox"
require "component.render.RenderComponent"
require "component.render.ShieldRenderComponent"
require "component.render.BouncerSwordRenderComponent"
require "component.physics.PhysicsComponent"
require "component.physics.RotatingPhysicsComponent"
require "component.physics.VelocityRotatingPhysicsComponent"
require "component.physics.ShieldPhysicsComponent"
require "component.physics.DeathWallPhysicsComponent"
require "component.physics.PlayerPhysicsComponent"
require "component.physics.BulletPhysicsComponent"
require "component.physics.BouncerPhysicsComponent"
require "component.physics.BouncerSwordPhysicsComponent"
require "component.movement.MovementComponent"
require "component.movement.ConstantMovementComponent"
require "component.movement.BouncerMovementComponent"
require "component.input.InputComponent"
require "component.input.BulletInputComponent"
require "component.input.ShieldInputComponent"
require "component.deatheffect.ParticleDeathEffectComponent"
require "component.HPComponent"
require "component.TrailEffectComponent"
require "component.OptimizedTrailEffectComponent"
require "gamestate.Game"
require "gamestate.Menu"

function love.load()
    io.stdout:setvbuf("no")

    shader = love.graphics.newShader("shader.fs")
    canvas = love.graphics.newCanvas()
    love.graphics.setBackgroundColor(0, 0, 0)

    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function love.update(dt)
    Timer.update(dt)
end