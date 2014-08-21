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
require "component.ai.BoxyAIComponent"
require "component.ai.BoxyBeamPattern"
require "component.ai.PatternChainer"
require "component.background.BoxyBackgroundComponent"
require "component.render.RenderComponent"
require "component.render.RotatingRectangleRenderComponent"
require "component.render.VelocityRectangleRenderComponent"
require "component.physics.PhysicsComponent"
require "component.physics.GlarePhysicsComponent"
require "component.movement.MovementComponent"
require "component.movement.ConstantMovementComponent"
require "component.WasdComponent"

function love.load()
    io.stdout:setvbuf("no")
    Collider = HC(100, on_collide)

    world = World(love.graphics.getWidth(), love.graphics.getHeight(), Constants.TILE_SIZE)

    Signal.emit("add entity", EntityCreator.create("player", 300, 300))
    Signal.emit("add entity", EntityCreator.create("boxy"))
    
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
    Entities.update(dt)
    world:update(dt)
    Timer.update(dt)
    Collider:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
        local r, g, b, a = love.graphics.getColor()
            canvas:clear()
            Entities.bgDraw()
            world:draw()
            Entities.draw()
        love.graphics.setColor(r, g, b, a)
    love.graphics.setCanvas()

    love.graphics.setShader(shader)
        love.graphics.draw(canvas)
    love.graphics.setShader()


    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.keyreleased(key)
    if key == ' ' then
        tiles1 = world:getFloorSection(1, 1)
        tiles2 = world:getFloorSection(2, 2)
        tiles3 = world:getFloorSection(3, 1)
        tiles4 = world:getFloorSection(4, 2)

        for _, tile in pairs(tiles1) do
            tile:areaBeam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles2) do
            tile:areaBeam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles3) do
            tile:areaBeam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles4) do
            tile:areaBeam(nil, 100, 50, 50)
        end

        --ignal.emit("kill entity", 1)
    end
end