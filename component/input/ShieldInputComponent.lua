ShieldInputComponent = Class{}
ShieldInputComponent:include(InputComponent)

function ShieldInputComponent:init()
    InputComponent.init(self)

    self._bullet = true
end

function ShieldInputComponent:setOwner(owner)
    InputComponent.setOwner(self, owner)

    assert(owner.physics ~= nil, "entity must have physics component before adding shield input component, fix!")

    self._shield = EntityCreator.create(EntityTypes.SHIELD, self.owner)
    Signal.emit(Signals.ADD_ENTITY, self._shield)
end

function ShieldInputComponent:update(dt)
    InputComponent.update(self, dt)

    if love.keyboard.isDown("left") then
        if self._bullet then
            self._shield.events:emit(Signals.SHIELD_ACTIVE, -1, 0)
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("up") then
        if self._bullet then
            self._shield.events:emit(Signals.SHIELD_ACTIVE, 0, -1)
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("right") then
        if self._bullet then
            self._shield.events:emit(Signals.SHIELD_ACTIVE, 1, 0)
            self:_bulletCooldown()
        end
    end
    if love.keyboard.isDown("down") then
        if self._bullet then
            self._shield.events:emit(Signals.SHIELD_ACTIVE, 0, 1)
            self:_bulletCooldown()
        end
    end
end

function ShieldInputComponent:_bulletCooldown()
    self._bullet = false
    if Constants.BULLET_COOLDOWN > 0 then
        Timer.add(1, function() 
            self._shield.events:emit(Signals.SHIELD_INACTIVE)
            Timer.add(0.5, function()
                self._bullet = true
            end)
        end)
    end
end
