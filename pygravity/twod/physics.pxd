from pygravity.twod.vector cimport Vector2


cdef class PhysicsManager:
    cdef public Vector2 position, velocity
    cpdef add_velocity(self, double x, double y)
    cpdef add_velocity_vector(self, Vector2 velocity)
    cpdef Vector2 calculate(self, double time_passed)
