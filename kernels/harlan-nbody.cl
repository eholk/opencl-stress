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


#define harlan_sqrt(x) (sqrt(((float)(x))))

// This gives us a pointer to something in a region.
#define get_region_ptr(r, i) (((char __global *)r) + i)

typedef unsigned long uint64_t;

region_ptr alloc_in_region(region __global *r, unsigned int size);
region_ptr alloc_in_region(region __global *r, unsigned int size)
{
    // region_ptr p = r->alloc_ptr;
    // r->alloc_ptr += size;
    region_ptr p = ((region_ptr) atomic_add(&(r->alloc_ptr), size));
    
    // If this fails, we allocated too much memory and need to resize
    // the region.
    if(p + size > r->size) {
        return 0;
    }

    return p;
}

region_ptr alloc_vector(region __global *r, int item_size, int num_items);
region_ptr alloc_vector(region __global *r, int item_size, int num_items)
{
    region_ptr old_alloc = r->alloc_ptr;
    region_ptr p = alloc_in_region(r, 8 + item_size * num_items);
    if(!p) {
        r->alloc_ptr = old_alloc;
        return 0;
    }

    int __global *length_field = (int __global *)get_region_ptr(r, p);
    *length_field = num_items;
    return p;
}

// 2 means allocation failure
// FIXME: with the new small danger vectors, this doesn't actually
// report allocation failures...
#define harlan_error(code) { /**danger = 2*/; /* return */; }

typedef int cl_int;

typedef struct {
    cl_int tag;
    union {
    struct {
    float f0;
    float f1;
    float f2;
} point3;
} data;
} point3_t_79 ;

float int$d$vfloat(int i_3_156);

point3_t_79 point3(float point3_456, float point3_455, float point3_454);

point3_t_79 point$ddiff(point3_t_79 x_19_135, point3_t_79 y_18_134);

point3_t_79 point$dadd(point3_t_79 x_27_127, point3_t_79 y_26_126);

point3_t_79 point$ddiv(point3_t_79 a_35_122, float y_34_121);

float point$dmag(point3_t_79 p_39_117);

float int$d$vfloat(int i_3_156) {
    return ((float)(i_3_156));
}

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
        int tag_448 = extract_tag(m_449);
        float a_22_138 = m_449.data.point3.f0;
        float b_21_137 = m_449.data.point3.f1;
        float c_20_136 = m_449.data.point3.f2;
        int tag_446 = extract_tag(m_447);
        float d_25_141 = m_447.data.point3.f0;
        float e_24_140 = m_447.data.point3.f1;
        float f_23_139 = m_447.data.point3.f2;
        return point3((a_22_138) - (d_25_141), (b_21_137) - (e_24_140), (c_20_136) - (f_23_139));
    }
}

point3_t_79 point$dadd(point3_t_79 x_27_127, point3_t_79 y_26_126) {
    {
        point3_t_79 m_445 = x_27_127;
        point3_t_79 m_443 = y_26_126;
        int tag_444 = extract_tag(m_445);
        float a_30_130 = m_445.data.point3.f0;
        float b_29_129 = m_445.data.point3.f1;
        float c_28_128 = m_445.data.point3.f2;
        int tag_442 = extract_tag(m_443);
        float x_33_133 = m_443.data.point3.f0;
        float y_32_132 = m_443.data.point3.f1;
        float z_31_131 = m_443.data.point3.f2;
        return point3((a_30_130) + (x_33_133), (b_29_129) + (y_32_132), (c_28_128) + (z_31_131));
    }
}

point3_t_79 point$ddiv(point3_t_79 a_35_122, float y_34_121) {
    {
        point3_t_79 m_441 = a_35_122;
        int tag_440 = extract_tag(m_441);
        float a_38_125 = m_441.data.point3.f0;
        float b_37_124 = m_441.data.point3.f1;
        float c_36_123 = m_441.data.point3.f2;
        return point3((a_38_125) / (y_34_121), (b_37_124) / (y_34_121), (c_36_123) / (y_34_121));
    }
}

