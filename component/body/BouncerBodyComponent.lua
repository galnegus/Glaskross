BouncerBodyComponent = Class{}
BouncerBodyComponent:include(BodyComponent)

function BouncerBodyComponent:init(options)
    BodyComponent.init(self, options)
end

function BouncerBodyComponent:conception()
    BodyComponent.conception(self)
    
    -- create sword
    self._sword = EntityCreator.create(EntityTypes.BOUNCER_SWORD, self.owner)
    Signal.emit(Signals.ADD_ENTITY, self._sword)
end

function BouncerBodyComponent:death()
    Signal.emit(Signals.KILL_ENTITY, self._sword.id)

    BodyComponent.death(self)
end
