Colour = Class{}

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
        Signal.register(Signals.COLOR_INVERT, function()
            gameTimer:tween(2, self, {r = 255 - self._init.r, g = 255 - self._init.g, b = 255 - self._init.b})
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