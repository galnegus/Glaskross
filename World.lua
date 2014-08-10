World = Class{}

function World:init(Collider, width, height, tileSize)
    local wallSize = 64

    -- init walls
    self._walls = {}
    self._walls.top = Collider:addRectangle(0, 0, width, wallSize)
    self._walls.top.type = "wall"
    self._walls.right = Collider:addRectangle(width - wallSize, 0, wallSize, height)
    self._walls.right.type = "wall"
    self._walls.bottom = Collider:addRectangle(0, height - wallSize, width, wallSize)
    self._walls.bottom.type = "wall"
    self._walls.left = Collider:addRectangle(0, 0, wallSize, height)
    self._walls.left.type = "wall"   
    Collider:setPassive(self._walls.top, self._walls.right, self._walls.bottom, self._walls.left)

    -- init floor
    self._floor = {}
    for i = 1, (width / tileSize) - 2, 1 do
        self._floor[i] = {}
        for j = 1, (height / tileSize) - 2, 1 do
            self._floor[i][j] = Collider:addRectangle(tileSize * i, tileSize * j, tileSize - 1, tileSize - 1)
            self._floor[i][j].type = "floor"
            self._floor[i][j].alpha = 0
            Collider:setPassive(self._floor[i][j])
        end
    end
end

function World:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    -- draw walls
    love.graphics.setColor(0, 0, 0, 100)
    self._walls.bottom:draw('fill')
    self._walls.left:draw('fill')
    self._walls.right:draw('fill')
    self._walls.top:draw('fill')

    -- draw floor
    for i, row in ipairs(self._floor) do
        for j, tile in ipairs(row) do
            love.graphics.setColor(88 + math.random() * 30, 51 + math.random() * 30, 125 + math.random() * 30, 100)
            tile:draw("fill")
            if tile.alpha ~= 0 then
                love.graphics.setColor(tile.r, tile.g, tile.b, tile.alpha)
                local x1,y1, x2,y2 = tile:bbox()
                love.graphics.rectangle("fill", x1, y1, x2 - x1, y2 - y1)
            end
        end
    end

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end