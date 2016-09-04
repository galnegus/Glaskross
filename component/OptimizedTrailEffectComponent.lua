OptimizedTrailEffectComponent = Class{}
OptimizedTrailEffectComponent:include(Component)

function OptimizedTrailEffectComponent:init(color)
  Component.init(self)

  self.type = "trail effect"

  self._rows = Constants.ROWS
  self._columns = Constants.COLS
  self._alpha = {}
  self._timerHandlers = {}
  for i = 1, self._columns do
    self._alpha[i] = {}
    self._timerHandlers[i] = {}
    for j = 1, self._rows do
      self._alpha[i][j] = 0 -- matrices in lua are naturally sparse c:
      self._timerHandlers[i][j] = 0
    end
  end
  
  self._toRender = {} -- also a matrix but with the two indices composed into one ([x][y] -> [x * rows + y]) for iteration with for-in-pairs()

  self._color = color
  self._lastCollidedWith = nil
  self._renderable = true

  self._lastPosition = Vector(0, 0)

  self._duration = 0.25
end

local function worldToMatrix(x, y)
  return Vector(math.floor(x / Constants.TILE_SIZE) + 1, math.floor(y / Constants.TILE_SIZE) + 1)
end

local function matrixToWorld(vector)
  local tileSize = Constants.TILE_SIZE
  return (vector.x) * tileSize - tileSize / 2, (vector.y) * tileSize - tileSize / 2
end

function OptimizedTrailEffectComponent:update(dt)
  local x, y = self.owner.body:center()

  local pos = worldToMatrix(x, y)
  if pos ~= self._lastPosition or self._alpha[pos.x][pos.y] == 0 then
    if self._timerHandlers[pos.x][pos.y] ~= 0 then
      Timer.cancel(self._timerHandlers[pos.x][pos.y])
    end
    self._alpha[pos.x][pos.y] = 255
    self._toRender[pos.x * self._rows + pos.y] = pos
    self._timerHandlers[pos.x][pos.y] = Timer.during(self._duration, function()
      self._alpha[pos.x][pos.y] = self._alpha[pos.x][pos.y] - dt * 255 / self._duration
      if self._alpha[pos.x][pos.y] < 0 then
        self._alpha[pos.x][pos.y] = 0
      end
    end, function()
      self._timerHandlers[pos.x][pos.y] = 0
      self._alpha[pos.x][pos.y] = 0
      self._toRender[pos.x * self._rows + pos.y] = nil
      
    end)
  end

  self._lastPosition = pos;
end

function OptimizedTrailEffectComponent:draw()
  local tileSize = Constants.TILE_SIZE / 2
  for _, pos in pairs(self._toRender) do
    local x, y = matrixToWorld(pos)
    local x1, y1, x2, y2 = x - tileSize, y - tileSize, x + tileSize, y + tileSize
    love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), self._alpha[pos.x][pos.y] / 10)
    love.graphics.rectangle("fill", x1 + 1, y1 + 1, x2 - x1 - 2, y2 - y1 - 2)
    love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), self._alpha[pos.x][pos.y])
    love.graphics.rectangle("line", x1 + 1.5, y1 + 1.5, x2 - x1 - 2, y2 - y1 - 2)
  end
end
