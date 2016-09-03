MenuList = Class{}

local OFFSET = 96

local COLOUR = {255, 255, 255, 200}
local SELECTED_COLOUR = {200, 150, 255, 200}

local FONT = love.graphics.newFont("assets/fonts/Share/Share-Regular.ttf", 60)

function MenuList:init()
  self._menuItems = {}
  self._selected = 1
  self._size = 0 -- replace with #self._menuItems ?

  self._entity = Entity.new(-1, EntityTypes.GUI)
  self._entity:addComponent(VelocityRotatingBodyComponent({
    shape = HC.rectangle(Constants.TILE_SIZE * 4 + Constants.TILE_SIZE / 2, 0, Constants.TILE_SIZE, Constants.TILE_SIZE),
    bodyType = BodyTypes.PLAYER,
    collisionRules = {}
  }))
  self._entity:addComponent(RenderComponent(Colours.PLAYER_RENDER, 0, Constants.DEFAULT_DEATH_DURATION, true))
  self._entity:addComponent(TargettedMovementComponent(false, false))
  self._entity:addComponent(OptimizedTrailEffectComponent(Colours.PLAYER_STEP))
  self._entity:conception()
end

function MenuList:add(text, callback)
  self._size = self._size + 1
  table.insert(self._menuItems, MenuItem(text, FONT, callback));
end

function MenuList:press()
  self._menuItems[self._selected]:press()
end

-- if this._size == 3, n == 0 -> 3, n == 4 -> 1
function MenuList:_cyclicalPos(n)
  return ((n - 1) % self._size) + 1
end

function MenuList:select(n)
  self._menuItems[self._selected]:setColour(COLOUR, true)
  self._selected = n
  self._menuItems[self._selected]:setColour(SELECTED_COLOUR, true)
  self._entity.movement:moveTo(Constants.TILE_SIZE * 4 + Constants.TILE_SIZE / 2, self:yPosition() + (n - 1) * OFFSET + FONT:getHeight() / 2)
end

function MenuList:up()
  self:select(self:_cyclicalPos(self._selected - 1))
end

function MenuList:right()

end

function MenuList:down()
  self:select(self:_cyclicalPos(self._selected + 1))
end

function MenuList:left()

end

function MenuList:yPosition()
  return math.ceil((love.graphics.getHeight() / 2 - self:height() / 2) / 32) * 32 - 16
end

function MenuList:update(dt)
  self._entity:update(dt)
end

function MenuList:height()
  return FONT:getHeight() + OFFSET * (self._size - 1)
end

function MenuList:draw(x, y)
  for i, menuItem in ipairs(self._menuItems) do   
    menuItem:draw(x, y + OFFSET * (i - 1))
  end

  self._entity:draw()

  --self:_debugDraw()
end

function MenuList:_debugDraw()
  --local listHeight = FONT:getHeight() * self._size + OFFSET * (self._size - 1)
  love.graphics.rectangle("fill", 185, (love.graphics.getHeight() / 2 - self:height() / 2), 3, self:height())
end