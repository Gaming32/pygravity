from ..math import acceleration_due_to_gravity
from .vector import Vector2


cdef location_init(location):
    if not hasattr(location, 'x') or not hasattr(location, 'y'):
        if not isinstance(location, (list, tuple)):
            raise TypeError('location must be an instance of Vector2 or 2-tuple')
        elif len(location) < 2:
            raise TypeError('location tuple must be 2-tuple')
        else: location = Vector2(*location[:2])
    return location


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
    __slots__ = ['location', 'mass']
    def __init__(self, location, double mass):
        self.location = location_init(location)
        self.mass = mass
    def __repr__(self):
        return '%s(%r, %f)' % (self.__class__.__name__, self.location, self.mass)


class GravityAcceptor:
    __slots__ = ['location', 'container']
    def __init__(self, location, container):
        self.location = location_init
        if not hasattr(container, 'casters') or not hasattr(container, '__len__'):
            raise TypeError('location must be an instance of GravityContainer')
        self.container = container
    def __repr__(self):
        return '%s(%r, %r)' % (self.__class__.__name__, self.location, self.container)