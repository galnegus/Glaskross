WasdComponent = Class{}
WasdComponent:include(Component)

function WasdComponent:init()
    Component.init(self)

    self.type = "input"

    self._bullet = true
end

function WasdComponent:setOwner(owner)
    Component.setOwner(self, owner)
end

function WasdComponent:update(dt)
    if love.keyboard.isDown("w") then
        self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "up")
    end
    if love.keyboard.isDown("a") then
        self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "left")
    end
    if love.keyboard.isDown("s") then
        self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "down")
    end
    if love.keyboard.isDown("d") then
        self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "right")
    end
    if love.keyboard.isDown("left") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("bullet", x - Constants.TILE_SIZE, y, -1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("up") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("bullet", x, y - Constants.TILE_SIZE, 0, -1))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("right") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("bullet", x + Constants.TILE_SIZE, y, 1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("down") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create("bullet", x, y + Constants.TILE_SIZE, 0, 1))
            self:_bulletCooldown()
        end
    end
end

function WasdComponent:_bulletCooldown()
    self._bullet = false
    Timer.add(0.5, function() self._bullet = true end)
end
