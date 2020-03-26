cdef extern from "math.h":
    float sin(float x)
    float cos(float x)
    float atan(float x)
    float sqrt(float x)

class Vector2:
    def __init__(self, float x, float y):
        self.x = x
        self.y = y
    @classmethod
    def from_direction_magnitude(cls, float angle, float distance):
        return cls(sin(angle) * distance, cos(angle) * distance)
    def __repr__(self):
        return "%s(%d, %d)" % (self.__class__.__name__, self.x, self.y)
    def as_tuple(self):
        return (self.x, self.y)
    def as_direction_magnitude(self):
        "not yet working"
        return (atan(self.y/self.x), sqrt(self.x**2 + self.y**2))