BouncerMovementComponent = Class{}
BouncerMovementComponent:include(MovementComponent)

function BouncerMovementComponent:init(targetDirX, targetDirY, initialVelocity, splittingVelocity, steps)
    assert(targetDirX and targetDirY and initialVelocity and splittingVelocity and steps, "arguments missing")
    MovementComponent.init(self, initialVelocity)

    self._bouncerVelocity = initialVelocity
    self._splittingVelocity = splittingVelocity < Constants.TERMINAL_VELOCITY and splittingVelocity or Constants.TERMINAL_VELOCITY
    self._step = (self._splittingVelocity - self._bouncerVelocity) / steps + 0.1 -- 0.1 = arbritrary number

    self._targetDirX, self._targetDirY = targetDirX, targetDirY

    self._velocity.x = self._targetDirX * self._bouncerVelocity
    self._velocity.y = self._targetDirY * self._bouncerVelocity

    Signal.register(Signals.BOUNCER_BOUNCE, function(dx, dy)
        assert(dx and dy, "dx or dy missing")
        self._acceleration = self:calcAcceleration(self._bouncerVelocity, self._friction)

        if dx ~= 0 then
            self._direction.x = self._direction.x * -1
        end
        if dy ~= 0 then
            self._direction.y = self._direction.y * -1
        end
    end)
end