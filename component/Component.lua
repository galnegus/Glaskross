Component = Class{}

function Component:init()
    self._readyForBirth = false
    self._alive = false
end

function Component:setOwner(owner)
    assert(self.type, "component must have self.type defined")
    self.owner = owner
end

function Component:update(dt)
    -- override this
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