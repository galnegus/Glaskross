PlayerPhysicsComponent = Class{}
PlayerPhysicsComponent:include(VelocityRotatingPhysicsComponent)

function PlayerPhysicsComponent:init(x, y)
    VelocityRotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, Constants.TILE_SIZE, Constants.TILE_SIZE))

    self._floorColour = Colours.PLAYER_STEP
end

function PlayerPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == BodyTypes.WALL then 
        --print("boom " .. dt .. ", dx: " .. dx .. ", dy: " .. dy)
        self.owner.movement:stopMoving()
        self._body:move(dx, dy)
    elseif shapeCollidedWith.type == BodyTypes.TILE then
        if shapeCollidedWith.parent._killer then
            Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        end
    end
end