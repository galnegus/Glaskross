HPComponent = Class{}
HPComponent:include(Component)

function HPComponent:init(hp, hitSignal)
	assert(hp and hitSignal, "arguments missing")
	Component.init(self)

	self.type = ComponentTypes.HP

	self._hp = hp
	self._hitSignal = hitSignal
end

function HPComponent:setOwner(owner)
	Component.setOwner(self, owner)

	self.owner.events:register(self._hitSignal, function()
		self._hp = self._hp - 1
		if self._hp <= 0 then
			Signal.emit(Signals.KILL_ENTITY, self.owner.id)
		end
	end)
end