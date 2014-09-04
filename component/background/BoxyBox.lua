BoxyBox = Class{}

function BoxyBox:init(xOffset, yOffset, r, g, b, a)
    self.xOffset = xOffset
    self.yOffset = yOffset

    -- color of box
    self.r = r
    self.g = g
    self.b = b
    self.a = a

    -- variation in position (hovering effect)
    self.xHover = 50
    self.yHover = 0

    -- must be either 1 or -1 (because it's a fucking direction)
    self.xHoverDir = 1
    self.yHoverDir = 1

    -- velocity
    self.xVelocity = 1
    self.yVelocity = 1
end