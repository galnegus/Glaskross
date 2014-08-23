Class = require "lib.hump.class"
Signal = require 'lib.hump.signal'
Timer = require "lib.hump.timer"
Vector = require "lib.hump.vector"
HC = require "lib.hardoncollider"
Constants = require "constants"
Gamestate = require "lib.venus.venus"
require "Entities"
require "Entity"
require "EntityCreator"
require "Tile"
require "World"
require "component.Component"
require "component.ai.BoxyAIComponent"
require "component.ai.BoxyBeamPattern"
require "component.ai.PatternChainer"
require "component.background.BoxyBackgroundComponent"
require "component.render.RenderComponent"
require "component.render.RotatingRectangleRenderComponent"
require "component.render.VelocityRectangleRenderComponent"
require "component.physics.PhysicsComponent"
require "component.physics.BulletPhysicsComponent"
require "component.movement.MovementComponent"
require "component.movement.ConstantMovementComponent"
require "component.WasdComponent"
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