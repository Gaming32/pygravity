import time

from pygravity import twod
from pygravity.twod import util


container = twod.GravityContainer()

sun = util.Body(container, twod.Vector2(0, 0), 1.9891e30, has_acceptor=False)
earth = util.Body(container, twod.Vector2(149.4e9, 0), 5.972e24, has_caster=False)
earth.physics.add_velocity_vector(twod.Vector2(0, -30000))


TIME_SCALE = 86400
# TIME_SCALE = 3600
try:
    day = 0
    while True:
        difference, _ = earth.step(TIME_SCALE)
        # difference, _ = earth_acceptor.calculate(TIME_SCALE)
        # earth_physics.calculate(TIME_SCALE)
        print(
            'Days: %i' % day,
            'Velocity: %d' % earth.physics.velocity.magnitude(),
            'Velocity Change: %f' % difference.magnitude(),
            'Distance: %d' % earth.position.magnitude(),
            'Position: %r' % earth.position,
        sep='     ', end='\r')
        time.sleep(.01)
        day += 1
except KeyboardInterrupt: print()
