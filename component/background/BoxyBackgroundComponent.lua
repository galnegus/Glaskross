BoxyBackgroundComponent = Class{}
BoxyBackgroundComponent:include(Component)

local hoverLimit = 10
local hoverVelocity = 30

-- at the very lowest possible hover velocity in the interpolation thingy,
-- the velocity will be this factor of the hoverVelocity variable
local minVelFactor = 0.1

function BoxyBackgroundComponent:init()
    Component.init(self)

    self.type = "background"

    self._boxWidth = 384
    self._boxHeight = 288

    self._x = (love.graphics.getWidth() - self._boxWidth) / 2
    self._y = (love.graphics.getHeight() - self._boxHeight) / 2

    self._boxes = {}

    -- the first box [1] is the box that is in the back, [2] is in the middle, [3] in front.
    self._boxes[1] = BoxyBox(32, -32, Colours.BOXY_LAYER_ONE(), hoverLimit * 0.6, hoverLimit * 0.4) -- 6, 4
    self._boxes[2] = BoxyBox(0, 0, Colours.BOXY_LAYER_TWO(), hoverLimit * 0.8, hoverLimit * 0.2) -- 8. 2
    self._boxes[3] = BoxyBox(-32, 32, Colours.BOXY_LAYER_THREE(), hoverLimit, 0) -- 10, 0

    Signal.register(Signals.BOXY_NEXT_PHASE, function()
        if #self._boxes > 0 then
            gameTimer:tween(1, self._boxes[#self._boxes].colour, {a = 0}, 'in-out-sine', function()
                table.remove(self._boxes)
            end)
            
        end
    end)
end

function BoxyBackgroundComponent:setOwner(owner)
    self.owner = owner
end

-- make the boxes float around a bit
function BoxyBackgroundComponent:update(dt)
    for _, box in ipairs(self._boxes) do
        -- Get a value [minVelFactor, 1] that represents distance from box center to hoverLimit, 
        -- xSmooth/ySmooth == 1 if xHover/yHover == 0,
        -- xSmooth/ySmooth == minVelFactor if xHover/yHover == abs(hoverLimit),
        -- values inbetween are distributed linearly.
        -- This is used for the interpolation thingy below
        local xSmooth = (math.abs(hoverLimit) - math.abs(box.xHover)) / (hoverLimit / (1 - minVelFactor)) + minVelFactor
        local ySmooth = (math.abs(hoverLimit) - math.abs(box.yHover)) / (hoverLimit / (1 - minVelFactor)) + minVelFactor

        -- doing some interpolation thingy, "inverted" square
        -- http://sol.gfxile.net/interpolation/#c5
        xSmooth = 1 - (1 - xSmooth) ^ 2
        ySmooth = 1 - (1 - ySmooth) ^ 2

        box.xHover = box.xHover + box.xHoverDir * hoverVelocity * xSmooth * dt
        box.yHover = box.yHover + box.yHoverDir * hoverVelocity * ySmooth * dt

        -- do some randomizing so that they don't all act all uniformly
        --box.xHover = box.xHover + dt * box.xHoverDir * love.math.random(hoverLimit)
        --box.yHover = box.yHover + dt * box.yHoverDir * love.math.random(hoverLimit)

        -- change direciton if limit is hit
        if math.abs(box.xHover) > hoverLimit then
            box.xHover = hoverLimit * box.xHoverDir
            box.xHoverDir = box.xHoverDir * -1
        end
        if math.abs(box.yHover) > hoverLimit then
            box.yHover = hoverLimit * box.yHoverDir
            box.yHoverDir = box.yHoverDir * -1
        end
    end    
end

function BoxyBackgroundComponent:bgDraw()
    for _, box in ipairs(self._boxes) do
        local x = self._x + box.xOffset + box.xHover
        local y = self._y + box.yOffset + box.yHover
        love.graphics.setColor(box.colour.r, box.colour.g, box.colour.b, box.colour.a / 10)
        love.graphics.rectangle("fill", x, y, self._boxWidth, self._boxHeight)
        love.graphics.setColor(box.colour.r, box.colour.g, box.colour.b, box.colour.a)
        love.graphics.rectangle("line", x + 0.5, y + 0.5, self._boxWidth, self._boxHeight)
    end
end