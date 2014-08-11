Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height)
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "tile"
    self._body.parent = self
    Collider:setPassive(self._body)

    self.alpha = 0
end

function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:stepLightUp(r, g, b)
    self.alpha = 255
    self.r = r
    self.g = g
    self.b = b

    local nSteps = 10
    Timer.addPeriodic(0.05, function()
        local step = 255 / nSteps
        if self.alpha - step < 0 then
            step = self.alpha
        end
        self.alpha = self.alpha - step
    end, nSteps)
end

function Tile:draw()
    love.graphics.setColor(88 + math.random() * 30, 51 + math.random() * 30, 125 + math.random() * 30, 100)
    self._body:draw("fill")
    if self.alpha ~= 0 then
        love.graphics.setColor(self.r, self.g, self.b, self.alpha)
        local x1, y1, x2, y2 = self._body:bbox()
        love.graphics.rectangle("fill", x1, y1, x2 - x1, y2 - y1)
    end
end