float point$dmag(point3_t_79 p_39_117) {
    point3_t_79 m_439 = p_39_117;
    int tag_438 = extract_tag(m_439);
    float a_42_120 = m_439.data.point3.f0;
    float b_41_119 = m_439.data.point3.f1;
    float c_40_118 = m_439.data.point3.f2;
    return harlan_sqrt(((a_42_120) * (a_42_120)) + (((b_41_119) * (b_41_119)) + ((c_40_118) * (c_40_118))));
}

__kernel void kernel_532(region_ptr kern_490,
                         region_ptr ktemp_467,
                         region_ptr bodies_43_85,
                         region_ptr danger_vector_493,
                         int stride_45_87,
                         region_ptr j_46_88,
                         __global void * rk_299_536,
                         __global void * r_245_535,
                         __global void * rk_321_534,
                         __global void * rk_375_533)
{
    __global region * rk_299 = ((__global region *)(rk_299_536));
    __global region * r_245 = ((__global region *)(r_245_535));
    __global region * rk_321 = ((__global region *)(rk_321_534));
    __global region * rk_375 = ((__global region *)(rk_375_533));
    {
        __global point3_t_79 * retval_494 = (&(((__global point3_t_79 *)(get_region_ptr(rk_321, (kern_490) + (8))))[get_global_id(0)]));
        __global point3_t_79 * i_44_86 = (&(((__global point3_t_79 *)(get_region_ptr(rk_375, (ktemp_467) + (8))))[get_global_id(0)]));
        point3_t_79 if_res_514;
        if((*((__global int *)(get_region_ptr(rk_375, j_46_88)))) < (stride_45_87))
            {
                region_ptr j_47_106 = j_46_88;
                region_ptr vec_478 = j_47_106;
                int refindex_479 = 0;
                if((refindex_479) >= (*((__global int *)(get_region_ptr(rk_375, vec_478)))))
                    {
                        ((__global bool_t *)(get_region_ptr(rk_321, (danger_vector_493) + (8))))[0] = true;
                        return;
                    }
                point3_t_79 j_48_107 = ((__global point3_t_79 *)(get_region_ptr(rk_375, (vec_478) + (8))))[refindex_479];
                point3_t_79 diff_49_108 = point$ddiff(*i_44_86, j_48_107);
                float d_50_109 = point$dmag(diff_49_108);
                point3_t_79 if_res_515;
                if((0) < (d_50_109))
                    if_res_515 = point$ddiv(diff_49_108, ((d_50_109) * (d_50_109)) * (d_50_109));
                else
                    if_res_515 = point3(0, 0, 0);
                point3_t_79 t_51_110 = if_res_515;
                int i_54_113 = 1;
                int stepv_53_112 = 1;
                int stopv_52_111 = *((__global int *)(get_region_ptr(rk_375, j_47_106)));
                while((i_54_113) < (stopv_52_111))
                    {
                        region_ptr vec_475 = j_47_106;
                        int refindex_476 = i_54_113;
                        if((refindex_476) >= (*((__global int *)(get_region_ptr(rk_375, vec_475)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_321, (danger_vector_493) + (8))))[0] = true;
                                return;
                            }
                        point3_t_79 j_55_114 = ((__global point3_t_79 *)(get_region_ptr(rk_375, (vec_475) + (8))))[refindex_476];
                        point3_t_79 diff_56_115 = point$ddiff(*i_44_86, j_55_114);
                        float d_57_116 = point$dmag(diff_56_115);
                        point3_t_79 if_res_516;
                        if((0) < (d_57_116))
                            if_res_516 = point$ddiv(diff_56_115, ((d_57_116) * (d_57_116)) * (d_57_116));
                        else
                            if_res_516 = point3(0, 0, 0);
                        t_51_110 = point$dadd(t_51_110, if_res_516);
                        i_54_113 = (i_54_113) + (stepv_53_112);
                    }
                if_res_514 = t_51_110;
            }
        else
            {
                region_ptr j_58_89 = bodies_43_85;
                int expr_489 = stride_45_87;
                region_ptr x_487 = alloc_vector(r_245, sizeof(int), expr_489);
                for(int i_488 = 0; i_488 < expr_489; i_488= (i_488 + 1))
                    ((__global int *)(get_region_ptr(r_245, (x_487) + (8))))[i_488] = i_488;
                region_ptr ktemp_466 = x_487;
                int expr_486 = stride_45_87;
                region_ptr x_484 = alloc_vector(rk_299, sizeof(point3_t_79), expr_486);
                for(int i_485 = 0; i_485 < expr_486; i_485= (i_485 + 1))
                    {
                        int i_59_90 = i_485;
                        point3_t_79 j_60_91 = ((__global point3_t_79 *)(get_region_ptr(rk_375, (j_58_89) + (8))))[i_59_90];
                        point3_t_79 diff_61_92 = point$ddiff(*i_44_86, j_60_91);
                        float d_62_93 = point$dmag(diff_61_92);
                        point3_t_79 if_res_517;
                        if((0) < (d_62_93))
                            if_res_517 = point$ddiv(diff_61_92, ((d_62_93) * (d_62_93)) * (d_62_93));
                        else
                            if_res_517 = point3(0, 0, 0);
                        point3_t_79 t_63_94 = if_res_517;
                        int reduce$dindex_66_97 = (i_59_90) + (stride_45_87);
                        int stepv_65_96 = stride_45_87;
                        int stopv_64_95 = *((__global int *)(get_region_ptr(rk_375, j_58_89)));
                        while((reduce$dindex_66_97) < (stopv_64_95))
                            {
                                point3_t_79 j_67_98 = ((__global point3_t_79 *)(get_region_ptr(rk_375, (j_58_89) + (8))))[reduce$dindex_66_97];
                                point3_t_79 diff_68_99 = point$ddiff(*i_44_86, j_67_98);
                                float d_69_100 = point$dmag(diff_68_99);
                                point3_t_79 if_res_518;
                                if((0) < (d_69_100))
                                    if_res_518 = point$ddiv(diff_68_99, ((d_69_100) * (d_69_100)) * (d_69_100));
                                else
                                    if_res_518 = point3(0, 0, 0);
                                t_63_94 = point$dadd(t_63_94, if_res_518);
                                reduce$dindex_66_97 = (reduce$dindex_66_97) + (stepv_65_96);
                            }
                        ((__global point3_t_79 *)(get_region_ptr(rk_299, (x_484) + (8))))[i_485] = t_63_94;
                    }
                region_ptr x_70_101 = x_484;
                region_ptr vec_472 = x_70_101;
                int refindex_473 = 0;
                if((refindex_473) >= (*((__global int *)(get_region_ptr(rk_299, vec_472)))))
                    {
                        ((__global bool_t *)(get_region_ptr(rk_321, (danger_vector_493) + (8))))[0] = true;
                        return;
                    }
                point3_t_79 t_71_102 = ((__global point3_t_79 *)(get_region_ptr(rk_299, (vec_472) + (8))))[refindex_473];
                int i_74_105 = 1;
                int stepv_73_104 = 1;
                int stopv_72_103 = *((__global int *)(get_region_ptr(rk_299, x_70_101)));
                while((i_74_105) < (stopv_72_103))
                    {
                        region_ptr vec_469 = x_70_101;
                        int refindex_470 = i_74_105;
                        if((refindex_470) >= (*((__global int *)(get_region_ptr(rk_299, vec_469)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_321, (danger_vector_493) + (8))))[0] = true;
                                return;
                            }
                        t_71_102 = point$dadd(t_71_102, ((__global point3_t_79 *)(get_region_ptr(rk_299, (vec_469) + (8))))[refindex_470]);
                        i_74_105 = (i_74_105) + (stepv_73_104);
                    }
                if_res_514 = t_71_102;
            }
        *retval_494 = if_res_514;
    }
}

