from pygravity import twod
from pygravity.twod.pygame_simulation import Settings, Body, bodies, start_simulation


sun = Body(twod.Vector2(0, 0), 1.9891e30, (255, 255, 0), 50)
bodies.append(sun)

earth = Body(twod.Vector2(149.4e9, 0), 5.972e24, (0, 0, 255), 10)
earth.physics.add_velocity_vector(twod.Vector2(0, -30000))
bodies.append(earth)

# gray_planet = Body(earth.position + twod.Vector2(0, -38250000), 7.34767309e22, (128, 128, 128), 5)
# gray_planet.physics.add_velocity_vector(earth.physics.velocity * 1.5 + twod.Vector2(1023, 0))
# bodies.append(gray_planet)

mars = Body(twod.Vector2(0, 2.1109e11), 6.39e23, (255, 88, 0), 7)
mars.physics.add_velocity_vector(twod.Vector2(24077, 0))
bodies.append(mars)

jupiter = Body(twod.Vector2(0, -7.6773e11), 1.898e27, (204, 153, 102), 25)
jupiter.physics.add_velocity_vector(twod.Vector2(-13070, 0))
bodies.append(jupiter)


human = Body(earth.position + twod.Vector2(6.371e6, 0), 70, (255, 128, 128), 3.21285141e-8)
bodies.append(human)


Settings.focus = human
Settings.time_scale = 1
start_simulation()
