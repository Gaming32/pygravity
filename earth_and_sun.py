import pygame
from pygame.event import Event
from pygame.locals import *

from pygravity import twod
from pygravity.twod.pygame_simulation import Settings, Body, bodies, register_event_handler, start_simulation, create_surface_from_capture
from pygravity.twod.util import BodyWithMetadata, capture_simulation


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


# space_farer = Body(earth.position + twod.Vector2(7781250000, 0), 75, (255, 128, 128), .5)
# bodies.append(space_farer)

# pressed_keys = set()

# planets = [earth, mars, jupiter]

# MOVEMENT_SPEED = 100000000
# def move_player(event: Event = None):
#     if event is None:
#         nearest_planet = min(planets, key=(lambda planet: (space_farer.position - planet.position).sqr_magnitude()))
#         relative_position = space_farer.position - nearest_planet.position
#         direction, magnitude = relative_position.as_direction_magnitude()
#         print(magnitude / 1000, 'kilometers to the nearest planet', end='\r')

#         if K_a in pressed_keys:
#             space_farer.physics.add_velocity(-MOVEMENT_SPEED / Settings.time_scale, 0)
#         if K_d in pressed_keys:
#             space_farer.physics.add_velocity(MOVEMENT_SPEED / Settings.time_scale, 0)
#         if K_w in pressed_keys:
#             space_farer.physics.add_velocity(0, MOVEMENT_SPEED / Settings.time_scale)
#         if K_s in pressed_keys:
#             space_farer.physics.add_velocity(0, -MOVEMENT_SPEED / Settings.time_scale)
#         # if K_a in pressed_keys:
#         #     # Move left
#         #     space_farer.physics.add_velocity_vector(twod.Vector2.from_direction_magnitude(direction + 90, 100000000 / Settings.time_scale))
#         # if K_d in pressed_keys:
#         #     # Move right
#         #     space_farer.physics.add_velocity_vector(twod.Vector2.from_direction_magnitude(direction - 90, 100000000 / Settings.time_scale))

#         # relative_position.set_to(twod.Vector2.from_direction_magnitude(direction, magnitude))
#         # space_farer.position.set_to(nearest_planet.position + relative_position)
#     else:
#         if event.type == KEYDOWN:
#             pressed_keys.add(event.key)
#         elif event.type == KEYUP:
#             pressed_keys.remove(event.key)


# register_event_handler(move_player, None, KEYDOWN, KEYUP)
# # Settings.time_scale = 1
# Settings.time_scale /= 5
# Settings.focus = space_farer
# start_simulation()

sun_meta = BodyWithMetadata(sun, 'sun', 6.9634e8, sun.visual_color)
earth_meta = BodyWithMetadata(earth, 'earth', 6.371e6, earth.visual_color)
mars_meta = BodyWithMetadata(mars, 'mars', 3.3895e6, mars.visual_color)
jupiter_meta = BodyWithMetadata(jupiter, 'jupiter', 6.9911e7, jupiter.visual_color)

print('Running...')
result = capture_simulation([sun_meta, earth_meta, mars_meta, jupiter_meta], step_distance=Settings.time_scale, focus=sun, step_count=100)
print('Done:')

import json, tempfile
output = f'simulation_{tempfile.mktemp(prefix="", dir="")}'
output_json = output + '.json'
with open(output_json, 'w') as fp:
    json.dump(result, fp)
print('    Output json written to:', output_json)

output_png = output + '.png'
Settings.screen_size = tuple(x * 2 for x in Settings.screen_size)
Settings.scale /= 2
surface = create_surface_from_capture(result)
pygame.image.save(surface, output_png)
print('    Output png written to:', output_png)
