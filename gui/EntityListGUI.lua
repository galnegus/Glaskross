EntityListGUI = Class{}

function EntityListGUI:init(entities)
  self.gui_id = "entity_list"
end

function EntityListGUI:update(dt)
  
end

function EntityListGUI:draw()
  love.graphics.setColor(255, 255, 255, 255)
  local rowHeight = 20;
  local y = 50;
  local x = 20;
  love.graphics.print("ENTITIES", x, y)
  love.graphics.print("ID\tName", x, y + rowHeight)
  love.graphics.print("================", x, y + rowHeight * 2)
  local i = 1
  for _, entity in pairs(Entities.list()) do
    love.graphics.print(entity.id .. '\t' .. entity.type, x, y + rowHeight * (i + 2))
    i = i + 1
  end
end