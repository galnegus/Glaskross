local Class = require "lib.hump.Class"

local BoxyBox = Class{}

function BoxyBox:init(xOffset, yOffset, color, xHover, yHover)
  self.xOffset = xOffset
  self.yOffset = yOffset

  -- color of box
  self.color = color
  self.alpha = color:alpha()

  -- variation in position (hovering effect)
  self.xHover = xHover or 0
  self.yHover = yHover or 0

  -- must be either 1 or -1 (because it's a fucking direction)
  self.xHoverDir = -1
  self.yHoverDir = 1
end

return BoxyBox
