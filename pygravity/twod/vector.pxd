cdef class Vector2:
    cdef public double x, y
    cpdef as_tuple(self)
    cpdef direction(self)
    cpdef as_direction_magnitude(self)
    cpdef sqr_magnitude(self)
    cpdef magnitude(self)
    cpdef set_to(self, double x, double y)
    cpdef normalize(self)
