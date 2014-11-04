ParticleDeathEffect = Class{}
ParticleDeathEffect:include(Component)

function ParticleDeathEffect:init(duration)
    assert(duration, "argument 'duration' missing.")
    Component.init(self)

    self.type = ComponentTypes.DEATH_EFFECT

    self._renderable = true

    self._dying = false
    self._duration = duration
end

function ParticleDeathEffect:death()
    assert(self.owner.physics ~= nil, "entity " .. tostring(self.owner) .. " must have a physics component.")
    assert(self.owner.render ~= nil, "entity " .. tostring(self.owner) .. " must have a render component.")

    self._dying = true

    local x1, y1, x2, y2 = self.owner.physics:bbox()
    local xSpread, ySpread = (x2 - x1) / 2, (y2 - y1) / 2
    local r, g, b, a = self.owner.render:colour()

    self._deathParticleSystem = love.graphics.newParticleSystem(love.graphics.newImage("square.png"), 25)
    self._deathParticleSystem:setAreaSpread("uniform", xSpread, ySpread)
    self._deathParticleSystem:setEmitterLifetime(0)
    self._deathParticleSystem:setParticleLifetime(self._duration)
    self._deathParticleSystem:setPosition(self.owner.physics:center())
    self._deathParticleSystem:setSizes(1)
    self._deathParticleSystem:setSpeed(Constants.TERMINAL_VELOCITY / 10, Constants.TERMINAL_VELOCITY / 5)
    self._deathParticleSystem:setLinearAcceleration(0, 0, 0, -1000)
    self._deathParticleSystem:setSpread(2 * math.pi)
    self._deathParticleSystem:setColors(r, g, b, 100, 255, 255, 255, 0)
    self._deathParticleSystem:emit(25)
    gameTimer:add(self._duration, function() self._deathParticleSystem:stop(); Component.death(self) end)
end

function ParticleDeathEffect:update(dt)
    if self._dying then
        self._deathParticleSystem:update(dt)
    end
end

function ParticleDeathEffect:draw()
    if self._dying then
        love.graphics.draw(self._deathParticleSystem)
    end
end