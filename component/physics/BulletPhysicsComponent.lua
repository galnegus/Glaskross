BulletPhysicsComponent = Class{}
BulletPhysicsComponent:include(RotatingPhysicsComponent)

function BulletPhysicsComponent:init(x, y, width, height, rps, bodyType, collisionRules)
    RotatingPhysicsComponent.init(self, Collider:addRectangle(x, y, width, height), rps, bodyType, collisionRules)
	Collider:addToGroup(CollisionGroups.FRIENDLY, self._body)
end
