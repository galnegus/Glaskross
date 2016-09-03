TargettedMovementComponent = Class{}
TargettedMovementComponent:include(MovementComponent)

function TargettedMovementComponent:init(terminalVelocity)
  MovementComponent.init(self, terminalVelocity, true)
  self._oldPosition = Vector(0, 0)
  self._tweenHandler = nil
end

function TargettedMovementComponent:moveTo(x, y)
  if self._tweenHandler then
    Timer.cancel(self._tweenHandler)
  end

  local duration = 0.3
  local position = Vector(self.owner.body:center())
  local diff = Vector(x - position.x, y - position.y)
  local counter = 0.0
  local tween = 0
  self._tweenHandler = Timer.during(duration, function(dt)
    counter = counter + dt
    tween = Timer.tween.out(Timer.tween.quad)(counter / duration)
    self.owner.events:emit(Signals.MOVE_TO, position.x + diff.x * tween, position.y + diff.y * tween)
  end)

end

function TargettedMovementComponent:update(dt)
  local oldVelocity = self._velocity:clone()
  local position = Vector(self.owner.body:center())
  local newVelocity = Vector((position.x - self._oldPosition.x) / dt, (position.y - self._oldPosition.y) / dt)
  self._velocity.x = (oldVelocity.x + newVelocity.x) / 2
  self._velocity.y = (oldVelocity.y + newVelocity.y) / 2
  self._velocity.x = math.abs(self._velocity.x) > 1 and self._velocity.x or 0
  self._velocity.y = math.abs(self._velocity.y) > 1 and self._velocity.y or 0
  self._oldPosition.x = position.x
  self._oldPosition.y = position.y

  --MovementComponent.update(self, dt)
end
