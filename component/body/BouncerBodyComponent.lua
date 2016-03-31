BouncerBodyComponent = Class{}
BouncerBodyComponent:include(VelocityRotatingBodyComponent)

function BouncerBodyComponent:init(options)
    VelocityRotatingBodyComponent.init(self, options, 5)
end

function BouncerBodyComponent:conception()
    VelocityRotatingBodyComponent.conception(self)
    
    -- create sword
    self._sword = EntityCreator.create(EntityTypes.BOUNCER_SWORD, self.owner)
    Signal.emit(Signals.ADD_ENTITY, self._sword)
end

function BouncerBodyComponent:death()
    Signal.emit(Signals.KILL_ENTITY, self._sword.id)

    VelocityRotatingBodyComponent.death(self)
end
