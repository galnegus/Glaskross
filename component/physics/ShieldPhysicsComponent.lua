ShieldPhysicsComponent = Class{}
ShieldPhysicsComponent:include(PhysicsComponent)

function ShieldPhysicsComponent:init(options)
    assert(options.masterEntity ~= nil, "options.masterEntity is required.")
	assert(options.masterEntity.physics ~= nil, "master entity must have physics component.")
	self._x, self._y = options.masterEntity.physics:center()

    -- create triangle body in the appearance of a shield
    PhysicsComponent.init(self, options)

    self._masterEntity = options.masterEntity
    self._active = false

    self._xOffset = 0
    self._yOffset = 0
    self._xAnimateOffset = 0
    self._yAnimateOffset = 0

    self._velRotation = 0
end

function ShieldPhysicsComponent:conception()
    PhysicsComponent.conception(self)

    self.owner.events:register(Signals.SHIELD_ACTIVE, function(dirX, dirY, duration)
        assert((dirX == 0 and dirY == -1) or (dirX == 0 and dirY == 1) or 
               (dirX == -1 and dirY == 0) or (dirX == 1 and dirY == 0), 
                "Invalid values of 'dirX' and 'dirY' parameters, must be orthogonal")

        -- rotate the triangle body to face the correct side, also tilt it slightly according to master velocity
        local vx, vy = 0, 0
        if self._masterEntity.movement ~= nil then
            vx, vy = self._masterEntity.movement:getVelocity()
        end  

        -- make the velocity vector smaller than the direction vector to keep the effect subtle
        vx, vy = vx / (3 * Constants.TERMINAL_VELOCITY), vy / (3 * Constants.TERMINAL_VELOCITY)

        -- alter position according to direction and velocity vector
        self._xOffset = dirX * Constants.TILE_SIZE + vx * 100
        self._yOffset = dirY * Constants.TILE_SIZE + vy * 100

        -- rotate collision shape
        self._body:setRotation(math.atan2(dirX + vx, -dirY - vy))

        -- difference between default rotation and the velocity rotation, needed for ShieldRenderComponent to also rotate the rendering stuff
        self._velRotation = self._body:rotation() - math.atan2(dirX, -dirY)

        self._xAnimateOffset = -self._xOffset / 2
        self._yAnimateOffset = -self._yOffset / 2
        gameTimer:tween(duration, self, {_xAnimateOffset = self._xAnimateOffset + dirX * Constants.TILE_SIZE, _yAnimateOffset = self._yAnimateOffset + dirY * Constants.TILE_SIZE}, 'out-sine')

        self._active = true
        Collider:setSolid(self._body)
    end)

    self.owner.events:register(Signals.SHIELD_INACTIVE, function()
        if self._alive then
            self._active = false
            Collider:setGhost(self._body)
        end
    end)
end

function ShieldPhysicsComponent:birth()
    PhysicsComponent.birth(self)
    Collider:setGhost(self._body)
end

function ShieldPhysicsComponent:getVelRotation()
    return self._velRotation
end

function ShieldPhysicsComponent:update(dt)
	PhysicsComponent.update(self, dt)

	if self._active then
		self._x, self._y = self._masterEntity.physics:center()

		self._body:moveTo(self._x + self._xOffset + self._xAnimateOffset, self._y + self._yOffset + self._yAnimateOffset)
	end
end
