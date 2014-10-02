PlayerInputComponent = Class{}
PlayerInputComponent:include(Component)

function PlayerInputComponent:init()
    Component.init(self)

    self.type = ComponentTypes.INPUT

    self._bullet = true
end

function PlayerInputComponent:setOwner(owner)
    Component.setOwner(self, owner)
end

function PlayerInputComponent:update(dt)
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
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x - Constants.TILE_SIZE, y, -1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("up") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y - Constants.TILE_SIZE, 0, -1))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("right") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x + Constants.TILE_SIZE, y, 1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("down") then
        if self._bullet then
            local x, y = self.owner.physics._body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y + Constants.TILE_SIZE, 0, 1))
            self:_bulletCooldown()
        end
    end
end

function PlayerInputComponent:_bulletCooldown()
    self._bullet = false
    Timer.add(0.5, function() self._bullet = true end)
end
