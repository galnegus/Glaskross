HealthBar = Class {}

function HealthBar:init()
  self.gui_id = "healthbar"

  self._health = 1 -- between 0 and 1

  self._x = 5
  self._y = 5
  self._width = love.graphics.getWidth() - self._x - 5
  self._height = 30
end

function HealthBar:update(dt)
  if self._health > 0 then
    self._health = self._health - 0.01 * dt
    if self._health < 0 then
      self._health = 0
    end
  end
end

function HealthBar:draw()
  local width = self._health * self._width
  local blue = self._health * 200
  local green = self._health * 200

  love.graphics.setColor(200, green, blue, 255)
  love.graphics.rectangle("fill", self._x, self._y, width, self._height)
end