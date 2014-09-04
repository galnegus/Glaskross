Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height)
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "tile"
    self._killer = false
    self._body.parent = self
    Collider:setPassive(self._body)

    -- _fg is used for entities stepping and stuff and so on (dynamic stuffs)
    self._fg = {}
    self._fg.alpha = 0
    self._fg.r = 200
    self._fg.g = 100
    self._fg.b = 200
    self._fg.stepHandle = nil

    -- _bg is used for environmental effects like the floor being a deathray
    self._bg = {}
    self._bg.alpha = 0
    self._bg.r = 200
    self._bg.g = 100
    self._bg.b = 200
    -- global timers cannot consistently be cancelled by other global timers 
    -- because of stupid programming, why this is needed
    self._bg.cancellingTimer = Timer.new()

    self._source = nil

    -- true if areabeam is active
    self._beaming = false
end

function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:getFgAlpha()
    return self._fg.alpha
end

function Tile:step(freq, steps, r, g, b)
    -- cancel any already running timers so that they don't both tick
    if self._fg.alpha ~= 0 and self._fg.stepHandle ~= nil then
        gameTimer:cancel(self._fg.stepHandle)
    end

    self._fg.alpha = 255
    self._fg.r = r or self._fg.r
    self._fg.g = g or self._fg.g
    self._fg.b = b or self._fg.b

    self._fg.stepHandle = gameTimer:addPeriodic(freq, function()
        local step = 255 / steps
        if self._fg.alpha - step < 0 then
            step = self._fg.alpha
        end
        self._fg.alpha = self._fg.alpha - step
    end, steps)
end

function Tile:beam(source, r, g, b, duration)
    self._source = source
    self._beaming = true

    self._bg.alpha = 0
    self._bg.r = r or self._bg.r
    self._bg.g = g or self._bg.g
    self._bg.b = b or self._bg.b

    -- default duration is 1 sec
    duration = duration or 1

    -- color scramble
    local scramble = gameTimer:addPeriodic(0.1, function()
        self._bg.r = (self._bg.r - 10 + 20 * math.random()) % 255
        self._bg.g = (self._bg.b - 10 + 20 * math.random()) % 255
        self._bg.g = (self._bg.b - 10 + 20 * math.random()) % 255
    end)

    -- fade in
    gameTimer:tween(1, self._bg, {alpha = 50}, "linear", function()
        self._killer = true
        self._bg.alpha = 255

        -- flashing effect
        local flasher = gameTimer:addPeriodic(0.1, function()
            if self._bg.alpha == 255 then
                self._bg.alpha = 60
                self._killer = false
            else
                self._bg.alpha = 255
                self._killer = true
            end
        end)
        
        -- turn it off when its done
        self._bg.cancellingTimer:add(duration, function()
            gameTimer:cancel(scramble)
            gameTimer:cancel(flasher)
            
            self._beaming = false
            self._killer = false
            self._bg.alpha = 0
        end)
    end)
end

function Tile:update(dt)
    self._bg.cancellingTimer:update(dt)
end

function Tile:draw()
    local x1, y1, x2, y2 = self._body:bbox()

    love.graphics.setColor(44 + love.math.random(30), 25 + love.math.random(30), 62 + love.math.random(30), 100)
    self._body:draw("fill")
    if self._bg.alpha ~= 0 then
        love.graphics.setColor(self._bg.r, self._bg.g, self._bg.b, self._bg.alpha / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self._bg.r, self._bg.g, self._bg.b, self._bg.alpha)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
    if self._fg.alpha ~= 0 then
        love.graphics.setColor(self._fg.r, self._fg.g, self._fg.b, self._fg.alpha / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self._fg.r, self._fg.g, self._fg.b, self._fg.alpha)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
end