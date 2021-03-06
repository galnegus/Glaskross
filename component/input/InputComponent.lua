local Class = require "lib.hump.Class"
local Component = require "component.Component"
local Signals = require "constants.Signals"

local InputComponent = Class{}
InputComponent:include(Component)

function InputComponent:init()
  self.type = "input"
  
  Component.init(self)
end

function InputComponent:update()
  if love.keyboard.isDown("w") then
    self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "up")
  end
  if love.keyboard.isDown("a") then
    self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "left")
  end
  if love.keyboard.isDown("s") then
    self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "down")
  end
  if love.keyboard.isDown("d") then
    self.owner.events:emit(Signals.SET_MOVEMENT_DIRECTION, "right")
  end
end

return InputComponent
