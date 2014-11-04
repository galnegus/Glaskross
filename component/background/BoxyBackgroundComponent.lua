BoxyBackgroundComponent = Class{}
BoxyBackgroundComponent:include(Component)

local hoverLimit = Constants.TILE_SIZE / 3
local hoverVelocity = Constants.TILE_SIZE

-- at the very lowest possible hover velocity in the interpolation thingy,
-- the velocity will be this factor of the hoverVelocity variable
local minVelFactor = 0.1

function BoxyBackgroundComponent:init()
    Component.init(self)

    self.type = ComponentTypes.BACKGROUND

    self._boxWidth = Constants.TILE_SIZE * 12
    self._boxHeight = Constants.TILE_SIZE * 9

    self._x = (love.graphics.getWidth() - self._boxWidth) / 2
    self._y = (love.graphics.getHeight() - self._boxHeight) / 2

    self._boxes = {}

    -- the first box [1] is the box that is in the back, [2] is in the middle, [3] in front.
    self._boxes[1] = BoxyBox(Constants.TILE_SIZE * 2, -Constants.TILE_SIZE * 2, Colours.BOXY_LAYER_ONE(), hoverLimit * 0.6, hoverLimit * 0.4) -- 6, 4
    self._boxes[2] = BoxyBox(Constants.TILE_SIZE, -Constants.TILE_SIZE, Colours.BOXY_LAYER_TWO(), hoverLimit * 0.8, hoverLimit * 0.2) -- 8. 2
    self._boxes[3] = BoxyBox(0, 0, Colours.BOXY_LAYER_THREE(), hoverLimit, 0) -- 10, 0

    self._boxes[#self._boxes].colour.a = 255
    Signal.emit(Signals.COLOUR_MIX, self._boxes[#self._boxes].colour, 0)
    
    Signal.register(Signals.BOXY_NEXT_PHASE, function()
        if #self._boxes > 0 then
            gameTimer:tween(Constants.BOXY_PHASE_TRANS_TIME, self._boxes[#self._boxes].colour, {a = 0}, 'in-out-sine', function()
                table.remove(self._boxes)
            end)
        end
        if #self._boxes > 1 then
            gameTimer:tween(Constants.BOXY_PHASE_TRANS_TIME, self._boxes[#self._boxes - 1].colour, {a = 255}, 'in-out-sine')
            for i = #self._boxes - 1, 1, -1 do
                local offset = (#self._boxes - 1) * Constants.TILE_SIZE - i * Constants.TILE_SIZE
                gameTimer:tween(Constants.BOXY_PHASE_TRANS_TIME, self._boxes[i], {xOffset = offset, yOffset = -offset}, 'in-out-sine')
            end
            Signal.emit(Signals.COLOUR_MIX, self._boxes[#self._boxes - 1].colour)
        end
    end)
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
        xSmooth = 1 - (1 - xSmooth) ^ 3
        ySmooth = 1 - (1 - ySmooth) ^ 3

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
    for i, box in ipairs(self._boxes) do
        local x = self._x + box.xOffset + box.xHover
        local y = self._y + box.yOffset + box.yHover
        love.graphics.setColor(box.colour.r, box.colour.g, box.colour.b, box.colour.a / 10)
        love.graphics.rectangle("fill", x, y, self._boxWidth, self._boxHeight)
        love.graphics.setColor(box.colour.r, box.colour.g, box.colour.b, box.colour.a)
        love.graphics.rectangle("line", x + 0.5, y + 0.5, self._boxWidth, self._boxHeight)
    end
end