SCALE = 778125000
TIME_SCALE = 18400
TIME_SCALE = 1840000


from pygame import Rect, Surface
from pygame.constants import MOUSEBUTTONDOWN, QUIT
from pygravity import twod
import pygame


GRAVITY_CONTAINER = twod.GravityContainer()
SCREEN_SIZE = (1280, 960)


class Camera:
    position = twod.Vector2()
    scale = SCALE

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
        if not self.get_rect().colliderect(Rect((0, 0), SCREEN_SIZE)):
            return
        pygame.draw.circle(surface, self.visual_color, self.get_render_position(), self.get_radius())

    def get_radius(self):
        return int(self.visual_radius * SCALE / Camera.scale)

    def get_render_position(self):
        # render_pos = [c for c in self.position]
        # render_pos[0] = int(render_pos[0] + 640 * Camera.scale - Camera.position.x) // Camera.scale
        # render_pos[1] = int(480 - render_pos[1] * Camera.scale + Camera.position.y) // Camera.scale
        render_pos = list(self.position)
        # render_pos[0] //= Camera.scale
        render_pos[0] = (render_pos[0] - Camera.position.x) / Camera.scale + SCREEN_SIZE[0] / 2
        # render_pos[1] //= Camera.scale
        render_pos[1] = SCREEN_SIZE[1] / 2 - (render_pos[1] - Camera.position.y) / Camera.scale
        return [int(x) for x in render_pos]

    def get_rect(self):
        render_pos = self.get_render_position()
        return Rect(render_pos[0] - self.visual_radius,
                    render_pos[1] - self.visual_radius,
                    2 * self.visual_radius,
                    2 * self.visual_radius)


pygame.init()

screen = pygame.display.set_mode(SCREEN_SIZE)


sun = Body(twod.Vector2(0, 0), 1.9891e30, (255, 255, 0), 50)

earth = Body(twod.Vector2(149.4e9, 0), 5.972e24, (0, 0, 255), 10)
earth.physics.add_velocity_vector(twod.Vector2(0, -30000))

gray_planet = Body(earth.position + twod.Vector2(0, -38250000), 7.34767309e22, (128, 128, 128), 5)
gray_planet.physics.add_velocity_vector(earth.physics.velocity * 1.5 + twod.Vector2(1023, 0))


jupiter = Body(twod.Vector2(0, -7.6773e11), 1.898e27)


bodies = [sun, earth, gray_planet]

focus = None


clock = pygame.time.Clock()
while True:
    clock.tick(50)
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            exit()
        elif event.type == MOUSEBUTTONDOWN:
            if event.button == 1:
                print('mouse click:', end=' ')
                for body in bodies:
                    if body.get_rect().collidepoint(*event.pos):
                        print(body)
                        focus = body
                        break
                else:
                    print('space')
                    focus = None
                    Camera.position.set_to(twod.Vector2())
            elif event.button == 4:
                Camera.scale /= 1.5
                print('zoom in:', Camera.scale)
            elif event.button == 5:
                Camera.scale *= 1.5
                print('zoom out:', Camera.scale)

    if focus is not None:
        Camera.position.set_to(focus.position)

    for body in reversed(bodies):
        body.update(0.02)

    screen.fill((0, 0, 0))

    for body in bodies:
        body.render(screen)

    pygame.display.update()
