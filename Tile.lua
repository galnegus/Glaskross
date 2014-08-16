Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height)
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "tile"
    self._body.killer = false
    self._body.parent = self
    Collider:setPassive(self._body)

    self._alpha = 0
    self._source = nil
    self._timerHandle = nil

    self.r = 125
    self.r = 125
    self.r = 200

    -- global timers cannot be cancelled by other global timers 
    -- because of stupid programming, why this is needed
    self.cancellingTimer = Timer.new()
end

function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:stepLightUp(source, freq, steps, r, g, b)
    self._source = source

    -- cancel any already running timers so that they don't both tick
    if self._alpha ~= 0 and self._timerHandle ~= nil then
        Timer.cancel(self._timerHandle)
    end

    self._alpha = 255
    self.r = r or self.r
    self.g = g or self.g
    self.b = b or self.b

    self._timerHandle = Timer.addPeriodic(freq, function()
        local step = 255 / steps
        if self._alpha - step < 0 then
            step = self._alpha
        end
        self._alpha = self._alpha - step
    end, steps)
end

function Tile:areaBeam(source, r, g, b)
    -- reset tile just in case
    if self._alpha ~= 0 and self._timerHandle ~= nil then
        Timer.cancel(self._timerHandle)
    end
    self._source = source

    self._alpha = 0
    self.r = r
    self.g = g
    self.b = b

    -- color scramble
    -- 
    local scramble = Timer.addPeriodic(0.1, function()
        self.r = (self.r - 10 + 20 * math.random()) % 255
        self.g = (self.b - 10 + 20 * math.random()) % 255
        self.g = (self.b - 10 + 20 * math.random()) % 255


    end)

    -- fade in
    Timer.tween(1, self, {_alpha = 20}, "linear", function()
        self._body.killer = true
        self._alpha = 255

        -- flashing effect
        local flasher = Timer.addPeriodic(0.1, function()
            if self._alpha == 255 then
                self._alpha = 20
            else
                self._alpha = 255
            end
        end)
        
        -- turn it off when its done
        self.cancellingTimer:add(1, function()
            Timer.cancel(scramble)
            Timer.cancel(flasher)
            
            self._body.killer = false
            self._alpha = 0
        end)
    end)
end

function Tile:update(dt)
    self.cancellingTimer:update(dt)
end

function Tile:draw()
    local x1, y1, x2, y2 = self._body:bbox()

    love.graphics.setColor(88 + math.random() * 30, 51 + math.random() * 30, 125 + math.random() * 30, 100)
    self._body:draw("fill")
    if self._alpha ~= 0 then
        love.graphics.setColor(self.r, self.g, self.b, self._alpha / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self.r, self.g, self.b, self._alpha)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
end