BulletInputComponent = Class{}
BulletInputComponent:include(InputComponent)

function BulletInputComponent:init()
    InputComponent.init(self)

    self._bullet = true
end

function BulletInputComponent:conception()
    InputComponent.conception(self)

    self._velNormDenominator = self.owner.movement:getTerminalVelocity() * 2
end

function BulletInputComponent:update(dt)
    InputComponent.update(self, dt)

    -- Slight movement in the owner's direction, normalized to be a number between 0 and 1, (but really way less than 1, at 1 it will move diagonally when owner is moving at max speed orthogonally to the shoot direction)
    local xVel, yVel = self.owner.movement:getVelocity()
    xVel = xVel / self._velNormDenominator
    yVel = yVel / self._velNormDenominator

    if love.keyboard.isDown("left") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x - Constants.TILE_SIZE, y, -1, yVel))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("up") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y - Constants.TILE_SIZE, xVel, -1))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("right") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x + Constants.TILE_SIZE, y, 1, yVel))
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("down") then
        if self._bullet then
            local x, y = self.owner.body:center()
            Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BULLET, x, y + Constants.TILE_SIZE, xVel, 1))
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
