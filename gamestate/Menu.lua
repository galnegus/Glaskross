menu = {}

function menu:init()
  local vt323 = love.graphics.newFont("assets/fonts/VT323/VT323-Regular.ttf", 60)

  self._menuItems = {}
  table.insert(self._menuItems, love.graphics.newText(vt323, "start"))
  table.insert(self._menuItems, love.graphics.newText(vt323, "exit"))
end

function menu:draw()
  for i, text in ipairs(self._menuItems) do
    love.graphics.draw(text, 200, 100 + i * 100)
  end
end

function menu:keyreleased(key, code)
  if key == "return" or key == "escape" then
    Gamestate.switch(game)
  end
end