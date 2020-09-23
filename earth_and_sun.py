SCALE = 778125000
TIME_SCALE = 18400
TIME_SCALE = 1840000


from pygame import Surface
from pygame.constants import QUIT
from pygravity import twod
import pygame

GRAVITY_CONTAINER = twod.GravityContainer()

class Body:
    def __init__(self, position, mass, visual_color, visual_radius, has_caster=True, has_acceptor=True):
        self.position = position
        self.visual_color = visual_color
        self.visual_radius = visual_radius
        self.physics = twod.PhysicsManager(position)
        if has_caster:
            self.caster = twod.GravityCaster(position, mass)
            GRAVITY_CONTAINER.add_caster(self.caster)
        else: self.caster = None
        if has_acceptor:
            self.acceptor = twod.GravityAcceptor(position, GRAVITY_CONTAINER, self.physics)
        else: self.acceptor = None
    def update(self, time_passed):
        time_passed *= TIME_SCALE
        if self.acceptor is not None:
            self.acceptor.calculate(time_passed)
        self.physics.calculate(time_passed)
    def render(self, surface: Surface):
        render_pos = [int(c) for c in self.position / SCALE]
        render_pos[0] += 640
        render_pos[1] = 480 - render_pos[1]
        pygame.draw.circle(surface, self.visual_color, render_pos, self.visual_radius)

pygame.init()

screen = pygame.display.set_mode((1280, 960))

sun = Body(twod.Vector2(0, 0), 1.9891e30, (255, 255, 0), 50)

earth = Body(twod.Vector2(149.4e9, 0), 5.972e24, (0, 0, 255), 10)
earth.physics.add_velocity_vector(twod.Vector2(0, -30000))

moon = Body(earth.position + twod.Vector2(0, -38250000), 7.34767309e22, (128, 128, 128), 5)
moon.physics.add_velocity_vector(earth.physics.velocity + twod.Vector2(-5000, -5000))

clock = pygame.time.Clock()
while True:
    clock.tick(50)
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            exit()

    moon.update(0.02)
    earth.update(0.02)
    sun.update(0.02)

    screen.fill((0, 0, 0))

    sun.render(screen)
    earth.render(screen)
    moon.render(screen)

    pygame.display.update()
