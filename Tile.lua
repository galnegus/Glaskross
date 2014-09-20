Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height, bgColour, bgColourRand)
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "tile"
    self._killer = false
    self._body.parent = self
    Collider:setPassive(self._body)
    Collider:addToGroup("tileGroup", self._body)

    -- flickering background color + rand(30)
    self._bgColour = bgColour
    self._bgColourRand = bgColourRand

    Signal.register(Signals.BACKGROUND_COLOR, function(r, g, b, a)
        assert(r and g and b and a, "set all arguments please")
        gameTimer:tween(5, self._bgColour, {r = r, g = g, b = b, a = a}, 'in-out-sine')
    end)

    -- _fg is used for entities stepping and stuff and so on (dynamic stuffs)
    self._fg = Colours.DEFAULT_STEP()
    self._fgStepHandle = nil

    -- _bg is used for environmental effects like the floor being a deathray
    self._bg = Colours.DEFAULT_BEAM()
    -- global timers cannot consistently be cancelled by other global timers 
    -- because of stupid programming, why this is needed
    self._bgCancellingTimer = Timer.new()

    self._source = nil

    -- true if areabeam is active
    self._beaming = false
end

function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:getFgAlpha()
    return self._fg.a
end

function Tile:step(freq, steps, colour)
    -- cancel any already running timers so that they don't both tick
    if self._fg.a ~= 0 and self._fgStepHandle ~= nil then
        gameTimer:cancel(self._fgStepHandle)
    end

    self._fg:set(colour.r or self._fg.r, colour.g or self._fg.g, colour.b or self._fg.b, 255)

    self._fgStepHandle = gameTimer:addPeriodic(freq, function()
        local step = 255 / steps
        if self._fg.a - step < 0 then
            step = self._fg.a
        end
        self._fg.a = self._fg.a - step
    end, steps)
end

function Tile:beam(duration)
    self._beaming = true

    self._bg.a = 0

    -- default duration is 1 sec
    duration = duration or 1

    -- color scramble
    local scramble = gameTimer:addPeriodic(0.1, function()
        local rMin, rMax = self._bg.r > 10 and -10 or -1 * self._bg.r, self._bg.r < 245 and 10 or (255 - self._bg.r)
        local gMin, gMax = self._bg.g > 10 and -10 or -1 * self._bg.g, self._bg.g < 245 and 10 or (255 - self._bg.g)
        local bMin, bMax = self._bg.b > 10 and -10 or -1 * self._bg.b, self._bg.b < 245 and 10 or (255 - self._bg.b)

        self._bg.r = (self._bg.r + love.math.random(rMin, rMax)) % 255
        self._bg.g = (self._bg.b + love.math.random(gMin, gMax)) % 255
        self._bg.g = (self._bg.b + love.math.random(bMin, bMax)) % 255
    end)

    -- fade in
    gameTimer:tween(2, self._bg, {a = 100}, "linear", function()
        self._killer = true
        self._bg.a = 255

        -- flashing effect
        local flasher = gameTimer:addPeriodic(0.1, function()
            if self._bg.a == 255 then
                self._bg.a = 60
                self._killer = false
            else
                self._bg.a = 255
                self._killer = true
            end
        end)
        
        -- turn it off when its done
        self._bgCancellingTimer:add(duration, function()
            gameTimer:cancel(scramble)
            gameTimer:cancel(flasher)
            
            self._beaming = false
            self._killer = false
            self._bg.a = 0
        end)
    end)
end

function Tile:update(dt)
    self._bgCancellingTimer:update(dt)
end

function Tile:draw()
    local x1, y1, x2, y2 = self._body:bbox()
    love.graphics.setColor(
        self._bgColour.r + love.math.random(self._bgColourRand.r), 
        self._bgColour.g + love.math.random(self._bgColourRand.g), 
        self._bgColour.b + love.math.random(self._bgColourRand.b), 
        self._bgColour.a)

    self._body:draw("fill")
    
    if self._bg.a ~= 0 then
        love.graphics.setColor(self._bg.r, self._bg.g, self._bg.b, self._bg.a / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self._bg.r, self._bg.g, self._bg.b, self._bg.a)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
    if self._fg.a ~= 0 then
        love.graphics.setColor(self._fg.r, self._fg.g, self._fg.b, self._fg.a / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self._fg.r, self._fg.g, self._fg.b, self._fg.a)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
end