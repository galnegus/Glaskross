RenderComponent = Class{}
RenderComponent:include(Component)

function RenderComponent:init()
    self.type = "render"
end

function RenderComponent:setOwner(owner)
    self.owner = owner

    if owner.physics == nil then
        error("Entity: " .. owner.tag .. " requires a physics component.")
    end
end

function RenderComponent:update(dt)
    -- nada
end

function RenderComponent:draw()
    --self.owner.physics:draw()
    --love.graphics.draw(self.image, self.physicsComponent.body:getX(), self.physicsComponent.body:getY(), 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end