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

__kernel void kernel_532(__global point3 * r)
{
    unsigned int id = get_global_id(0);
    __global point3 *retval_494 = &r[id];
    __global point3 *i = &r[id];
    point3 j = r[0];
    point3 diff = point_diff(*i, j);
    r[0] = diff;
    *retval_494 = r[0];
}
