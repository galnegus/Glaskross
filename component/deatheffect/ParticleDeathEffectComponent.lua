ParticleDeathEffectComponent = Class{}
ParticleDeathEffectComponent:include(Component)

function ParticleDeathEffectComponent:init(duration)
    assert(duration, "argument 'duration' missing.")

    self.type = ComponentTypes.DEATH_EFFECT

    --self._renderable = true

    self._dying = false
    self._duration = duration

    Component.init(self)
end

function ParticleDeathEffectComponent:conception()
    assert(self.owner.body ~= nil, "entity " .. tostring(self.owner) .. " must have a body component.")
    assert(self.owner.render ~= nil, "entity " .. tostring(self.owner) .. " must have a render component.")    

    self._deathParticleSystem = game.deathParticleSystem

    Component.conception(self)
end

function ParticleDeathEffectComponent:death()
    self._dying = true

    local x1, y1, x2, y2 = self.owner.body:bbox()
    local xSpread, ySpread = (x2 - x1) / 2, (y2 - y1) / 2
    local r, g, b, a = self.owner.render:colour()

    self._deathParticleSystem:setAreaSpread("uniform", xSpread, ySpread)
    self._deathParticleSystem:setParticleLifetime(self._duration)
    self._deathParticleSystem:setColors(r, g, b, 150, 255, 255, 255, 0)
    self._deathParticleSystem:setPosition(self.owner.body:center())
    --self._deathParticleSystem:start()
    self._deathParticleSystem:emit(25)
    
    game.timer.after(self._duration, function() Component.death(self) end)
end