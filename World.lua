function generateWalls(Collider, width, height)
    local size = 64
    local walls = {}

    walls.top = Collider:addRectangle(0, 0, width, size)
    walls.top.type = "wall"

    walls.right = Collider:addRectangle(width - size, 0, size, height)
    walls.right.type = "wall"

    walls.bottom = Collider:addRectangle(0, height - size, width, size)
    walls.bottom.type = "wall"

    walls.left = Collider:addRectangle(0, 0, size, height)
    walls.left.type = "wall"   

    Collider:setPassive(walls.top, walls.right, walls.bottom, walls.left)

    return walls
end

function generateFloor(Collider, width, height, tileSize)
    local floor = {}

    print((width % tileSize) - 2)

    for i = 1, (width / tileSize) - 2, 1 do
        floor[i] = {}
        for j = 1, (height / tileSize) - 2, 1 do
            floor[i][j] = Collider:addRectangle(tileSize * i, tileSize * j, tileSize - 1, tileSize - 1)
            floor[i][j].type = "floor"
            floor[i][j].alpha = 0
            Collider:setPassive(floor[i][j])
        end
    end

    return floor
end

function drawFloor(floor)
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    for i, row in ipairs(floor) do
        for j, tile in ipairs(row) do
            love.graphics.setColor(93 + math.random() * 20, 56 + math.random() * 20, 130 + math.random() * 20, 100)
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