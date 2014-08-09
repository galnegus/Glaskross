Class = require "hump.class"
require 'component.Component'

RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init(physicsComponent)
    self.type = "render"
    self.physicsComponent = physicsComponent
end

function RenderComponent:update(dt)
    -- nada
end

function RenderComponent:draw()
    physicsComponent:draw()
    --love.graphics.draw(self.image, self.physicsComponent.body:getX(), self.physicsComponent.body:getY(), 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end