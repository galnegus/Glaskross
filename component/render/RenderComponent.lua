RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init(colour, border)
    Component.init(self)

    self.type = "render"

    self._colour = colour or Colours.DEFAULT_RENDER()

    self._border = border or false

    self._dying = false
    self._dyingStep = 0.25 / self._colour.a -- numerator = how many seconds of fade out
end

function RenderComponent:setOwner(owner)
    self.owner = owner

    if owner.physics == nil then
        error("Entity: " .. owner.tag .. " requires a physics component.")
    end
end

function RenderComponent:kill()
    self._dying = true
end

function RenderComponent:update(dt)
    if self._dying then
        self._colour.a = self._colour.a - dt / self._dyingStep

        if self._colour.a < 0 then
            self._colour.a = 0
            Component.kill(self)
        end
    end
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