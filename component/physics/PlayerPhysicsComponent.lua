PlayerPhysicsComponent = Class{}
PlayerPhysicsComponent:include(PhysicsComponent)

function PlayerPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)

    self._floorColour = Colours.PLAYER_STEP()

    self._lastCollidedWith = nil
end

function PlayerPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == BodyTypes.WALL then 
        --print("boom " .. dt .. ", dx: " .. dx .. ", dy: " .. dy)
        self.owner.movement:stopMoving()
        self._body:move(dx, dy)     
    elseif shapeCollidedWith.type == BodyTypes.TILE then
        local tile = shapeCollidedWith.parent
        if tile._killer then
            Signal.emit(Signals.KILL_ENTITY, self.owner.id)
        end
        -- the alpha <= 0 condition makes sure that the tile is relit once it's out
        if shapeCollidedWith ~= self._lastCollidedWith or tile:getFgAlpha() <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            tile:step(0.05, 5, self._floorColour)
        end
    end
end