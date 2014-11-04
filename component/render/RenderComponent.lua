RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init(colour, birthDuration, deathDuration, border)
    assert(colour and birthDuration and deathDuration and border ~= nil, "arguments missing")
    Component.init(self)

    self.type = ComponentTypes.RENDER

    self._renderable = true

    self._colour = colour or Colours.DEFAULT_RENDER()

    self._border = border
    self._birthDuration = birthDuration
    self._deathDuration = deathDuration
    self._dying = false
    self._dead = false
end

function RenderComponent:setOwner(owner)
    self.owner = owner

    if owner.physics == nil then
        error("Entity: " .. owner.tag .. " requires a physics component.")
    end
end

function RenderComponent:colour()
    return self._colour:unpack()
end

function RenderComponent:conception()
    if self._birthDuration > 0 then
        local alpha = self._colour.a
        self._colour.a = 0
        gameTimer:tween(self._birthDuration, self._colour, {a = alpha}, 'in-out-sine', function()
            Component.conception(self)
        end)
    else
        Component.conception(self)
    end
end

function RenderComponent:death()
    self._dying = true

    gameTimer:tween(self._deathDuration, self._colour, {a = 0}, 'in-out-sine', function() Component.death(self) end)

    
end

function RenderComponent:draw()
    local x1, y1, x2, y2 = self.owner.physics:bbox()

    local alpha = self._colour.a

    if self._border then
        alpha = alpha / 10
    end

    love.graphics.setColor(self._colour.r, self._colour.g, self._colour.b, alpha)
    love.graphics.rectangle("fill", x1, y1, x2 - x1, y2 - y1)

    if self._border then
        love.graphics.setColor(self._colour.r, self._colour.g, self._colour.b, self._colour.a)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
end