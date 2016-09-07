local Class = require "lib.hump.Class"

local Component = Class{}

function Component:init()
  -- set to true when the component is ready to be "alive", e.g. render component is done fading in
  self._readyForBirth = false

  -- Component:update(dt) will only be called if alive
  self._alive = false

  -- Component:draw() will only be called if renderable
  self._renderable = false
end

function Component:setOwner(owner)
  assert(self.type, "component must have self.type defined")
  self.owner = owner
end

function Component:update(dt)
  -- override this
end

function Component:draw()
  -- override this (and set renderable to true if rendering is needed)
end

function Component:renderable()
  return self._renderable
end

function Component:isReadyForBirth()
  return self._readyForBirth
end

function Component:conception()
  self._readyForBirth = true
  self.owner:birthAttempt()
end

function Component:birth()
  self._alive = true
end

function Component:isAlive()
  return self._alive
end

function Component:death()
  self._alive = false
  self.owner:burialAttempt()
end

return Component
