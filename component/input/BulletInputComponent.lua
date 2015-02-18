BulletInputComponent = Class{}
BulletInputComponent:include(InputComponent)

function BulletInputComponent:init()
    InputComponent.init(self)

    self._bullet = true
end

function BulletInputComponent:update(dt)
    InputComponent.update(self, dt)

    if love.keyboard.isDown("left") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x - Constants.TILE_SIZE, y, -1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("up") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y - Constants.TILE_SIZE, 0, -1))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("right") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x + Constants.TILE_SIZE, y, 1, 0))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("down") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y + Constants.TILE_SIZE, 0, 1))
            self:_bulletCooldown()
        end
    end
end

function BulletInputComponent:_bulletCooldown()
    self._bullet = false
    if Constants.BULLET_COOLDOWN > 0 then
        game.timer:add(Constants.BULLET_COOLDOWN, function() self._bullet = true end)
    end
end
