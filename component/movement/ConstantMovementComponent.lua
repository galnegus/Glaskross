local Class = require "lib.hump.Class"
local MovementComponent = require "component.movement.MovementComponent"

local ConstantMovementComponent = Class{}
ConstantMovementComponent:include(MovementComponent)

function ConstantMovementComponent:init(targetDirX, targetDirY, terminalVelocity)
  MovementComponent.init(self, terminalVelocity, true)

  self._targetDirX, self._targetDirY = targetDirX, targetDirY

  self._velocity.x = self._targetDirX * self._terminalVelocity
  self._velocity.y = self._targetDirY * self._terminalVelocity

  self._direction.x = self._targetDirX
  self._direction.y = self._targetDirY
end

return ConstantMovementComponent
