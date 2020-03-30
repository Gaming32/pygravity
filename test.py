from pygravity import twod
import time
container = twod.GravityContainer()
sun = twod.Vector2(0, 0)
sun
sun_caster = twod.GravityCaster(sun, 1.9891e30)
sun_caster
container.add_caster(sun_caster)
earth = twod.Vector2(149.4e9, 0)
earth
# help(twod.GravityAcceptor)
# help(twod.PhysicsManager)
earth_physics = twod.PhysicsManager(earth)
earth_acceptor = twod.GravityAcceptor(earth, container, earth_physics)
earth_acceptor
# earth_physics.add_velocity(0, 1e10)
TIME_SCALE = 86400
# TIME_SCALE = 3600
try:
    day = 0
    while True:
        difference = earth_acceptor.calculate(TIME_SCALE)
        earth_physics.calculate(TIME_SCALE)
        print(
            'Days: %i' % day,
            'Velocity: %d' % earth_physics.velocity.as_direction_magnitude()[1],
            'Velocity Change: %f' % difference.as_direction_magnitude()[1],
            'Distance: %d' % earth.as_direction_magnitude()[1],
            'Position: %r' % earth,
        sep='\t', end='\r')
        # time.sleep(.01)
        day += 1
except KeyboardInterrupt: print()