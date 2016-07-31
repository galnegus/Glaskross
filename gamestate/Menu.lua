menu = {}

function menu:draw()
  love.graphics.print("YOU DEAD", 300, 300, 0, 5, 5)
end

function menu:keyreleased(key, code)
  if key == "return" or key == "escape" then
    Gamestate.switch(game)
  end
end