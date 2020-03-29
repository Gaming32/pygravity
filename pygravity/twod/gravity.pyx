from ..math import acceleration_due_to_gravity
from .vector import Vector2
from .physics import PhysicsManager


cdef position_init(position):
    if not hasattr(position, 'x') or not hasattr(position, 'y'):
        if not isinstance(position, (list, tuple)):
            raise TypeError('position must be an instance of Vector2 or 2-tuple')
        elif len(position) < 2:
            raise TypeError('position tuple must be 2-tuple')
        else: position = Vector2(*position[:2])
    return position


class GravityContainer:
    __slots__ = ['casters']
    def __init__(self, *casters):
        self.casters = list(casters)
    def add_caster(self, caster):
        self.casters.append(caster)
    def add_casters(self, *casters):
        self.casters.extend(casters)
    def remove_caster(self, caster):
        for (i, test_caster) in enumerate(self.casters):
            if test_caster is caster:
                del self.casters[i]
                return test_caster
    def __len__(self): return len(self.casters)
    def __repr__(self):
        return '%s(%s)' % (self.__class__.__name__, ', '.join(repr(x) for x in self.casters))


class GravityCaster:
    __slots__ = ['position', 'mass']
    def __init__(self, position, double mass):
        self.position = position_init(position)
        self.mass = mass
    def __repr__(self):
        return '%s(%r, %f)' % (self.__class__.__name__, self.position, self.mass)


cdef acceptor_calculate_once(position, double time_passed, caster):
    relative_vector = caster.position - position
    relative_vector_direction = relative_vector.as_direction_magnitude()
    acceleration = acceleration_due_to_gravity(relative_vector_direction[1])
    return Vector2.from_direction_magnitude(relative_vector_direction[0], acceleration) * time_passed

class GravityAcceptor:
    __slots__ = ['position', 'container', 'physics_manager']
    def __init__(self, position, container, physics_manager):
        self.position = position_init(position)
        if not hasattr(container, 'casters'):
            raise TypeError('position must be an instance of GravityContainer')
        self.container = container
        if not hasattr(container, 'add_velocity_vector'):
            raise TypeError('physics_manager must be an instance of PhysicsManager')
        self.physics_manager = physics_manager
    def __repr__(self):
        return '%s(%r, %r)' % (self.__class__.__name__, self.position, self.container)
    def calculate(self, double time_passed):
        "time_passed is in seconds\nused velocity vector is returned"
        result = Vector2(0, 0)
        for caster in self.container.casters:
            result += acceptor_calculate_once(self.position, time_passed, caster)
        self.physics_manager.add_velocity_vector(result)
        return result


__all__ = ['GravityContainer', 'GravityCaster', 'GravityAcceptor']