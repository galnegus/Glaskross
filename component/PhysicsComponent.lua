Class = require "hump.class"
require "component.Component"
require "FloorQueue"

PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(Collider, x, y, width, height)
    self.type = "physics"
    self.body = Collider:addRectangle(x, y, width, height)
    self.body.type = "entity"

    self._floorQueue = FloorQueue(10)
    self._floorColorR = 160
    self._floorColorG = 122
    self._floorColorB = 183

    print(self._floorColorR)
end

function PhysicsComponent:setOwner(owner)
    self.owner = owner
    self.body.owner = self
end

function PhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        self.owner.movement.velocity.x = 0
        self.owner.movement.velocity.y = 0
        self.body:move(dx, dy)     
    elseif shapeCollidedWith.type == "floor" then
        if not self._floorQueue:contains(shapeCollidedWith) then
            self._floorQueue:push(shapeCollidedWith, self._floorColorR, self._floorColorG, self._floorColorB)
        end
    end
end

function PhysicsComponent:update(dt)

end

function PhysicsComponent:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255, 100)
    self.body:draw('fill')

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end