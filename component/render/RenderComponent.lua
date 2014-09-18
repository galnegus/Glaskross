RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init(r, g, b, a)
    Component.init(self)

    self.type = "render"

    self._r = r or 255
    self._g = g or 255
    self._b = b or 255
    self._a = a or 100

    self._dying = false
    self._dyingStep = 0.25 / self._a -- numerator = how many seconds of fade out
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
        self._a = self._a - dt / self._dyingStep

        if self._a < 0 then
            self._a = 0
            Component.kill(self)
        end
    end
end

function RenderComponent:draw()
    local x1, y1, x2, y2 = self.owner.physics:bbox()

    love.graphics.setColor(self._r, self._g, self._b, self._a)
    love.graphics.rectangle("fill", x1, y1, x2 - x1, y2 - y1)
end