BoxyBackgroundComponent = Class{}
BoxyBackgroundComponent:include(Component)

function BoxyBackgroundComponent:init()
    self.type = "background"
end

function BoxyBackgroundComponent:setOwner(owner)
    self.owner = owner
end

function BoxyBackgroundComponent:update(dt)
    -- nada
end

function BoxyBackgroundComponent:bgDraw()
    --love.graphics.setColor(255, 120, 120, 50)
    --love.graphics.rectangle("fill", 200, 200, 300, 300)
end