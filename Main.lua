HC = require "hardoncollider"
require "World"
require "Entity" 
require "component.RenderComponent"
require "component.PhysicsComponent"
require "component.MovementComponent"

function love.load()
    io.stdout:setvbuf("no")

    Collider = HC(100, on_collide)

    walls = generateWalls(Collider, love.graphics.getWidth(), love.graphics.getHeight())
    floor = generateFloor(Collider, love.graphics.getWidth(), love.graphics.getHeight(), 32)

    entity = Entity.new("Player")
    physicsComponent = PhysicsComponent(Collider, 200, 200, 1, 1)

    entity:addComponent(physicsComponent)
    entity:addComponent(RenderComponent(physicsComponent))
    entity:addComponent(MovementComponent(physicsComponent))
    
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
    entity:update(dt)

    if love.keyboard.isDown("w") then
        entity:getComponent("movement"):moveUp()
    end
    if love.keyboard.isDown("a") then
        entity:getComponent("movement"):moveLeft()
    end
    if love.keyboard.isDown("s") then
        entity:getComponent("movement"):moveDown()
    end
    if love.keyboard.isDown("d") then
        entity:getComponent("movement"):moveRight()
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
        canvas:clear()
        local oldR, oldG, oldB, oldA = love.graphics.getColor()

        love.graphics.setColor(0, 0, 0, 100)
        walls.bottom:draw('fill')
        walls.left:draw('fill')
        walls.right:draw('fill')
        walls.top:draw('fill')

        drawFloor(floor)

        love.graphics.setColor(oldR, oldG, oldB, oldA)
        
        entity:draw()
    love.graphics.setCanvas()

    love.graphics.setShader(shader)
        love.graphics.draw(canvas)
    love.graphics.setShader()
end

function love.keyreleased(key)
    if key == ' ' then

    end
end