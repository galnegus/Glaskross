PhysicsComponent = Class{}
PhysicsComponent:include(Component)

function PhysicsComponent:init(Collider, x, y, width, height)
    self.type = "physics"

    self._body = Collider:addRectangle(x, y, width, height)
    self._body.type = "entity"
    self._body.parent = self

    self._floorColorR = 160
    self._floorColorG = 122
    self._floorColorB = 183

    self._lastCollidedWith = nil
end

function PhysicsComponent:setOwner(owner)
    Component.setOwner(self, owner)

    self.owner.events:register("move", function(x, y)
        self._body:move(x, y)
    end)
end

function PhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        self.owner.movement:stopMoving()
        self._body:move(dx, dy)     
    elseif shapeCollidedWith.type == "tile" then
        local tile = shapeCollidedWith.parent
        if shapeCollidedWith ~= self._lastCollidedWith or tile.alpha <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            tile:stepLightUp(self._floorColorR, self._floorColorG, self._floorColorB)
        end
    end
end

function PhysicsComponent:update(dt)

end

function PhysicsComponent:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    love.graphics.setColor(255, 255, 255, 100)
    self._body:draw('fill')

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end