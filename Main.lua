-- libs
Class = require "lib.hump.class"
Signal = require 'lib.hump.signal'
Timer = require "lib.hump.timer"
Vector = require "lib.hump.vector"
HC = require "lib.HC"
Gamestate = require "lib.hump.gamestate"
require "lib.gradient"

-- constants/enums
Constants = require "constants.constants"
Signals = require "constants.Signals"
EntityTypes = require "constants.EntityTypes"
BodyTypes = require "constants.BodyTypes"
ComponentTypes = require "constants.ComponentTypes"
CollisionGroups = require "constants.CollisionGroups"
CollisionRules = require "constants.CollisionRules"

require "Colour"
Colours = require "constants.Colours"

require "Entities"
require "Entity"
require "EntityCreator"
require "Tile"
require "World"
require "Helpers"

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
require "component.body.BodyComponent"
require "component.body.RotatingBodyComponent"
require "component.body.VelocityRotatingBodyComponent"
require "component.body.ShieldBodyComponent"
require "component.body.DeathWallBodyComponent"
require "component.body.BouncerBodyComponent"
require "component.body.BouncerSwordBodyComponent"
require "component.movement.MovementComponent"
require "component.movement.ConstantMovementComponent"
require "component.movement.BouncerMovementComponent"
require "component.input.InputComponent"
require "component.input.BulletInputComponent"
require "component.input.ShieldInputComponent"
require "component.deatheffect.ParticleDeathEffectComponent"
require "component.HPComponent"
require "component.OptimizedTrailEffectComponent"
require "gamestate.Game"
require "gamestate.Menu"
require "gui.GameGUI"
require "gui.HealthBar"
require "gui.EntityListGUI"

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