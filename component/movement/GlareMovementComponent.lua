GlareMovementComponent = Class{}
GlareMovementComponent:include(MovementComponent)

function GlareMovementComponent:init(targetDirX, targetDirY)
    MovementComponent.init(self)

    self._targetDirX, self._targetDirY = targetDirX, targetDirY
end

function GlareMovementComponent:update(dt)
    
    self._direction.x = self._targetDirX
    self._direction.y = self._targetDirY
    self._velocity.x = self._targetDirX * self._terminalVelocity
    self._velocity.y = self._targetDirY * self._terminalVelocity

    MovementComponent.update(self, dt)
end