game = {}

function game:init()
    Collider = HC(32, on_collide)

    world = World(love.graphics.getWidth(), love.graphics.getHeight(), Constants.TILE_SIZE)

    gameTimer = Timer.new()

    Signal.emit("add entity", EntityCreator.create("player", 355, 500))
    Signal.emit("add entity", EntityCreator.create("boxy"))
end

function on_collide(dt, shape_a, shape_b, dx, dy)
    if shape_a.parent ~= nil then
        shape_a.parent:on_collide(dt, shape_b, dx, dy)
    end
    if shape_b.parent ~= nil then
        shape_b.parent:on_collide(dt, shape_a)
    end
end

function game:update(dt)
    Entities.update(dt)
    world:update(dt)
    gameTimer:update(dt)
    Collider:update(dt)
end

function game:draw()
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


    love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS( )), 10, 10)
end

function game:keyreleased(key)
    if key == " " then
        tiles1 = world:getFloorSection(1, 1)
        tiles2 = world:getFloorSection(2, 2)
        tiles3 = world:getFloorSection(3, 1)
        tiles4 = world:getFloorSection(4, 2)

        for _, tile in pairs(tiles1) do
            tile:beam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles2) do
            tile:beam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles3) do
            tile:beam(nil, 100, 50, 50)
        end
        for _, tile in pairs(tiles4) do
            tile:beam(nil, 100, 50, 50)
        end

        --ignal.emit("kill entity", 1)
    end

    if key == "escape" then
        Gamestate.switch(menu)
        Gamestate.switch(menu)
    end
end