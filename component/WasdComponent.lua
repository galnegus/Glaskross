WasdComponent = Class{}
WasdComponent:include(Component)

function WasdComponent:init()
    self.type = "input"

    self._shoot = true
end

function WasdComponent:setOwner(owner)
    Component.setOwner(self, owner)
end

function WasdComponent:update(dt)
    if love.keyboard.isDown("w") then
        self.owner.events:emit("set movement direction", "up")
    end
    if love.keyboard.isDown("a") then
        self.owner.events:emit("set movement direction", "left")
    end
    if love.keyboard.isDown("s") then
        self.owner.events:emit("set movement direction", "down")
    end
    if love.keyboard.isDown("d") then
        self.owner.events:emit("set movement direction", "right")
    end
    if love.keyboard.isDown("left") then
        if self._shoot then
            local x, y = self.owner.physics._body:center()
            Signal.emit("add entity", EntityCreator.create("bullet", x - Constants.TILE_SIZE, y, -1, 0))
            self:_shootCooler()
        end
    end
    if love.keyboard.isDown("up") then
        if self._shoot then
            local x, y = self.owner.physics._body:center()
            Signal.emit("add entity", EntityCreator.create("bullet", x, y - Constants.TILE_SIZE, 0, -1))
            self:_shootCooler()
        end
    end
    if love.keyboard.isDown("right") then
        if self._shoot then
            local x, y = self.owner.physics._body:center()
            Signal.emit("add entity", EntityCreator.create("bullet", x + Constants.TILE_SIZE, y, 1, 0))
            self:_shootCooler()
        end
    end
    if love.keyboard.isDown("down") then
        if self._shoot then
            local x, y = self.owner.physics._body:center()
            Signal.emit("add entity", EntityCreator.create("bullet", x, y + Constants.TILE_SIZE, 0, 1))
            self:_shootCooler()
        end
    end
end

function WasdComponent:_shootCooler()
    self._shoot = false
    Timer.add(0.5, function() self._shoot = true end)
end
