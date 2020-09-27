from pygame import Rect, Surface
from pygame.constants import MOUSEBUTTONDOWN, QUIT
from pygravity import twod
import pygame


INT_LIMITS = 256 ** 4 // 2 - 1
GRAVITY_CONTAINER = twod.GravityContainer()


__all__ = ['Settings', 'Body', 'bodies', 'start_simulation']


class Settings:
    scale = 778125000
    time_scale = 1840000
    screen_size = (1280, 960)
    focus = None


class Camera:
    position = twod.Vector2()
    scale = Settings.scale


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
        time_passed *= Settings.time_scale
        if self.acceptor is not None:
            self.acceptor.calculate(time_passed)
        self.physics.calculate(time_passed)

    def render(self, surface: Surface):
        render_pos = self.get_render_position()
        if render_pos[0] < -INT_LIMITS or render_pos[0] > INT_LIMITS \
            or render_pos[1] < -INT_LIMITS or render_pos[1] > INT_LIMITS:
            return
        if not self.get_rect().colliderect(Rect((0, 0), Settings.screen_size)):
            return
        pygame.draw.circle(surface, self.visual_color, render_pos, self.get_radius())

    def get_radius(self):
        return int(self.visual_radius * Settings.scale / Camera.scale)

    def get_render_position(self):
        # render_pos = [c for c in self.position]
        # render_pos[0] = int(render_pos[0] + 640 * Camera.scale - Camera.position.x) // Camera.scale
        # render_pos[1] = int(480 - render_pos[1] * Camera.scale + Camera.position.y) // Camera.scale
        render_pos = list(self.position)
        # render_pos[0] //= Camera.scale
        render_pos[0] = (render_pos[0] - Camera.position.x) / Camera.scale + Settings.screen_size[0] / 2
        # render_pos[1] //= Camera.scale
        render_pos[1] = Settings.screen_size[1] / 2 - (render_pos[1] - Camera.position.y) / Camera.scale
        return [int(x) for x in render_pos]

    def get_rect(self):
        render_pos = self.get_render_position()
        return Rect(render_pos[0] - self.visual_radius,
                    render_pos[1] - self.visual_radius,
                    2 * self.visual_radius,
                    2 * self.visual_radius)


bodies = []


def start_simulation():
    Camera.scale = Settings.scale

    pygame.init()
    screen = pygame.display.set_mode(Settings.screen_size)

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
                            Settings.focus = body
                            break
                    else:
                        print('space')
                        Settings.focus = None
                        Camera.position.set_to(twod.Vector2())
                elif event.button == 4:
                    Camera.scale /= 1.5
                    print('zoom in:', Camera.scale)
                elif event.button == 5:
                    Camera.scale *= 1.5
                    print('zoom out:', Camera.scale)

        if Settings.focus is not None:
            Camera.position.set_to(Settings.focus.position)

        for body in reversed(bodies):
            body.update(0.02)

        screen.fill((0, 0, 0))

        for body in bodies:
            body.render(screen)

        pygame.display.update()
