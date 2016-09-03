ShieldBodyComponent = Class{}
ShieldBodyComponent:include(BodyComponent)

function ShieldBodyComponent:init(options)
  assert(options.masterEntity ~= nil, "options.masterEntity is required.")
  assert(options.masterEntity.body ~= nil, "master entity must have body component.")
  self._x, self._y = options.masterEntity.body:center()

  -- create triangle body in the appearance of a shield

  self._masterEntity = options.masterEntity
  self._active = false

  self._xOffset = 0
  self._yOffset = 0
  self._xAnimateOffset = 0
  self._yAnimateOffset = 0

  self._velRotation = 0

  BodyComponent.init(self, options)
end

function ShieldBodyComponent:conception()
  self.owner.events:register(Signals.SHIELD_ACTIVE, function(dirX, dirY, duration)
    assert((dirX == 0 and dirY == -1) or (dirX == 0 and dirY == 1) or 
         (dirX == -1 and dirY == 0) or (dirX == 1 and dirY == 0), 
        "Invalid values of 'dirX' and 'dirY' parameters, must be orthogonal")

    -- rotate the triangle body to face the correct side, also tilt it slightly according to master velocity
    local vx, vy = 0, 0
    if self._masterEntity.movement ~= nil then
      vx, vy = self._masterEntity.movement:getVelocity()
    end  

    -- make the velocity vector smaller than the direction vector to keep the effect subtle
    vx, vy = vx / (3 * Constants.TERMINAL_VELOCITY), vy / (3 * Constants.TERMINAL_VELOCITY)

    -- alter position according to direction and velocity vector
    self._xOffset = dirX * Constants.TILE_SIZE + vx * 100
    self._yOffset = dirY * Constants.TILE_SIZE + vy * 100

    -- rotate collision shape
    self._shape:setRotation(math.atan2(dirX + vx, -dirY - vy))

    -- difference between default rotation and the velocity rotation, needed for ShieldRenderComponent to also rotate the rendering stuff
    self._velRotation = self._shape:rotation() - math.atan2(dirX, -dirY)

    self._xAnimateOffset = -self._xOffset / 2
    self._yAnimateOffset = -self._yOffset / 2
    game.timer:tween(duration, self, {_xAnimateOffset = self._xAnimateOffset + dirX * Constants.TILE_SIZE, _yAnimateOffset = self._yAnimateOffset + dirY * Constants.TILE_SIZE}, 'out-sine')

    self._shape.active = true
    --Collider:setSolid(self._shape)
  end)

  self.owner.events:register(Signals.SHIELD_INACTIVE, function()
    if self._alive then
      self._shape.active = false
      --Collider:setGhost(self._shape)
    end
  end)

  BodyComponent.conception(self)
end

function ShieldBodyComponent:birth()
  BodyComponent.birth(self)
  self._shape.active = false
  --Collider:setGhost(self._shape)
end

function ShieldBodyComponent:getVelRotation()
  return self._velRotation
end

function ShieldBodyComponent:update(dt)
  if self._shape.active then
    self._x, self._y = self._masterEntity.body:center()

    self._shape:moveTo(self._x + self._xOffset + self._xAnimateOffset, self._y + self._yOffset + self._yAnimateOffset)
  end

  BodyComponent.update(self, dt)
end
