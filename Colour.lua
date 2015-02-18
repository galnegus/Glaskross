Colour = Class{}

local function colorFunc(self, r, g, b, duration)
    duration = duration or Constants.BOXY_PHASE_TRANS_TIME
    assert(self and duration and r and g and b, "arguments missing... \nduration: " .. tostring(duration) .. ", r: " .. r .. ", g: " .. g .. ", b: " .. b) 
    if duration == 0 then
        self._r = r
        self._g = g
        self._b = b
    else
        game.timer:tween(duration, self, {_r = r, _g = g, _b = b}, 'in-out-sine')
    end
end

local function invert(self, duration)
    local r, g, b = 255 - self._r, 255 - self._g, 255 - self._b
    colorFunc(self, r, g, b, duration)
end

local function mix(self, colour, duration)
    colour = colour or self._init
    local r, g, b = (self._init.r + colour:r()) / 2, (self._init.g + colour:g()) / 2, (self._init.b + colour:b()) / 2
    colorFunc(self, r, g, b, duration)
end

function Colour:init(r, g, b, alpha, static)
    assert(r and g and b and alpha, "arguments missing")

    -- save the initial colour, this is necessary for modifying colours
    self._init = {
        r = r,
        g = g,
        b = b
    }

    -- DO NOT REFERENCE DIRECTLY! shit will break.
    self._r = r
    self._g = g
    self._b = b

    -- DO NOT REFERENCE DIRECTLY! If alpha needs to change (tweens yo), copy the value with alpha() and use a new variable instead
    self._alpha = alpha

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

function Colour:r() return self._r end
function Colour:g() return self._g end
function Colour:b() return self._b end

function Colour:alpha()
    return self._alpha
end

function Colour:unpack()
    return self.r, self.g, self.b
end