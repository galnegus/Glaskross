local Class = require "lib.hump.Class"
local VelocityRotatingBodyComponent = require "component.body.VelocityRotatingBodyComponent"
local EntityTypes = require "constants.EntityTypes"
local Signals = require "constants.Signals"

local BouncerBodyComponent = Class{}
BouncerBodyComponent:include(VelocityRotatingBodyComponent)

function BouncerBodyComponent:init(options)
  VelocityRotatingBodyComponent.init(self, options, 5)
end

function BouncerBodyComponent:conception()
  -- create sword
  self._sword = EntityCreator.create(EntityTypes.BOUNCER_SWORD, self.owner)
  Signal.emit(Signals.ADD_ENTITY, self._sword)

  VelocityRotatingBodyComponent.conception(self)
end

function BouncerBodyComponent:death()
  Signal.emit(Signals.KILL_ENTITY, self._sword)

  VelocityRotatingBodyComponent.death(self)
end

return BouncerBodyComponent
