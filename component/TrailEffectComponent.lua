TrailEffectComponent = Class{}
TrailEffectComponent:include(PhysicsComponent) -- ! this should not be considered a normal physics component !

function TrailEffectComponent:init(colour)
	PhysicsComponent.init(self, Collider:addRectangle(1, 1, 0.1, 0.1))

	self.type = ComponentTypes.TRAIL_EFFECT

	self._colour = colour
	self._lastCollidedWith = nil
end

function TrailEffectComponent:update(dt)
	PhysicsComponent.update(self, dt)

	local x, y = self.owner.physics:center()
	self._body:moveTo(x, y)
end

function TrailEffectComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == BodyTypes.TILE then
        local tile = shapeCollidedWith.parent
        -- the alpha <= 0 condition makes sure that the tile is relit once it's out
        if shapeCollidedWith ~= self._lastCollidedWith or tile:getFgAlpha() <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            tile:step(0.05, 5, self._colour)
        end
    end
end

