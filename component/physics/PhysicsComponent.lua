PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(x, y, width, height)
    Component.init(self)

    self.type = "physics"

    self._body = Collider:addRectangle(x, y, width, height)
    self._body.parent = self
end

function PhysicsComponent:setOwner(owner)
    Component.setOwner(self, owner)

    self._body.type = owner.type

    self.owner.events:register("move", function(x, y)
        self._body:move(x, y)
    end)
end

function PhysicsComponent:center()
    return self._body:center()
end

function PhysicsComponent:bbox()
    return self._body:bbox()
end

function PhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    -- override
end

function PhysicsComponent:kill()
    Collider:remove(self._body)
    Component.kill(self)
end

function PhysicsComponent:update(dt)
    -- override
end

function PhysicsComponent:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255, 100)
    self._body:draw('fill')

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end