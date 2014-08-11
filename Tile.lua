Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height)
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "tile"
    self._body.parent = self
    Collider:setPassive(self._body)

    self.alpha = 0
    self._timerHandle = nil
end

function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:stepLightUp(r, g, b, freq, steps)
    -- cancel any already running timers so that they don't both tick
    if self.alpha ~= 0 and self._timerHandle ~= nil then
        Timer.cancel(self._timerHandle)
    end

    self.alpha = 255
    self.r = r
    self.g = g
    self.b = b

    self._timerHandle = Timer.addPeriodic(freq, function()
        local step = 255 / steps
        if self.alpha - step < 0 then
            step = self.alpha
        end
        self.alpha = self.alpha - step
    end, steps)
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