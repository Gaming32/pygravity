cdef extern from "math.h":
    # double sin(double x)
    # double cos(double x)
    # double atan(double x)
    # double atan2(double x, double y)
    # double sqrt(double x)
    double M_PI

from libc.math cimport sin, cos, atan2, sqrt

cdef double deg2rad(double x):
    return x * M_PI / 180
cdef double rad2deg(double x):
    return x * 180 / M_PI

cdef class Vector2:
    def __cinit__(self, double x = 0, double y = 0):
        self.x = x
        self.y = y
    @classmethod
    def from_direction_magnitude(cls, double angle, double distance):
        return cls(cos(deg2rad(angle)) * distance, sin(deg2rad(angle)) * distance)
    def __repr__(self):
        return "%s(%f, %f)" % (self.__class__.__name__, self.x, self.y)
    cpdef as_tuple(self):
        return (self.x, self.y)
    cpdef direction(self):
        return rad2deg(atan2(self.y, self.x))
    cpdef as_direction_magnitude(self):
        return self.direction(), self.magnitude()
        # cdef double direction
        # direction = rad2deg(atan(self.y/self.x))
        # if self.x < 0:
        #     direction += 180
        # elif self.y < 0:
        #     direction += 360
        # return (direction % 360, sqrt(self.x**2 + self.y**2))
    cpdef sqr_magnitude(self):
        return self.x**2 + self.y**2
    cpdef magnitude(self):
        return sqrt(self.sqr_magnitude())
    cpdef set_to(self, vector):
        self.x = vector.x
        self.y = vector.y
    cpdef normalize(self):
        cdef double magnitude = self.magnitude()
        if magnitude > 0:
            self.set_to(self / magnitude)

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    def __ne__(self, other):
        return self.x != other.x and self.y != other.y
    def __lt__(self, other):
        return self.x < other.x or self.y < other.y
    def __gt__(self, other):
        return self.x > other.x or self.y > other.y
    def __le__(self, other):
        return self.x <= other.x or self.y <= other.y
    def __ge__(self, other):
        return self.x >= other.x or self.y >= other.y

    def __add__(self, other):
        return Vector2(self.x + other.x, self.y + other.y)
    def __sub__(self, other):
        return Vector2(self.x - other.x, self.y - other.y)
    def __mul__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x * other.x, self.y * other.y)
        else:
            return Vector2(self.x * other, self.y * other)
    def __rmul__(other, self):
        return Vector2.__mul__(self, other)
    def __div__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x / other.x, self.y / other.y)
        else:
            return Vector2(self.x / other, self.y / other)
    def __rdiv__(other, self):
        return Vector2.__div__(self, other)
    def __floordiv__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x // other.x, self.y // other.y)
        else:
            return Vector2(self.x // other, self.y // other)
    def __rfloordiv__(other, self):
        return Vector2.__floordiv__(self, other)
    def __truediv__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x / other.x, self.y / other.y)
        else:
            return Vector2(self.x / other, self.y / other)
    def __rtruediv__(other, self):
        return Vector2.__truediv__(self, other)
    def __mod__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x % other.x, self.y % other.y)
        else:
            return Vector2(self.x % other, self.y % other)
    def __rmod__(other, self):
        return Vector2.__mod__(self, other)
    def __pow__(self, other, modulus):
        if modulus is None:
            if isinstance(other, Vector2):
                return Vector2(self.x ** other.x, self.y ** other.y)
            else:
                return Vector2(self.x ** other, self.y ** other)
        else:
            if isinstance(other, Vector2):
                return Vector2(self.x ** other.x, self.y ** other.y) % modulus
            else:
                return Vector2(self.x ** other, self.y ** other) % modulus
    def __neg__(self):
        return Vector2(-self.x, -self.y)
    def __pos__(self):
        return Vector2(+self.x, +self.y)
    def __abs__(self):
        return Vector2(abs(self.x), abs(self.y))
    def __nonzero__(self):
        return bool(self.x) and bool(self.y)

    def __len__(self):
        return 2
    def __getitem__(self, ix):
        return self.as_tuple()[ix]
    def __contains__(self, value):
        return self.x == value or self.y == value


__all__ = ['Vector2']
