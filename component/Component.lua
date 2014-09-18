Component = Class{}

function Component:init()
    self._alive = true
end

function Component:setOwner(owner)
    self.owner = owner
end

function Component:isAlive()
    return self._alive
end

function Component:update(dt)
    --
end

function Component:kill()
    self._alive = false

    self.owner:suicideAttempt()
end