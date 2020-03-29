SCALE = 373500000000
TIME_SCALE = 18400


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

pygame.init()

