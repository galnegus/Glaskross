World = Class{}

function World:init(width, height, tileSize)

    -- init walls
    local wallSize = Constants.TILE_SIZE;
    self._walls = {}
    self._walls.top = Collider:addRectangle(-wallSize, -wallSize, width + 2 * wallSize, wallSize)
    self._walls.top.type = "wall"
    self._walls.right = Collider:addRectangle(width, -wallSize, wallSize, height + 2 * wallSize)
    self._walls.right.type = "wall"
    self._walls.bottom = Collider:addRectangle(-wallSize, height, width + 2 * wallSize, wallSize)
    self._walls.bottom.type = "wall"
    self._walls.left = Collider:addRectangle(-wallSize, -wallSize, wallSize, height + 2 * wallSize)
    self._walls.left.type = "wall"   
    Collider:setPassive(self._walls.top, self._walls.right, self._walls.bottom, self._walls.left)

    -- init floor
    self._floor = {}
    self._floor.columns = math.floor(width / tileSize) -- 40
    self._floor.rows = math.floor(height / tileSize) -- 20
    --print("columns: " .. self._floor.columns .. ", rows: " .. self._floor.rows)
    for i = 1, self._floor.columns, 1 do
        self._floor[i] = {}
        for j = 1, self._floor.rows, 1 do
            self._floor[i][j] = Tile(tileSize * (i - 1), tileSize * (j - 1), tileSize, tileSize)
        end
    end

    Signal.register(Signals.AREA_BEAM, function(x, y, duration)
        tiles = self:getFloorSection(x, y)
        for _, tile in pairs(tiles) do
            error("AREA BEAM ARE CANCELLED ASSHOLE, maybe bring them back later?")
        end
    end)
end

function World:rows()
    return self._floor.rows;
end

function World:columns()
    return self._floor.columns;
end

-- returns the center coordinates of the tile enclosing (x, y)
function World:closestTileCenter(x, y)
    local tileSize = Constants.TILE_SIZE
    local tilePos = Vector(math.floor(x / tileSize), math.floor(y / tileSize))
    return tilePos.x * tileSize + tileSize / 2, tilePos.y * tileSize + tileSize / 2
end

function World:getFloorSection(x, y)
    local ret = {}
    if x < 1 or x > Constants.BEAM_COLS or y < 1 or y > Constants.BEAM_ROWS then
        error("Conditions: 1<=x<=4 and 1<=y<=3 not met. (x: " .. x .. ", y: " .. y .. ")")
    end

    -- do some rounding to make sure all tiles are accounted 
    -- for in case the width or height of the world changes
    -- and qCols or qRows arn't integers
    local qCols, qRows = self._floor.columns / Constants.BEAM_COLS, self._floor.rows / Constants.BEAM_ROWS
    for i = math.floor((x - 1) * qCols + 0.5) + 1, math.floor((x) * qCols + 0.5), 1 do
        for j = math.floor((y - 1) * qRows + 0.5) + 1, math.floor((y) * qRows + 0.5), 1 do
            table.insert(ret, self._floor[i][j])
        end
    end

    --table.insert(ret, self._floor[10][10])
    return ret
end

function World:update(dt)
    for _, row in ipairs(self._floor) do
        for _, tile in ipairs(row) do
            tile:update(dt)
        end
    end
end

function World:draw()
    -- draw walls
    --[[
    love.graphics.setColor(0, 0, 0, 255)
    self._walls.bottom:draw('fill')
    self._walls.left:draw('fill')
    self._walls.right:draw('fill')
    self._walls.top:draw('fill')
    ]]

    -- draw floor
    for _, row in ipairs(self._floor) do
        for _, tile in ipairs(row) do
            tile:draw()
        end
    end
end