local Class = require "lib.hump.Class"
local Component = require "component.Component"
local Colors = require "constants.Colors"

local RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init(color, birthDuration, deathDuration, border)
  assert(color and birthDuration and deathDuration and border ~= nil, "arguments missing")
  Component.init(self)

  self.type = "render"

  self._renderable = true

  self._color = color or Colors.DEFAULT_RENDER
  self._alpha = self._color:alpha()

  self._border = border
  self._birthDuration = birthDuration
  self._deathDuration = deathDuration
  self._dying = false
  self._dead = false
end

function RenderComponent:setOwner(owner)
  self.owner = owner

  if owner.body == nil then
    error("Entity: " .. owner.tag .. " requires a body component.")
  end
end

function RenderComponent:color()
  return self._color:r(), self._color:g(), self._color:b(), self._alpha
end

function RenderComponent:conception()
  if self._birthDuration > 0 then
    local alpha = self._alpha
    self._alpha = 0
    game.timer:tween(self._birthDuration, self, {_alpha = alpha}, 'in-out-sine', function()
      Component.conception(self)
    end)
  else
    Component.conception(self)
  end
end

function RenderComponent:death()
  self._dying = true

  game.timer:tween(self._deathDuration, self, {_alpha = 0}, 'in-out-sine', function() Component.death(self) end)    
end

function RenderComponent:draw()
  local alpha = self._alpha

  if self._border then
    alpha = alpha / 10
  end

  love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), alpha)
  self.owner.body:draw("fill")

  if self._border then
    love.graphics.setColor(self._color:r(), self._color:g(), self._color:b(), self._alpha)
    self.owner.body:draw("line")
  end
end

return RenderComponent
