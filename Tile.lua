Tile = Class{}
Tile:include(Shape)

function Tile:init(x, y, width, height)
    self._x = x
    self._y = y
    self._width = width
    self._height = height

    --[[
    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = BodyTypes.TILE
    self._killer = false
    self._body.parent = self
    Collider:setPassive(self._body)
    Collider:addToGroup(ColliderGroups.HOSTILE, self._body)
    
    -- _bg is used for environmental effects like the floor being a deathray
    self._bg = Colours.DEFAULT_BEAM
    self._bgAlpha = Colours.DEFAULT_BEAM:alpha()
    self._bgRand = {r = 0, g = 0, b = 0}
    -- global timers cannot consistently be cancelled by other global timers 
    -- because of stupid programming, why this is needed
    self._bgCancellingTimer = Timer.new()

    self._source = nil

    -- true if areabeam is active
    self._beaming = false
    ]]
end
--[[
function Tile:on_collide(dt, shapeCollidedWith, dx, dy)
    --
end

function Tile:beam(duration)
    self._beaming = true

    self._bgAlpha = 0

    -- default duration is 1 sec
    duration = duration or 1

    -- color scramble
    local scramble = game.timer:addPeriodic(0.1, function()
        local rMin, rMax = self._bg:r() > 50 and -50 or -1 * self._bg:r(), self._bg:r() < 205 and 50 or (255 - self._bg:r())
        local gMin, gMax = self._bg:g() > 50 and -50 or -1 * self._bg:g(), self._bg:g() < 205 and 50 or (255 - self._bg:g())
        local bMin, bMax = self._bg:b() > 50 and -50 or -1 * self._bg:b(), self._bg:b() < 205 and 50 or (255 - self._bg:b())

        self._bgRand.r = (self._bg:r() + love.math.random(rMin, rMax)) % 255
        self._bgRand.g = (self._bg:b() + love.math.random(gMin, gMax)) % 255
        self._bgRand.g = (self._bg:b() + love.math.random(bMin, bMax)) % 255
    end)

    -- fade in
    game.timer:tween(2, self, {_bgAlpha = 100}, 'linear', function()
        self._killer = true
        self._bgAlpha = 255

        -- flashing effect
        local flasher = game.timer:addPeriodic(0.1, function()
            if self._bgAlpha == 255 then
                self._bgAlpha = 60
                self._killer = false
            else
                self._bgAlpha = 255
                self._killer = true
            end
        end)
        
        -- turn it off when its done
        self._bgCancellingTimer:add(duration, function()
            game.timer:cancel(scramble)
            game.timer:cancel(flasher)
            
            self._beaming = false
            self._killer = false
            self._bgAlpha = 0
        end)
    end)
end
]]
function Tile:update(dt)
    --[[
    self._bgCancellingTimer:update(dt)
    ]]
end

function Tile:draw()
    love.graphics.setColor(
        Colours.BG_COLOUR:r() + love.math.random(Colours.BG_COLOUR_RAND:r()), 
        Colours.BG_COLOUR:g() + love.math.random(Colours.BG_COLOUR_RAND:g()), 
        Colours.BG_COLOUR:b() + love.math.random(Colours.BG_COLOUR_RAND:b()), 
        Colours.BG_COLOUR:alpha())
    love.graphics.rectangle("fill", self._x, self._y, self._width, self._height)
    
    --[[
    local x1, y1, x2, y2 = self._body:bbox()
    if self._bgAlpha ~= 0 then
        love.graphics.setColor(self._bgRand.r, self._bgRand.g, self._bgRand.b, self._bgAlpha / 10)
        love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
        love.graphics.setColor(self._bgRand.r, self._bgRand.g, self._bgRand.b, self._bgAlpha)
        love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
    end
    ]]
end