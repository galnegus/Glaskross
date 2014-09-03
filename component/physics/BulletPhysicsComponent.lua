BulletPhysicsComponent = Class{}
BulletPhysicsComponent:include(PhysicsComponent)

function BulletPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)

    self._floorColorR = 225
    self._floorColorG = 113
    self._floorColorB = 113
end

function BulletPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        Signal.emit("kill entity", self.owner.id)
    elseif shapeCollidedWith.type == "tile" then
        local tile = shapeCollidedWith.parent
        if shapeCollidedWith ~= self._lastCollidedWith then
            self._lastCollidedWith = shapeCollidedWith
            tile:step(0.03, 5, self._floorColorR, self._floorColorG, self._floorColorB)
        end
    end
end