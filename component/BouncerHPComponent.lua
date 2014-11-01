BouncerHPComponent = Class{}
BouncerHPComponent:include(Component)

function BouncerHPComponent:init()
	Component.init(self)

	self.type = ComponentTypes.HP

	self._hp = Constants.BOUNCER_HP
end

function BouncerHPComponent:setOwner(owner)
	Component.setOwner(self, owner)

	self.owner.events:register(Signals.BOUNCER_HIT, function()
		self._hp = self._hp - 1
		if self._hp <= 0 then
			Signal.emit(Signals.KILL_ENTITY, self.owner.id)
		end
	end)
end