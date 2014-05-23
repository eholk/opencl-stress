/* -*- c -*- */

typedef struct {
    float f0;
} point3;

point3 point_diff(point3 x, point3 y);
point3 point_diff(point3 x, point3 y) {
    point3 result;
    result.f0 = x.f0 - y.f0;
    return result;
}

__kernel void foo(__global point3 * r)
{
    *r = point_diff(*r, *r);
}
