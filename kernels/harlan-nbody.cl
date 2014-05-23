/* -*- c -*- */

// This gives us a pointer to something in a region.
#define get_region_ptr(r, i) (r + i)

typedef struct {
    float f0;
    float f1;
    float f2;
} point3_t_79;

point3_t_79 point$ddiff(point3_t_79 x, point3_t_79 y) {
    point3_t_79 result = {0};
    result.f0 = x.f0 - y.f0;
    result.f1 = x.f1 - y.f1;
    result.f2 = x.f2 - y.f2;
    return result;
}

__kernel void kernel_532(unsigned int kern_490,
                         unsigned int ktemp_467,
                         unsigned int bodies_43_85,
                         unsigned int j_46_88,
                         int stride_45_87,
                         __global char * r)
{
    __global point3_t_79 * retval_494 = (&(((__global point3_t_79 *)(get_region_ptr(r, (kern_490) + (8))))[get_global_id(0)]));
    __global point3_t_79 * i_44_86 = (&(((__global point3_t_79 *)(get_region_ptr(r, (ktemp_467) + (8))))[get_global_id(0)]));
    point3_t_79 j_60_91 = ((__global point3_t_79 *)(get_region_ptr(r, (bodies_43_85) + (8))))[0];
    point3_t_79 diff = point$ddiff(*i_44_86, j_60_91);
    ((__global point3_t_79 *)(get_region_ptr(r, 8)))[0] = diff;
    *retval_494 = ((__global point3_t_79 *)(get_region_ptr(r, 8)))[0];
}
