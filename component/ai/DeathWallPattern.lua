local Class = require "lib.hump.Class"
local Pattern = require "component.ai.Pattern"
local Signals = require "constants.Signals"
local EntityTypes = require "constants.EntityTypes"

local DeathWallPattern = Class{}
DeathWallPattern:include(Pattern)

function DeathWallPattern:init()
  Pattern.init(self)
end

function DeathWallPattern:add(x, y, delay, maxVelFactor)
  maxVelFactor = maxVelFactor or 1
  assert(maxVelFactor <= 1, "maxVelFactor must be equal to or smaller than 1")

  table.insert(self._data, {x = x, y = y, delay = delay, maxVelFactor = maxVelFactor})
end

function DeathWallPattern:boom(entry)
  Signal.emit(Signals.ADD_ENTITY, EntityCreator.create(EntityTypes.DEATH_WALL, entry.x, entry.y, entry.maxVelFactor))
end

return DeathWallPattern
