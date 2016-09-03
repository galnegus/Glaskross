ChaserMovementComponent = Class{}
ChaserMovementComponent:include(MovementComponent)

function ChaserMovementComponent:init(targetEntity, terminalVelocity)
  assert(targetEntity, "arguments missing")
  MovementComponent.init(self, terminalVelocity, true)

  self._targetDirX, self._targetDirY = targetDirX, targetDirY
  self._velocity.x = self._targetDirX * self._bouncerVelocity
  self._velocity.y = self._targetDirY * self._bouncerVelocity
  self._direction.x = self._targetDirX
  self._direction.y = self._targetDirY
end

function ChaserMovementComponent:conception()
  self.owner.events:register(Signals.BOUNCE, function(dx, dy)
    assert(dx and dy, "dx or dy missing")
    if dx ~= 0 then
      self._direction.x = self._direction.x * -1
      self._velocity.x = self._velocity.x * -1
    end
    if dy ~= 0 then
      self._direction.y = self._direction.y * -1
      self._velocity.y = self._velocity.y * -1
    end

    self._bouncerVelocity = self._bouncerVelocity + self._step
    self._acceleration = self:calcAcceleration(self._bouncerVelocity, self._friction)

    if self._bouncerVelocity > self._splittingVelocity then
      local x, y = self.owner.body:bbox()

      local xDir1, yDir1 = self._direction.x, self._direction.y
      local xDir2 = dx ~= 0 and self._direction.x or -self._direction.x
      local yDir2 = dy ~= 0 and self._direction.y or -self._direction.y

      -- add xDir/yDir to starting position to avoid bouncer getting stuck inside wall (nasty memory crash)
      Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BOUNCER, x + xDir1, y + yDir1, xDir1, yDir1))
      Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.BOUNCER, x + xDir2, y + yDir2, xDir2, yDir2))
      Signal.emit(Signals.KILL_ENTITY, self.owner)
    end
  end)
  
  MovementComponent.conception(self)
end
