"""An object to hold the current position and velocity of physics-enabled objects (2D pygravity)"""


from pygravity.twod.vector cimport Vector2


cdef class PhysicsManager:
    """PhysicsManager(position: Vector2, velocity: Vector2 = None)

An object to hold the current position and velocity of physics-enabled objects

Attributes
----------
positon: Vector2
    The current position of the physics-enabled object. It is mutable.
velocity: Vector2
    The current velocity of the physics-enabled object. It is mutable."""

    def __cinit__(self, Vector2 position, Vector2 velocity = None):
        if velocity is None:
            velocity = Vector2()
        self.position = position
        self.velocity = velocity

    cpdef add_velocity(self, double x, double y):
        """add_velocity(self, x: float, y: float) -> None

Adds the specified velocity to the object"""
        return self.add_velocity_vector(Vector2(x, y))

    cpdef add_velocity_vector(self, Vector2 velocity):
        """add_velocity_vector(self, velocity: Vector2) -> None

Same as add_velocity but uses a Vector2 instead of x and y amounts"""
        cdef Vector2 newvel = self.velocity + velocity
        self.velocity.set_to(newvel.x, newvel.y)
        return self.velocity

    cpdef Vector2 calculate(self, double time_passed):
        """calculate(self, time_passed: float) -> Vector2

Updates this object's position based on current velocity
The unit for time used anywhere in pygravity is seconds
This function returns the amount that the body moved (equal to self.velocity * time_passed)"""
        # """time_passed is in seconds
        # upon completion PhysicsManager.position is updated mutably
        # amount moved is also returned"""
        cdef Vector2 move_amount = self.velocity * time_passed
        cdef Vector2 newpos = self.position + move_amount
        self.position.set_to(newpos.x, newpos.y)
        return move_amount


__all__ = ['PhysicsManager']
