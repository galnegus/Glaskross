local Class = require "lib.hump.Class"
local BodyComponent = require "component.body.BodyComponent"
local Signals = require "constants.Signals"

local DeathWallBodyComponent = Class{}
DeathWallBodyComponent:include(BodyComponent)

function DeathWallBodyComponent:init(options)
  BodyComponent.init(self, options)

  -- todo: passive mode?
end

function DeathWallBodyComponent:update(dt)
  local x1, y1, x2, y2 = self:bbox()
  if x1 < 0 or y1 < 0 or x2 > love.graphics.getWidth() or y2 > love.graphics.getHeight() then
    Signal.emit(Signals.KILL_ENTITY, self.owner)
  end

  BodyComponent.update(self, dt)
end

return DeathWallBodyComponent
