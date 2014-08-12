Class = require "hump.class"
Signal = require 'hump.signal'
Timer = require "hump.timer"
Vector = require "hump.vector"
HC = require "hardoncollider"
Constants = require "constants"
require "Entities"
require "Entity"
require "EntityCreator"
require "Tile"
require "World"
require "component.Component"
require "component.render.RenderComponent"
require "component.render.PlayerRenderComponent"
require "component.physics.PhysicsComponent"
require "component.physics.GlarePhysicsComponent"
require "component.movement.MovementComponent"
require "component.movement.GlareMovementComponent"
require "component.WasdComponent"

function love.load()
    io.stdout:setvbuf("no")
    Collider = HC(100, on_collide)

    world = World(love.graphics.getWidth(), love.graphics.getHeight(), Constants.TILE_SIZE)

    Signal.emit("add entity", EntityCreator.create("player", 300, 300))
    
    shader = love.graphics.newShader("shader.fs")
    canvas = love.graphics.newCanvas()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function on_collide(dt, shape_a, shape_b, dx, dy)
    --print("dx: " .. dx .. ", dy: " .. dy)
    if shape_a.parent ~= nil then
        shape_a.parent:on_collide(dt, shape_b, dx, dy)
    end
    if shape_b.parent ~= nil then
        shape_b.parent:on_collide(dt, shape_a)
    end
end

function love.update(dt)
    Collider:update(dt)
    Timer.update(dt)
    Entities.update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
        canvas:clear()
        world:draw()
        Entities.draw()
    love.graphics.setCanvas()

    love.graphics.setShader(shader)
        love.graphics.draw(canvas)
    love.graphics.setShader()
end

function love.keyreleased(key)
    if key == ' ' then
        Signal.emit("kill entity", 1)
    end
end