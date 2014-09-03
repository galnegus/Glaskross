PlayerPhysicsComponent = Class{}
PlayerPhysicsComponent:include(PhysicsComponent)

function PlayerPhysicsComponent:init(x, y, width, height)
    PhysicsComponent.init(self, x, y, width, height)
    
    self._floorColorR = 160
    self._floorColorG = 122
    self._floorColorB = 183

    self._lastCollidedWith = nil
end

function PlayerPhysicsComponent:on_collide(dt, shapeCollidedWith, dx, dy)
    dx = dx or 0
    dy = dy or 0
    if shapeCollidedWith.type == "wall" then 
        --print("boom " .. dt .. ", dx: " .. dx .. ", dy: " .. dy)
        self.owner.movement:stopMoving()
        self._body:move(dx, dy)     
    elseif shapeCollidedWith.type == "tile" then
        local tile = shapeCollidedWith.parent
        if tile._killer then
            Gamestate.switch(menu)
        end
        -- the alpha <= 0 condition makes sure that the tile is relit once it's out
        if shapeCollidedWith ~= self._lastCollidedWith or tile:getFgAlpha() <= 0 then
            self._lastCollidedWith = shapeCollidedWith
            tile:step(0.05, 5, self._floorColorR, self._floorColorG, self._floorColorB)
        end
    end
end