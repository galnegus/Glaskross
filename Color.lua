local Class = require "lib.hump.Class"
local Constants = require "constants.Constants"
local Signals = require "constants.Signals"

local Color = Class{}

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
  local r, g, b = 1 - self._r, 1 - self._g, 1 - self._b
  colorFunc(self, r, g, b, duration)
end

local function mix(self, color, duration)
  color = color or self._init
  local r, g, b = (self._init.r + color:r()) / 2, (self._init.g + color:g()) / 2, (self._init.b + color:b()) / 2
  colorFunc(self, r, g, b, duration)
end

function Color:init(r, g, b, alpha, static)
  assert(r and g and b and alpha, "arguments missing")

  -- save the initial color, this is necessary for modifying colors
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
    --[[if Colors.state == Signals.COLOR_INVERT then
      invert(self, 0)
    elseif Colors.state == Signals.COLOR_MIX then
      mix(self, Colors.stateColor, 0)
    end]]

    Signal.register(Signals.COLOR_INVERT, function(duration)
      invert(self, duration)
    end)
    Signal.register(Signals.COLOR_MIX, function(color, duration)
      mix(self, color, duration)
    end)
  end
end

function Color:r() return self._r end
function Color:g() return self._g end
function Color:b() return self._b end

function Color:alpha()
  return self._alpha
end

function Color:unpack()
  return self.r, self.g, self.b
end

return Color
