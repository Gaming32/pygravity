from pygravity.twod.vector cimport Vector2

cdef class PhysicsManager:
    def __cinit__(self, Vector2 position, Vector2 velocity = None):
        if velocity is None:
            velocity = Vector2(0, 0)
        self.position = position
        self.velocity = velocity
    cpdef add_velocity(self, double x, double y):
        return self.add_velocity_vector(Vector2(x, y))
    cpdef add_velocity_vector(self, Vector2 velocity):
        self.velocity.set_to(self.velocity + velocity)
        return self.velocity
    cpdef Vector2 calculate(self, double time_passed):
        "time_passed is in seconds\nupon completion PhysicsManager.position is updated mutably\nnew position is also returned"
        self.position.set_to(self.position + self.velocity * time_passed)
        return self.position

__all__ = ['PhysicsManager']
