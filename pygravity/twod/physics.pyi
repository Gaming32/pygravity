from pygravity.twod.vector import Vector2


class PhysicsManager:
    position: Vector2
    velocity: Vector2

    def __init__(position: Vector2, velocity: Vector2 = None): ...
    def add_velocity(self, x: float, y: float) -> None: ...
    def add_velocity_vector(self, velocity: Vector2) -> None: ...
    def calculate(self, time_passed: float) -> Vector2: ...
