WasdComponent = Class{}
WasdComponent:include(Component)

function WasdComponent:init()
    self.type = "input"
end

function WasdComponent:setOwner(owner)
    Component.setOwner(self, owner)
end

function WasdComponent:update(dt)
    if love.keyboard.isDown("w") then
        self.owner.events:emit("set movement direction", "up")
    end
    if love.keyboard.isDown("a") then
        self.owner.events:emit("set movement direction", "left")
    end
    if love.keyboard.isDown("s") then
        self.owner.events:emit("set movement direction", "down")
    end
    if love.keyboard.isDown("d") then
        self.owner.events:emit("set movement direction", "right")
    end
end