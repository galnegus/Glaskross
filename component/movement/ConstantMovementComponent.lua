ConstantMovementComponent = Class{}
ConstantMovementComponent:include(MovementComponent)

function ConstantMovementComponent:init(targetDirX, targetDirY, terminalVelocity)
    MovementComponent.init(self, terminalVelocity)

    self._targetDirX, self._targetDirY = targetDirX, targetDirY
end

function ConstantMovementComponent:update(dt)
    
    self._direction.x = self._targetDirX
    self._direction.y = self._targetDirY
    self._velocity.x = self._targetDirX * self._terminalVelocity
    self._velocity.y = self._targetDirY * self._terminalVelocity

    MovementComponent.update(self, dt)
end