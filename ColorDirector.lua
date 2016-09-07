local Class = require "lib.hump.class"
local ColorSchemes = require "constants.ColorSchemes"

local ColorDirector = Class{}

function ColorDirector:init()
  self.defaultScheme = ColorSchemes.defaultScheme

  -- initialize colors by copying their values from the default scheme
  self._colors = {}
  for colorName, colorTable in pairs(ColorSchemes.schemes[self.defaultScheme]) do
    self._colors[colorName] = {}
    for _, num in ipairs(colorTable) do
      table.insert(self._colors[colorName], num)
    end
  end

  -- register signal
end

function ColorDirector:get(color)
  return self._colors[color]
end

return ColorDirector
