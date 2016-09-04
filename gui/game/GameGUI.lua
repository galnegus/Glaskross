GameGUI = Class{}

function GameGUI:init()
  self._elements = {}

  --self:addElement(HealthBar())
  self:addElement(EntityListGUI())
end

function GameGUI:addElement(element)
  assert(element.gui_id ~= nil, "element must have gui id")
  assert(self._elements[element.gui_id] == nil, "element already added")

  self._elements[element.gui_id] = element
end

function GameGUI:update(dt)
  for _, element in pairs(self._elements) do
    element:update(dt)
  end
end

function GameGUI:draw()
  for _, element in pairs(self._elements) do
    element:draw()
  end

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS( )), 10, love.graphics.getHeight() - 20)
end