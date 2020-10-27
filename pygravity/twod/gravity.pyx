"""Generic 2D gravity related classes for pygravity"""


from pygravity.math cimport acceleration_due_to_gravity_squared
from pygravity.twod.vector cimport Vector2
from pygravity.twod.physics cimport PhysicsManager


cdef class GravityContainer:
    """GravityContainer(*casters: GravityCaster)

List optimized for GravityCaster objects
    
Attributes
----------
casters : list[GravityCaster]"""

    cdef readonly list casters

    def __cinit__(self, *casters):
        self.casters = list(casters)

    cpdef add_caster(self, GravityCaster caster):
        """add_caster(self, caster: GravityCaster) -> None

Adds a caster to this containter"""
        self.casters.append(caster)

    cdef add_caster_list(self, list casters):
        self.casters.extend(casters)

    def add_casters(self, *casters):
        """add_casters(self, *casters: GravityCaster) -> None

Adds multiple casters to this container (potentially slower than add_caster)"""
        self.casters.extend(casters)

    cpdef remove_caster(self, GravityCaster caster):
        """remove_caster(self, caster: GravityCaster) -> GravityCaster

Removes the specified caster from this container and returns it"""
        cdef int i
        cdef GravityCaster test_caster
        for (i, test_caster) in enumerate(self.casters):
            if test_caster is caster:
                del self.casters[i]
                return test_caster

    def __iter__(self):
        return iter(self.casters)

    def __len__(self): return len(self.casters)

    def __repr__(self):
        return '%s(%s)' % (self.__class__.__name__, ', '.join(repr(x) for x in self.casters))


cdef class GravityCaster:
    """GravityCaster(position: Vector2, mass: float)
    
Represents a spatial body that can pull on other spatial bodies

Attributes
----------
position : Vector2
    The current position of the body (in meters)
mass : float
    The mass of the body (in kilograms)"""

    cdef public Vector2 position
    cdef public double mass

    def __cinit__(self, Vector2 position, double mass):
        self.position = position
        self.mass = mass

    def __repr__(self):
        return '%s(%r, %f)' % (self.__class__.__name__, self.position, self.mass)


cdef Vector2 acceptor_calculate_once(Vector2 position, double time_passed, GravityCaster caster):
    cdef Vector2 relative_vector
    cdef tuple relative_vector_direction
    cdef double direction, distance, acceleration

    relative_vector = caster.position - position
    relative_vector_direction = relative_vector.as_direction_magnitude()
    direction = relative_vector.direction()
    distance_squared = relative_vector.sqr_magnitude()

    if distance_squared == 0:
        return relative_vector

    acceleration = acceleration_due_to_gravity_squared(caster.mass, distance_squared)
    return Vector2.from_direction_magnitude(direction, acceleration) * time_passed


cdef class GravityAcceptor:
    """GravityAcceptor(position: Vector2, container: GravityContainer, physics_manager: PhysicsManager)

Represents a body that can get pulled on by other spatial bodies

Attributes
----------
position : Vector2
    The current position of the body (in meters)
container : GravityContainer
    The container with GravityCasters that can pull on this body
physics_manager : PhysicsManager
    The manager to which to add calculated velocity to"""

    cdef public Vector2 position
    cdef public GravityContainer container
    cdef public PhysicsManager physics_manager

    def __cinit__(self, Vector2 position, GravityContainer container, PhysicsManager physics_manager):
        self.position = position
        self.container = container
        self.physics_manager = physics_manager

    def __repr__(self):
        return '%s(%r, %r)' % (self.__class__.__name__, self.position, self.container)

    cpdef Vector2 calculate(self, double time_passed):
        """calculate(self, time_passed: float) -> Vector2

Calculates the things that happened to this body within time_passed
The unit for time_passed is seconds
This function returns the velocity that was applied to this body"""
        # "time_passed is in seconds
        # used velocity vector is returned"
        cdef Vector2 result = Vector2()
        for caster in self.container.casters:
            result += acceptor_calculate_once(self.position, time_passed, caster)
        self.physics_manager.add_velocity_vector(result)
        return result


__all__ = ['GravityContainer', 'GravityCaster', 'GravityAcceptor']
