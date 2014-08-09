Class = require "hump.class"
Timer = require "hump.timer"
require "component.Component"
require "FloorQueue"

PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(Collider, x, y, width, height)
    self.type = "physics"
    self.body = Collider:addRectangle(x, y, width, height)
    self.body.type = "entity"

    self._floorColorR = 160
    self._floorColorG = 122
    self._floorColorB = 183

    self._lastCollidedWith = nil
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
        if shapeCollidedWith ~= self._lastCollidedWith or shapeCollidedWith.alpha <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            shapeCollidedWith.alpha = 255
            shapeCollidedWith.r = self._floorColorR
            shapeCollidedWith.g = self._floorColorG
            shapeCollidedWith.b = self._floorColorB

            Timer.addPeriodic(0.05, function()
                local step = 255 / 7
                if shapeCollidedWith.alpha - step < 0 then
                    step = shapeCollidedWith.alpha
                end
                shapeCollidedWith.alpha = shapeCollidedWith.alpha - step
            end, 7)
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