PlayerPhysicsComponent = Class{}
PlayerPhysicsComponent:include(VelocityRotatingPhysicsComponent)

function PlayerPhysicsComponent:init(x, y, bodyType, collisionRules)
    VelocityRotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, Constants.TILE_SIZE, Constants.TILE_SIZE), bodyType, collisionRules)
    Collider:addToGroup(CollisionGroups.FRIENDLY, self._body)

    self._floorColour = Colours.PLAYER_STEP
end
