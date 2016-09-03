ShieldInputComponent = Class{}
ShieldInputComponent:include(InputComponent)

function ShieldInputComponent:init()
  self._bullet = true

  self._shieldDuration = 0.5
  self._shieldCooldown = 0

  InputComponent.init(self)
end

function ShieldInputComponent:setOwner(owner)
  InputComponent.setOwner(self, owner)
  assert(owner.body ~= nil, "entity must have body component before adding shield input component, fix!")

  self._shield = EntityCreator.create(EntityTypes.SHIELD, self.owner)
  Signal.emit(Signals.ADD_ENTITY, self._shield)

end

-- clean up after yourself, kill the shield entity when this one dies
function ShieldInputComponent:death()
  Signal.emit(Signals.KILL_ENTITY, self._shield)

  Component.death(self)
end

local function cooldown(self)
  self._bullet = false
  game.timer:after(self._shieldDuration, function() 
    self._shield.events:emit(Signals.SHIELD_INACTIVE)
    if Constants.BULLET_COOLDOWN > 0 then
      game.timer:after(self._shieldCooldown, function()
        self._bullet = true
      end)
    else
      self._bullet = true
    end
  end)
end

function ShieldInputComponent:update(dt)
  if love.keyboard.isDown("left") then
    if self._bullet then
      self._shield.events:emit(Signals.SHIELD_ACTIVE, -1, 0, self._shieldDuration)
      cooldown(self)
    end
  end
  if love.keyboard.isDown("up") then
    if self._bullet then
      self._shield.events:emit(Signals.SHIELD_ACTIVE, 0, -1, self._shieldDuration)
      cooldown(self)
    end
  end
  if love.keyboard.isDown("right") then
    if self._bullet then
      self._shield.events:emit(Signals.SHIELD_ACTIVE, 1, 0, self._shieldDuration)
      cooldown(self)
    end
  end
  if love.keyboard.isDown("down") then
    if self._bullet then
      self._shield.events:emit(Signals.SHIELD_ACTIVE, 0, 1, self._shieldDuration)
      cooldown(self)
    end
  end

  InputComponent.update(self, dt)
end
