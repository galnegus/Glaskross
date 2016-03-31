game = {}

function game:init()
    Collider = HC(100, on_collide)

    self.world = World(love.graphics.getWidth(), love.graphics.getHeight(), Constants.TILE_SIZE)

    self.timer = Timer.new()

    self.deathParticleSystem = love.graphics.newParticleSystem(love.graphics.newImage("square.png"), 1000)
    self.deathParticleSystem:setSpeed(Constants.TERMINAL_VELOCITY / 10, Constants.TERMINAL_VELOCITY / 5)
    self.deathParticleSystem:setLinearAcceleration(0, 0, 0, -1000)
    self.deathParticleSystem:setSpread(2 * math.pi)

    Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("player", Constants.TILE_SIZE * 19 + 2, Constants.TILE_SIZE * 14 + 2))
    Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("boxy"))

    self.greyscale = gradient {
        direction = 'horizontal';
        {5, 4, 8};
        {8, 4, 2};
    }

    self.gui = GameGUI()
end

function on_collide(dt, shape_a, shape_b, dx, dy)
    if shape_a.parent ~= nil then
        shape_a.parent:on_collide(dt, shape_b, dx, dy)
    end
    if shape_b.parent ~= nil then
        shape_b.parent:on_collide(dt, shape_a, -dx, -dy)
    end
end

function game:update(dt)
    self.deathParticleSystem:update(dt)
    Entities.update(dt)
    self.world:update(dt)
    self.timer:update(dt)
    Collider:update(dt)

    self.gui:update(dt)
end

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
    return -- tail call for a little extra bit of efficiency
    love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function game:draw()
    love.graphics.reset()
    love.graphics.setCanvas(canvas)
        local r, g, b, a = love.graphics.getColor()
            love.graphics.clear()
            drawinrect(self.greyscale, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            Entities.bgDraw()
            self.world:draw()
            Entities.draw()
            
            love.graphics.setColor(r, g, b, a)
            love.graphics.draw(self.deathParticleSystem)
           
        love.graphics.setColor(r, g, b, a)
    love.graphics.setCanvas()

    love.graphics.setShader(shader)
        love.graphics.draw(canvas)
    love.graphics.setShader()

     self.gui:draw()
end

function game:keyreleased(key)
    if key == " " then
        tiles1 = self.world:getFloorSection(1, 1)
        tiles2 = self.world:getFloorSection(2, 2)
        tiles3 = self.world:getFloorSection(3, 1)
        tiles4 = self.world:getFloorSection(4, 2)

        for _, tile in pairs(tiles1) do
            tile:beam()
        end
        for _, tile in pairs(tiles2) do
            tile:beam()
        end
        for _, tile in pairs(tiles3) do
            tile:beam()
        end
        for _, tile in pairs(tiles4) do
            tile:beam()
        end

        --ignal.emit("kill entity", 1)
    end

    if key == "escape" then
        --Gamestate.switch(menu)
        --Gamestate.switch(menu)
        --Signal.emit(Signals.BACKGROUND_COLOR, 0, 40, 40, 100)
        Signal.emit(Signals.COLOUR_INVERT)
    end
end