local Class = require "lib.hump.Class"
local Component = require "component.Component"
local Signals = require "constants.Signals"

local HPComponent = Class{}
HPComponent:include(Component)

function HPComponent:init(hp, hitSignal)
  assert(hp and hitSignal, "arguments missing")
  Component.init(self)

  self.type = "hp"

  self._hp = hp
  self._hitSignal = hitSignal
end

function HPComponent:conception()
  self.owner.events:register(self._hitSignal, function()
    self._hp = self._hp - 1
    if self._hp <= 0 then
      Signal.emit(Signals.KILL_ENTITY, self.owner)
    end
  end)
  
  Component.conception(self)
end

return HPComponent
