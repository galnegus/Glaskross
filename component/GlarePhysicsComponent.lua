GlarePhysicsComponent = Class{}
GlarePhysicsComponent:include(PhysicsComponent)

function GlarePhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)

    self._floorColorR = 225
    self._floorColorG = 113
    self._floorColorB = 113
end

function GlarePhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        self.owner.movement:stopMoving()
        Signal.emit("kill entity", self.owner.id)
    elseif shapeCollidedWith.type == "tile" then
        local tile = shapeCollidedWith.parent
        if shapeCollidedWith ~= self._lastCollidedWith or tile.alpha <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            tile:stepLightUp(self._floorColorR, self._floorColorG, self._floorColorB, 0.03, 5)
        end
    end
end

function GlarePhysicsComponent:draw()
    PhysicsComponent.draw(self)
end