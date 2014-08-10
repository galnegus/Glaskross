Class = require "hump.class"
Signal = require 'hump.signal'
Timer = require "hump.timer"
Vector = require "hump.vector"
HC = require "hardoncollider"
Constants = require "constants"

require "World"
require "Entity"
require "Entities"
require "EntityCreator"
require "component.Component"
require "component.RenderComponent"
require "component.PhysicsComponent"
require "component.MovementComponent"
require "component.WasdComponent"

function love.load()
    io.stdout:setvbuf("no")

    Collider = HC(100, on_collide)

    world = World(Collider, love.graphics.getWidth(), love.graphics.getHeight(), Constants.TILE_SIZE)

    Signal.emit("add entity", EntityCreator.create("player", 200, 200))
    Signal.emit("add entity", EntityCreator.create("glare", 200, 200, 3, 5))
    
    shader = love.graphics.newShader("shader.fs")
    canvas = love.graphics.newCanvas()
    love.graphics.setBackgroundColor(25, 25, 25)
end

function on_collide(dt, shape_a, shape_b, dx, dy)
    --print("dx: " .. dx .. ", dy: " .. dy)
    if shape_a.owner ~= nil then
        shape_a.owner:on_collide(dt, shape_b, dx, dy)
    end
    if shape_b.owner ~= nil then
        shape_b.owner:on_collide(dt, shape_a)
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

    end
end