BouncerSwordRenderComponent = Class{}
BouncerSwordRenderComponent:include(RenderComponent)

function BouncerSwordRenderComponent:init(colour, birthDuration, deathDuration)
	RenderComponent.init(self, colour, 0, deathDuration, false)
end

function BouncerSwordRenderComponent:draw()
	self.owner.body:draw()
end