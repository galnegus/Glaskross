ShieldRenderComponent = Class{}
ShieldRenderComponent:include(RenderComponent)

function ShieldRenderComponent:init(colour, birthDuration, deathDuration, radius)
    RenderComponent.init(self, colour, 0, deathDuration, false)

    self._x = 0
    self._y = 0
    self._radius = radius

    self._active = false
end

function ShieldRenderComponent:setOwner(owner)
    RenderComponent.setOwner(self, owner)

    self.owner.events:register(Signals.SHIELD_ACTIVE, function(x, y)
        self._active = true
        --print("Hej")
    end)

    self.owner.events:register(Signals.SHIELD_INACTIVE, function()
        self._active = false
        --print("Då")
    end)
end

function ShieldRenderComponent:update(dt)
    RenderComponent.update(self, dt)

    local x, y = self.owner.physics:center()

    self._x = x
    self._y = y
end

function ShieldRenderComponent:draw()
    if self._active then
        love.graphics.setColor(self._colour.r, self._colour.g, self._colour.b, self._colour.a)
        love.graphics.circle("line", self._x, self._y, self._radius, 5)
    end
end