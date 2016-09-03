TargettedMovementComponent = Class{}
TargettedMovementComponent:include(MovementComponent)

function TargettedMovementComponent:init(terminalVelocity)
  assert(targetDirX and targetDirY and initialVelocity and steps, "arguments missing")
  MovementComponent.init(self, terminalVelocity, true)
end

function TargettedMovementComponent:moveTo(x, y)
  -- todo
end

function TargettedMovementComponent:update(dt)
  MovementComponent.update(self, dt)
end
