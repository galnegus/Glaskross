ShieldPhysicsComponent = Class{}
ShieldPhysicsComponent:include(PhysicsComponent)

function ShieldPhysicsComponent:init(masterEntity)
	assert(masterEntity.physics ~= nil, "master entity must have physics component.")
	self._x, self._y = masterEntity.physics:center()

    PhysicsComponent.init(self, self._x, self._y, Constants.TILE_SIZE, Constants.TILE_SIZE)

    self._masterEntity = masterEntity
    self._active = false

    self._xOffset = 0
    self._yOffset = 0
end

function ShieldPhysicsComponent:setOwner(owner)
	PhysicsComponent.setOwner(self, owner)

	owner.events:register(Signals.SHIELD_ACTIVE, function(x, y)
		assert((x == 0 and y == -1) or (x == 0 and y == 1) or 
        	   (x == -1 and y == 0) or (x == 1 and y == 0), 
        		"Invalid values of 'x' and 'y' parameters, must be orthogonal")

        self._xOffset = x * Constants.TILE_SIZE
        self._yOffset = y * Constants.TILE_SIZE

        self._active = true
	end)

	self.owner.events:register(Signals.SHIELD_INACTIVE, function()
		self._active = false
	end)
end

function ShieldPhysicsComponent:update(dt)
	PhysicsComponent.update(self, dt)

	if self._active then
		self._x, self._y = self._masterEntity.physics:center()

		self._body:moveTo(self._x + self._xOffset, self._y + self._yOffset)
	end
end

function ShieldPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == BodyTypes.WALL then 
        --print("boom " .. dt .. ", dx: " .. dx .. ", dy: " .. dy)
    end
end