Class = require "hump.class"

FloorQueue = Class{}

function FloorQueue:init(size)
    self._queue = {}
    self._index = 1
    self._maxSize = size
end

function FloorQueue:push(tile, r, g, b)
    local oldIndex = self._index
    self._index = self._index + 1
    if self._index > self._maxSize then
        self._index = 1
    end

    -- update existing tiles
    for tileIndex, tile in ipairs(self._queue) do
        tile.alpha = self:getAlpha(self:getPosition(tileIndex, self._index))
    end

    self._queue[self._index] = tile
    tile.r = r
    tile.g = g
    tile.b = b
    tile.alpha = 255
end

function FloorQueue:first()
    return self._queue[self._index]
end

function FloorQueue:contains(tile)
    for _, v in ipairs(self._queue) do
        if v == tile then
            return true
        end
    end
    return false
end

function FloorQueue:getPosition(tileIndex, firstIndex)
    if tileIndex >= firstIndex then
        return tileIndex - firstIndex
    else
        return (self._maxSize - firstIndex) + tileIndex
    end
end

function FloorQueue:getAlpha(position)
    local ratio = 255 / self._maxSize

    return ratio * position
end