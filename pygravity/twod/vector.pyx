"""Vector2 implementation used by pygravity"""

cdef extern from "math.h":
    double M_PI

from libc.math cimport sin, cos, atan2, sqrt


cdef inline double deg2rad(double x):
    return x * M_PI / 180

cdef inline double rad2deg(double x):
    return x * 180 / M_PI


cdef class Vector2:
    """Vector2(x: float = 0, y: float = 0) -> Vector2

Attributes
----------
x : float
    The X coordinate.
y : float
    The Y coordinate."""

    def __cinit__(self, double x = 0, double y = 0):
        self.x = x
        self.y = y

    @classmethod
    def from_direction_magnitude(cls, double angle, double distance):
        """from_direction_magnitude(cls, angle: float, distance: float) -> Vector2

Create a vector from an angle and length. Angle is in degrees."""
        return cls(cos(deg2rad(angle)) * distance, sin(deg2rad(angle)) * distance)

    def __repr__(self):
        return "%s(%f, %f)" % (self.__class__.__name__, self.x, self.y)

    cpdef as_tuple(self):
        """as_tuple(self) -> Tuple[float, float]

Return (self.x, self.y)"""
        return (self.x, self.y)

    cpdef direction(self):
        """direction(self) -> float

Return the direction this vector is facing (in degrees)"""
        return rad2deg(atan2(self.y, self.x))

    cpdef as_direction_magnitude(self):
        """as_direction_magnitude(self) -> Tuple[float, float]

Return (self.direction(), self.magnitude())"""
        return self.direction(), self.magnitude()

    cpdef sqr_magnitude(self):
        """sqr_magnitude(self) -> float

Return the square of this vector's magnitude.
This is faster to compute because the square root doesn't have to calculated."""
        return self.x**2 + self.y**2

    cpdef magnitude(self):
        """magnitude(self) -> float

Return this vector's magnitude"""
        return sqrt(self.sqr_magnitude())

    cpdef set_to(self, double x, double y):
        """set_to(self, x: float, y: float) -> None

Mutably update this vector's x and y coordinates to x and y, respectively"""
        self.x = x
        self.y = y

    cpdef normalize(self):
        """normalize(self) -> None

Mutably normalize this vector so it has a length of 0,
while keeping the same direction"""
        cdef double direction = self.direction()
        self.set_to(cos(deg2rad(direction)), sin(deg2rad(direction)))

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
