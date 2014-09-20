Colour = Class{}

local function colorFunc(self, r, g, b, duration)
    duration = duration or Constants.BOXY_PHASE_TRANS_TIME
    assert(self and duration and r and g and b, "arguments missing... \nduration: " .. tostring(duration) .. ", r: " .. r .. ", g: " .. g .. ", b: " .. b) 
    if duration == 0 then
        self.r = r
        self.g = g
        self.b = b
    else
        gameTimer:tween(duration, self, {r = r, g = g, b = b}, 'in-out-sine')
    end
end

local function invert(self, duration)
    local r, g, b = 255 - self.r, 255 - self.g, 255 - self.b
    colorFunc(self, r, g, b, duration)
end

local function mix(self, colour, duration)
    colour = colour or self._init
    local r, g, b = (self._init.r + colour.r) / 2, (self._init.g + colour.g) / 2, (self._init.b + colour.b) / 2
    colorFunc(self, r, g, b, duration)
end

function Colour:init(r, g, b, a, static)
    assert(r and g and b and a, "arguments missing")

    -- save the initial colour, this is necessary for modifying colours
    self._init = {
        r = r,
        g = g,
        b = b,
        a = a
    }

    self.r = r
    self.g = g
    self.b = b
    self.a = a

    if not static then
        if Colours.state == Signals.COLOUR_INVERT then
            invert(self, 0)
        elseif Colours.state == Signals.COLOUR_MIX then
            mix(self, Colours.stateColour, 0)
        end

        Signal.register(Signals.COLOUR_INVERT, function(duration)
            invert(self, duration)
        end)
        Signal.register(Signals.COLOUR_MIX, function(colour, duration)
            mix(self, colour, duration)
        end)
    end
end

function Colour:set(r, g, b, a)
    assert(r and g and b and a, "arguments missing")
    self.r = r
    self.g = g
    self.b = b
    self.a = a
end

function Colour:unpack()
    return r, g, b, a
end