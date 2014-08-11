World = Class{}

function World:init(width, height, tileSize)
    
    -- init walls
    local wallSize = 64
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
            self._floor[i][j] = Tile(tileSize * i, tileSize * j, tileSize - 1, tileSize - 1)
        end
    end
end

function World:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    -- draw walls
    love.graphics.setColor(0, 0, 0, 255)
    self._walls.bottom:draw('fill')
    self._walls.left:draw('fill')
    self._walls.right:draw('fill')
    self._walls.top:draw('fill')

    -- draw floor
    for i, row in ipairs(self._floor) do
        for j, tile in ipairs(row) do
            tile:draw()
        end
    end

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end