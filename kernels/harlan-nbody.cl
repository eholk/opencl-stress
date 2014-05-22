/* -*- c -*- */

typedef unsigned int region_ptr;

// We use our own bool type because OpenCL doesn't let you pass bools
// between host and kernel code.
typedef int bool_t;

// This is mostly opaque to the GPU.
struct region_ {
    unsigned int magic;

    // Size of this header + the stuff
    unsigned int size;

    // This is the next thing to allocate
    volatile region_ptr alloc_ptr;

    // This is actually a cl_mem
    void *cl_buffer;
};

#define region struct region_

// Extract the tag from an ADT
#define extract_tag(x) ((x).tag)


// This gives us a pointer to something in a region.
#define get_region_ptr(r, i) (((char __global *)r) + i)

typedef unsigned long uint64_t;

typedef struct {
    int tag;
    union {
    struct {
    float f0;
    float f1;
    float f2;
} point3;
} data;
} point3_t_79 ;

point3_t_79 point3(float point3_456, float point3_455, float point3_454);

point3_t_79 point$ddiff(point3_t_79 x_19_135, point3_t_79 y_18_134);

point3_t_79 point$ddiv(point3_t_79 a_35_122, float y_34_121);

float point$dmag(point3_t_79 p_39_117);

point3_t_79 point3(float point3_456, float point3_455, float point3_454) {
    {
        point3_t_79 result_457 = {0};
        result_457.data.point3.f0 = point3_456;
        result_457.data.point3.f1 = point3_455;
        result_457.data.point3.f2 = point3_454;
        result_457.tag = 0;
        return result_457;
    }
}

point3_t_79 point$ddiff(point3_t_79 x_19_135, point3_t_79 y_18_134) {
    {
        point3_t_79 m_449 = x_19_135;
        point3_t_79 m_447 = y_18_134;
        float a_22_138 = m_449.data.point3.f0;
        float b_21_137 = m_449.data.point3.f1;
        float c_20_136 = m_449.data.point3.f2;
        float d_25_141 = m_447.data.point3.f0;
        float e_24_140 = m_447.data.point3.f1;
        float f_23_139 = m_447.data.point3.f2;
        return point3((a_22_138) - (d_25_141), (b_21_137) - (e_24_140), (c_20_136) - (f_23_139));
    }
}

point3_t_79 point$ddiv(point3_t_79 a_35_122, float y_34_121) {
    {
        point3_t_79 m_441 = a_35_122;
        float a_38_125 = m_441.data.point3.f0;
        float b_37_124 = m_441.data.point3.f1;
        float c_36_123 = m_441.data.point3.f2;
        return point3((a_38_125) / (y_34_121), (b_37_124) / (y_34_121), (c_36_123) / (y_34_121));
    }
}

float point$dmag(point3_t_79 p_39_117) {
    point3_t_79 m_439 = p_39_117;
    float a_42_120 = m_439.data.point3.f0;
    float b_41_119 = m_439.data.point3.f1;
    float c_40_118 = m_439.data.point3.f2;
    return sqrt(((a_42_120) * (a_42_120)) + (((b_41_119) * (b_41_119)) + ((c_40_118) * (c_40_118))));
}

__kernel void kernel_532(region_ptr kern_490,
                         region_ptr ktemp_467,
                         region_ptr bodies_43_85,
                         region_ptr j_46_88,
                         int stride_45_87,
                         __global void * rk_299_536)
{
    __global region * r = ((__global region *)(rk_299_536));
        __global point3_t_79 * retval_494 = (&(((__global point3_t_79 *)(get_region_ptr(r, (kern_490) + (8))))[get_global_id(0)]));
        __global point3_t_79 * i_44_86 = (&(((__global point3_t_79 *)(get_region_ptr(r, (ktemp_467) + (8))))[get_global_id(0)]));
        point3_t_79 if_res_514;
        if((*((__global int *)(get_region_ptr(r, j_46_88)))) >= 0)
            {
                region_ptr j_58_89 = bodies_43_85;
                for(int i_485 = 0; i_485 < stride_45_87; i_485= (i_485 + 1))
                    {
                        int i_59_90 = i_485;
                        point3_t_79 j_60_91 = ((__global point3_t_79 *)(get_region_ptr(r, (j_58_89) + (8))))[i_59_90];
                        point3_t_79 diff_61_92 = point$ddiff(*i_44_86, j_60_91);
                        float d_62_93 = point$dmag(diff_61_92);
                        point3_t_79 if_res_517;
                        if_res_517 = point$ddiv(diff_61_92, ((d_62_93) * (d_62_93)) * (d_62_93));
                        point3_t_79 t_63_94 = if_res_517;
                        ((__global point3_t_79 *)(get_region_ptr(r, 8)))[i_485] = t_63_94;
                    }
                region_ptr x_70_101 = 0;
                region_ptr vec_472 = x_70_101;
                int refindex_473 = 0;
                point3_t_79 t_71_102 = ((__global point3_t_79 *)(get_region_ptr(r, (vec_472) + (8))))[refindex_473];
                if_res_514 = t_71_102;
            }
        *retval_494 = if_res_514;
}
