menu = {}

function menu:init()
  local vt323 = love.graphics.newFont("assets/fonts/VT323/VT323-Regular.ttf", 60)

  self._menuList = MenuList()
  self._menuList:add("START", function() Gamestate.switch(game) end)
  self._menuList:add("HIGH SCORE", function() print("not yet") end)
  self._menuList:add("OPTIONS", function() print("wip") end)
  self._menuList:add("EXIT", function() love.event.quit() end)
  self._menuList:select(1)

  self.world = World(love.graphics.getWidth() + Constants.TILE_SIZE, love.graphics.getHeight() + Constants.TILE_SIZE, Constants.TILE_SIZE)
end

function menu:update(dt)
  self.world:update(dt)
  self._menuList:update(dt)
end

function menu:draw()  
  love.graphics.reset()
  --love.graphics.setCanvas(canvas)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.clear()
    self.world:draw()
    self._menuList:draw(200, self._menuList:yPosition())

    love.graphics.setColor(r, g, b, a)
  --love.graphics.setCanvas()

  --love.graphics.setShader(shader)
    --love.graphics.draw(canvas)
  --love.graphics.setShader()

end

function menu:keypressed(key, scancode, isrepeat)
  if key == "down" then
    self._menuList:down()
  elseif key == "up" then
    self._menuList:up()
  elseif key == "return" then
    self._menuList:press()
  end
end

function menu:keyreleased(key, scancode, isrepeat)
  --self._menuList:keyreleased(key, scancode, isrepeat)
end