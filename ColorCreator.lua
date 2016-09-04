local ColorSchemes = require "constants.ColorSchemes"

ColorCreator = Class{}

function ColorCreator:init()
  self.defaultScheme = ColorSchemes.defaultScheme

  -- initialize colors by copying their values from the default scheme
  self._colors = {}
  for colorName, colorTable in pairs(ColorSchemes[self.defaultScheme]) do
    self._colorSchemes[colorName] = {}
    for i, num in ipairs(colorTable) do
      table.insert(self._colorScheme[colorName], num)
    end
  end
end