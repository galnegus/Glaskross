CollisionRules = {}

-- CollisionRules (when sent to physicscomponent are tables where the key is the body type, and the value is a list of rules from the functions below)

CollisionRules.Bounce = function()
	return function(self, dt, shapeCollidedWith, dx, dy)
        self._body:move(dx, dy) -- move out the way
        self.owner.events:emit(Signals.BOUNCE, dx, dy)
    end
end

CollisionRules.Destroy = function()
	return function(self, dt, shapeCollidedWith, dx, dy)
	    Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
	end
end

CollisionRules.SelfDestruct = function()
	return function(self, dt, shapeCollidedWith, dx, dy)
        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
	end
end

CollisionRules.StopMovement = function()
	return function(self, dt, shapeCollidedWith, dx, dy)
        self.owner.movement:stopMoving()
        self._body:move(dx, dy)
	end
end

return CollisionRules