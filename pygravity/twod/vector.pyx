cdef extern from "math.h":
    double sin(double x)
    double cos(double x)
    double atan(double x)
    double sqrt(double x)
    double M_PI

cdef double deg2rad(double x):
    return x * M_PI / 180
cdef double rad2deg(double x):
    return x * 180 / M_PI

class Vector2:
    def __init__(self, double x, double y):
        self.x = x
        self.y = y
    @classmethod
    def from_direction_magnitude(cls, double angle, double distance):
        return cls(cos(deg2rad(angle)) * distance, sin(deg2rad(angle)) * distance)
    def __repr__(self):
        return "%s(%f, %f)" % (self.__class__.__name__, self.x, self.y)
    def as_tuple(self):
        return (self.x, self.y)
    def as_direction_magnitude(self):
        return (rad2deg(atan(self.y/self.x)), sqrt(self.x**2 + self.y**2))
    def set(self, vector):
        self.x = vector.x
        self.y = vector.y

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
    def __div__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x / other.x, self.y / other.y)
        else:
            return Vector2(self.x / other, self.y / other)
    def __floordiv__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x // other.x, self.y // other.y)
        else:
            return Vector2(self.x // other, self.y // other)
    def __mod__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x % other.x, self.y % other.y)
        else:
            return Vector2(self.x % other, self.y % other)
    def __pow__(self, other):
        if isinstance(other, Vector2):
            return Vector2(self.x ** other.x, self.y ** other.y)
        else:
            return Vector2(self.x ** other, self.y ** other)
    def __neg__(self):
        return Vector2(-self.x, -self.y)
    def __pos__(self):
        return Vector2(+self.x, +self.y)
    def __abs__(self):
        return Vector2(abs(self.x), abs(self.y))
    def __nonzero__(self):
        return bool(self.x) and bool(self.y)

    def __iadd__(self, other):
        self.x += other.x
        self.y += other.y
    def __isub__(self, other):
        self.x -= other.x
        self.y -= other.y
    def __imul__(self, other):
        if isinstance(other, Vector2):
            self.x *= other.x
            self.y *= other.y
        else:
            self.x *= other
            self.y *= other
    def __idiv__(self, other):
        if isinstance(other, Vector2):
            self.x /= other.x
            self.y /= other.y
        else:
            self.x /= other
            self.y /= other
    def __ifloordiv__(self, other):
        if isinstance(other, Vector2):
            self.x //= other.x
            self.y //= other.y
        else:
            self.x //= other
            self.y //= other
    def __imod__(self, other):
        if isinstance(other, Vector2):
            self.x %= other.x
            self.y %= other.y
        else:
            self.x %= other
            self.y %= other
    def __ipow__(self, other):
        if isinstance(other, Vector2):
            self.x **= other.x
            self.y **= other.y
        else:
            self.x **= other
            self.y **= other

    def __len__(self):
        return 2
    def __getitem__(self, ix):
        return self.as_tuple[ix]
    def __contains__(self, value):
        return self.x == value or self.y == value