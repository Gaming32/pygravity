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
        cdef Vector2 newvel = self.velocity + velocity
        self.velocity.set_to(newvel.x, newvel.y)
        return self.velocity
    cpdef Vector2 calculate(self, double time_passed):
        "time_passed is in seconds\nupon completion PhysicsManager.position is updated mutably\nnew position is also returned"
        cdef Vector2 newpos = self.position + self.velocity * time_passed
        self.position.set_to(newpos.x, newpos.y)
        return self.position

__all__ = ['PhysicsManager']
