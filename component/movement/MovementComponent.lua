local Class = require "lib.hump.Class"
local Component = require "component.Component"
local Vector = require "lib.hump.Vector"
local Constants = require "constants.Constants"
local Signals = require "constants.Signals"

local MovementComponent = Class{}
MovementComponent:include(Component)

function MovementComponent:init(terminalVelocity, continuousMovement)
  assert(terminalVelocity ~= nil and continuousMovement ~= nil, "args missing")
  Component.init(self)

  self.type = "movement"

  self._direction = Vector(0, 0)
  self._velocity = Vector(0, 0)

  -- if true, entity will move on its own.
  -- if false, self._direction is reset each update, stopping movement until set again
  self._continuousMovement = continuousMovement

  self._terminalVelocity = terminalVelocity or Constants.TERMINAL_VELOCITY
  self._friction = 10000
  self._acceleration = self:calcAcceleration(self._terminalVelocity, self._friction)
end

local function setDirection(self, direction)
  if direction == "up" then
    self._direction.y = -1
  elseif direction == "right" then
    self._direction.x = 1
  elseif direction == "down" then
    self._direction.y = 1
  elseif direction == "left" then
    self._direction.x = -1
  end
end

function MovementComponent:terminalVelocity(acceleration, friction)
  return -acceleration / ((1 / friction) - 1)
end

function MovementComponent:calcAcceleration(terminalVelocity, friction)
  return -terminalVelocity / friction + terminalVelocity
end

function MovementComponent:conception()
  self.owner.events:register(Signals.SET_MOVEMENT_DIRECTION, function(direction)
    setDirection(self, direction)
  end)   
   
  Component.conception(self)
end

function MovementComponent:getVelocity()
  return self._velocity:unpack()
end

function MovementComponent:getTerminalVelocity()
  return self._terminalVelocity
end

function MovementComponent:stopMoving()
  self._velocity.x = 0
  self._velocity.y = 0
end

local function resetAcceleration(self)
  self._direction.x = 0
  self._direction.y = 0
end

local function newVelocity(oldVelocity, acceleration, friction, dt)
  local velocity = (oldVelocity / friction ^ dt)
  if friction == 1 then
    return velocity + acceleration * dt
  else
    return velocity + acceleration * ((1 / friction ^ dt - 1) / ((1 / friction) - 1))
  end
end

function MovementComponent:update(dt)
  local oldVelocity = self._velocity:clone()

  local diagonal = math.sqrt((self._direction.x ^ 2 + self._direction.y ^ 2))
  if diagonal ~= 0 then
    self._direction.x = self._direction.x / diagonal
    self._direction.y = self._direction.y / diagonal
  end

  self._velocity.x = newVelocity(self._velocity.x, self._direction.x * self._acceleration, self._friction, dt)
  self._velocity.y = newVelocity(self._velocity.y, self._direction.y * self._acceleration, self._friction, dt)

  -- heun's method
  local movement = Vector((oldVelocity.x + self._velocity.x) * dt / 2, (oldVelocity.y + self._velocity.y) * dt / 2)
  self.owner.events:emit(Signals.MOVE, movement.x, movement.y)

  if not self._continuousMovement then
    resetAcceleration(self)
  end
end

return MovementComponent
