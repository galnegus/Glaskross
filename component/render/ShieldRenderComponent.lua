ShieldRenderComponent = Class{}
ShieldRenderComponent:include(RenderComponent)

function ShieldRenderComponent:init(color, birthDuration, deathDuration, radius)
  RenderComponent.init(self, color, 0, deathDuration, false)

  self._radius = radius

  self._active = false
  self._xOffset = 0
  self._yOffset = 0

  self._alphaAnimate = 1
end

function ShieldRenderComponent:setOwner(owner)
  RenderComponent.setOwner(self, owner)

  self.owner.events:register(Signals.SHIELD_ACTIVE, function(dirX, dirY, duration)
    assert((dirX == 0 and dirY == -1) or (dirX == 0 and dirY == 1) or 
           (dirX == -1 and dirY == 0) or (dirX == 1 and dirY == 0), 
          "Invalid values of 'dirX' and 'dirY' parameters, must be orthogonal")
    self._xOffset = dirX * Constants.TILE_SIZE
    self._yOffset = dirY * Constants.TILE_SIZE

    self._active = true

    self._alphaAnimate = 1
    game.timer:tween(duration, self, {_alphaAnimate = 0}, 'out-bounce')
  end)

  self.owner.events:register(Signals.SHIELD_INACTIVE, function()
    self._active = false
    --print("Då")
  end)
end

function ShieldRenderComponent:draw()
  if self._active then
    local x, y = self.owner.body:center()

    love.graphics.setColor(255, 0, 0, 50)
    --self.owner.body:draw()

    love.graphics.push()
      -- set origin of coordinate system to center of rectangle
      love.graphics.translate(x, y)
      love.graphics.rotate(self.owner.body:getVelRotation())

      local x, y = 0, 0
      -- fuck this is annoying
      local vertices = {x - self._yOffset, y - self._xOffset, 
                x + self._xOffset, y + self._yOffset, 
                x + self._yOffset, y + self._xOffset, 
                x + self._xOffset - 1, y + self._yOffset}
      love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), self._alpha * self._alphaAnimate)
      love.graphics.polygon("line", vertices)

      for i = 1,2 do
        x, y = x - self._xOffset / 6, y - self._yOffset / 6
        vertices = {x - self._yOffset, y - self._xOffset, 
                    x + self._xOffset, y + self._yOffset, 
                    x + self._yOffset, y + self._xOffset, 
                    x + self._xOffset - 1, y + self._yOffset}
        love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), (self._alpha * (1 - i * 0.33)) * self._alphaAnimate)
        love.graphics.polygon("line", vertices)
      end
    love.graphics.pop()
  end
end