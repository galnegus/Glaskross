CollisionRules = {}

CollisionRules.Bounce = function(bodyType)
	return function(self, dt, shapeCollidedWith, dx, dy)
		if shapeCollidedWith.type == bodyType then
	        self._body:move(dx, dy) -- move out the way
	        self.owner.events:emit(Signals.BOUNCE, dx, dy)
	    end
    end
end

CollisionRules.Destroy = function(bodyType)
	return function(self, dt, shapeCollidedWith, dx, dy)
		if shapeCollidedWith.type == bodyType then
	        Signal.emit(Signals.KILL_ENTITY, shapeCollidedWith.parent.owner.id)
	    end
	end
end

CollisionRules.SelfDestruct = function(bodyType)
	return function(self, dt, shapeCollidedWith, dx, dy)
		if shapeCollidedWith.type == bodyType then 
	        Signal.emit(Signals.KILL_ENTITY, self.owner.id)
	    end
	end
end

CollisionRules.StopMovement = function(bodyType)
	return function(self, dt, shapeCollidedWith, dx, dy)
		if shapeCollidedWith.type == bodyType then 
	        self.owner.movement:stopMoving()
        	self._body:move(dx, dy)
	    end
	end
end

return CollisionRules