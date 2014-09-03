DeathWallPhysicsComponent = Class{}
DeathWallPhysicsComponent:include(PhysicsComponent)

function DeathWallPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)

    self._floorColorR = 113
    self._floorColorG = 225
    self._floorColorB = 113
end

function DeathWallPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        Signal.emit("kill entity", self.owner.id)
    elseif shapeCollidedWith.type == "player" then
        --
    end
end