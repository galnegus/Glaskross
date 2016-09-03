MenuList = Class{}

local OFFSET = 100
local FONT_SIZE = 40

local COLOUR = {255, 255, 255, 150}
local SELECTED_COLOUR = {200, 150, 255, 150}

function MenuList:init()
  self._menuItems = {}
  self._selected = 1
  self._size = 0 -- replace with #self._menuItems ?

  self._entity = Entity.new(-1, EntityTypes.GUI)
  self._entity:addComponent(VelocityRotatingBodyComponent({
    shape = HC.rectangle(100, 100, Constants.TILE_SIZE, Constants.TILE_SIZE),
    bodyType = BodyTypes.PLAYER,
    collisionRules = {}
  }))
  self._entity:addComponent(RenderComponent(Colours.PLAYER_RENDER, 0, Constants.DEFAULT_DEATH_DURATION, true))
  self._entity:addComponent(MovementComponent(false, false))
  --self._entity:addComponent(OptimizedTrailEffectComponent(Colours.PLAYER_STEP))
end

function MenuList:add(text, callback)
  self._size = self._size + 1
  table.insert(self._menuItems, MenuItem(text, callback));
end

function MenuList:press()
  self._menuItems[self._selected]:press()
end

-- if this._size == 3, n == 0 -> 3, n == 4 -> 1
function MenuList:_cyclicalPos(n)
  return ((n - 1) % self._size) + 1
end

function MenuList:select(n)
  self._selected = n
  self._entity.body._shape:moveTo(150, (love.graphics.getHeight() / 3 - self:height() / 3) + (n - 1) * OFFSET + FONT_SIZE - 5)
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

function MenuList:update(dt)
  self._entity:update(dt)
end

function MenuList:height()
  return FONT_SIZE * self._size + OFFSET * (self._size - 1)
end

function MenuList:draw(x, y)
  --[[
  local listHeight = FONT_SIZE * self._size + OFFSET * (self._size - 1)
  for i, menuItem in ipairs(self._menuItems) do
    if i == self._selected then 
      love.graphics.setColor(SELECTED_COLOUR) 
    else 
      love.graphics.setColor(COLOUR) 
    end
    
    menuItem:draw(200, (love.graphics.getHeight() / 3 - listHeight / 3) + OFFSET * (i - 1))
  end
  ]]

  for i, menuItem in ipairs(self._menuItems) do
    if i == self._selected then 
      love.graphics.setColor(SELECTED_COLOUR) 
    else 
      love.graphics.setColor(COLOUR) 
    end
    
    menuItem:draw(x, y + OFFSET * (i - 1))
  end

  self._entity:draw()

  --self:_debugDraw()
end

function MenuList:_debugDraw()
  local listHeight = FONT_SIZE * self._size + OFFSET * (self._size - 1)
  love.graphics.rectangle("fill", 200, (love.graphics.getHeight() / 3 - listHeight / 3), 3, listHeight)
end