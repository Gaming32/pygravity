from .vector import Vector2

class PhysicsManager:
    __slots__ = ['position', 'velocity']
    def __init__(self, position, velocity=Vector2(0, 0)):
        self.position = position
        self.velocity = velocity
    def add_velocity(self, double x, double y):
        return self.add_velocity_vector(Vector2(x, y))
    def add_velocity_vector(self, velocity):
        self.velocity.set_to(self.velocity + velocity)
        return self.velocity
    def calculate(self, double time_passed) -> Vector2:
        "time_passed is in seconds\nupon completion PhysicsManager.position is updated mutably\nnew position is also returned"
        self.position.set_to(self.position + self.velocity * time_passed)
        return self.position

__all__ = ['PhysicsManager']