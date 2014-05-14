/* -*- c -*- */

/*
  This is generated from the Harlan nested-kernels2.kfc test case.

  The goal is to reduce it down until we can tell exactly what feature
  breaks.
*/

#ifndef GPU_COMMON_H
#define GPU_COMMON_H

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

#endif
// the #if silences warnings on newer OpenCLs.
#if __OPENCL_VERSION__ < 120
#pragma OPENCL EXTENSION cl_khr_fp64: enable
#endif

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

// This is the kernel that is used by the CPU to allocate vectors in
// regions already on the GPU... or it will be soon, anyway.
__kernel void harlan_rt_alloc_vector(void __global *r,
                                     int item_size,
                                     int num_items,
                                     region_ptr __global *result)
{
    *result = alloc_vector((region __global *)r, item_size, num_items);
}

__kernel void kernel_863(region_ptr kern_804, __global void * r_305_864) {
    __global region * r_305 = ((__global region *)(r_305_864));
    {
        __global int * retval_808 = (&(((__global int *)(get_region_ptr(r_305, (kern_804) + (8))))[get_global_id(0)]));
        *retval_808 = get_global_id(0);
    }
}
__kernel void kernel_860(region_ptr kern_796, int stride_21_167, region_ptr x_22_168, __global void * rk_324_862, __global void * rv_256_861) {
    __global region * rk_324 = ((__global region *)(rk_324_862));
    __global region * rv_256 = ((__global region *)(rv_256_861));
    {
        __global int * retval_800 = (&(((__global int *)(get_region_ptr(rk_324, (kern_796) + (8))))[get_global_id(0)]));
        int i_28_169 = get_global_id(0);
        int tmp_29_170 = ((__global int *)(get_region_ptr(rv_256, (x_22_168) + (8))))[i_28_169];
        int j_32_173 = (i_28_169) + (stride_21_167);
        int stepv_31_172 = stride_21_167;
        int stopv_30_171 = *((__global int *)(get_region_ptr(rv_256, x_22_168)));
        while((j_32_173) < (stopv_30_171))
            {
                tmp_29_170 = (tmp_29_170) + (((__global int *)(get_region_ptr(rv_256, (x_22_168) + (8))))[j_32_173]);
                j_32_173 = (j_32_173) + (stepv_31_172);
            }
        *retval_800 = tmp_29_170;
    }
}
__kernel void kernel_858(region_ptr kern_788, __global void * r_389_859) {
    __global region * r_389 = ((__global region *)(r_389_859));
    {
        __global int * retval_792 = (&(((__global int *)(get_region_ptr(r_389, (kern_788) + (8))))[get_global_id(0)]));
        *retval_792 = get_global_id(0);
    }
}
__kernel void kernel_855(region_ptr kern_780, int stride_44_190, region_ptr x_45_191, __global void * rk_408_857, __global void * rv_256_856) {
    __global region * rk_408 = ((__global region *)(rk_408_857));
    __global region * rv_256 = ((__global region *)(rv_256_856));
    {
        __global int * retval_784 = (&(((__global int *)(get_region_ptr(rk_408, (kern_780) + (8))))[get_global_id(0)]));
        int i_51_192 = get_global_id(0);
        int tmp_52_193 = ((__global int *)(get_region_ptr(rv_256, (x_45_191) + (8))))[i_51_192];
        int j_55_196 = (i_51_192) + (stride_44_190);
        int stepv_54_195 = stride_44_190;
        int stopv_53_194 = *((__global int *)(get_region_ptr(rv_256, x_45_191)));
        while((j_55_196) < (stopv_53_194))
            {
                tmp_52_193 = (tmp_52_193) + (((__global int *)(get_region_ptr(rv_256, (x_45_191) + (8))))[j_55_196]);
                j_55_196 = (j_55_196) + (stepv_54_195);
            }
        *retval_784 = tmp_52_193;
    }
}
__kernel void kernel_853(region_ptr kern_772, __global void * r_436_854) {
    __global region * r_436 = ((__global region *)(r_436_854));
    {
        __global int * retval_776 = (&(((__global int *)(get_region_ptr(r_436, (kern_772) + (8))))[get_global_id(0)]));
        *retval_776 = get_global_id(0);
    }
}
__kernel void kernel_845(region_ptr kern_764, region_ptr row_62_116, int stride_17_114, region_ptr danger_vector_767, __global void * rk_491_852, __global void * r_472_851, __global void * rk_574_850, __global void * r_555_849, __global void * rv_226_848, __global void * rv_256_847, __global void * rk_597_846) {
    __global region * rk_491 = ((__global region *)(rk_491_852));
    __global region * r_472 = ((__global region *)(r_472_851));
    __global region * rk_574 = ((__global region *)(rk_574_850));
    __global region * r_555 = ((__global region *)(r_555_849));
    __global region * rv_226 = ((__global region *)(rv_226_848));
    __global region * rv_256 = ((__global region *)(rv_256_847));
    __global region * rk_597 = ((__global region *)(rk_597_846));
    {
        __global int * retval_768 = (&(((__global int *)(get_region_ptr(rk_597, (kern_764) + (8))))[get_global_id(0)]));
        int i_63_117 = get_global_id(0);
        region_ptr row_64_118 = ((__global region_ptr *)(get_region_ptr(rv_226, (row_62_116) + (8))))[i_63_117];
        region_ptr x_66_120 = row_64_118;
        int stride_65_119 = 65536;
        int if_res_819;
        if((*((__global int *)(get_region_ptr(rv_256, x_66_120)))) < (stride_65_119))
            {
                region_ptr x_67_132 = x_66_120;
                region_ptr vec_716 = x_67_132;
                int refindex_717 = 0;
                if((refindex_717) >= (*((__global int *)(get_region_ptr(rv_256, vec_716)))))
                    {
                        ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                        return;
                    }
                int t_68_133 = ((__global int *)(get_region_ptr(rv_256, (vec_716) + (8))))[refindex_717];
                int i_71_136 = 1;
                int stepv_70_135 = 1;
                int stopv_69_134 = *((__global int *)(get_region_ptr(rv_256, x_67_132)));
                while((i_71_136) < (stopv_69_134))
                    {
                        region_ptr vec_713 = x_67_132;
                        int refindex_714 = i_71_136;
                        if((refindex_714) >= (*((__global int *)(get_region_ptr(rv_256, vec_713)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                return;
                            }
                        t_68_133 = (t_68_133) + (((__global int *)(get_region_ptr(rv_256, (vec_713) + (8))))[refindex_714]);
                        i_71_136 = (i_71_136) + (stepv_70_135);
                    }
                if_res_819 = t_68_133;
            }
        else
            {
                int expr_763 = stride_65_119;
                region_ptr x_761 = alloc_vector(r_472, sizeof(int), expr_763);
                for(int i_762 = 0; i_762 < expr_763; i_762= (i_762 + 1))
                    ((__global int *)(get_region_ptr(r_472, (x_761) + (8))))[i_762] = i_762;
                region_ptr ktemp_685 = x_761;
                int expr_760 = stride_65_119;
                region_ptr x_758 = alloc_vector(rk_491, sizeof(int), expr_760);
                for(int i_759 = 0; i_759 < expr_760; i_759= (i_759 + 1))
                    {
                        int i_72_121 = i_759;
                        int tmp_73_122 = ((__global int *)(get_region_ptr(rv_256, (x_66_120) + (8))))[i_72_121];
                        int j_76_125 = (i_72_121) + (stride_65_119);
                        int stepv_75_124 = stride_65_119;
                        int stopv_74_123 = *((__global int *)(get_region_ptr(rv_256, x_66_120)));
                        while((j_76_125) < (stopv_74_123))
                            {
                                tmp_73_122 = (tmp_73_122) + (((__global int *)(get_region_ptr(rv_256, (x_66_120) + (8))))[j_76_125]);
                                j_76_125 = (j_76_125) + (stepv_75_124);
                            }
                        ((__global int *)(get_region_ptr(rk_491, (x_758) + (8))))[i_759] = tmp_73_122;
                    }
                region_ptr t_77_126 = x_758;
                region_ptr x_78_127 = t_77_126;
                region_ptr vec_710 = x_78_127;
                int refindex_711 = 0;
                if((refindex_711) >= (*((__global int *)(get_region_ptr(rk_491, vec_710)))))
                    {
                        ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                        return;
                    }
                int t_79_128 = ((__global int *)(get_region_ptr(rk_491, (vec_710) + (8))))[refindex_711];
                int i_82_131 = 1;
                int stepv_81_130 = 1;
                int stopv_80_129 = *((__global int *)(get_region_ptr(rk_491, x_78_127)));
                while((i_82_131) < (stopv_80_129))
                    {
                        region_ptr vec_707 = x_78_127;
                        int refindex_708 = i_82_131;
                        if((refindex_708) >= (*((__global int *)(get_region_ptr(rk_491, vec_707)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                return;
                            }
                        t_79_128 = (t_79_128) + (((__global int *)(get_region_ptr(rk_491, (vec_707) + (8))))[refindex_708]);
                        i_82_131 = (i_82_131) + (stepv_81_130);
                    }
                if_res_819 = t_79_128;
            }
        int t_83_137 = if_res_819;
        int reduce$dindex_86_140 = (i_63_117) + (stride_17_114);
        int stepv_85_139 = stride_17_114;
        int stopv_84_138 = *((__global int *)(get_region_ptr(rv_226, row_62_116)));
        while((reduce$dindex_86_140) < (stopv_84_138))
            {
                region_ptr row_87_141 = ((__global region_ptr *)(get_region_ptr(rv_226, (row_62_116) + (8))))[reduce$dindex_86_140];
                region_ptr x_89_143 = row_87_141;
                int stride_88_142 = 65536;
                int if_res_820;
                if((*((__global int *)(get_region_ptr(rv_256, x_89_143)))) < (stride_88_142))
                    {
                        region_ptr x_90_155 = x_89_143;
                        region_ptr vec_704 = x_90_155;
                        int refindex_705 = 0;
                        if((refindex_705) >= (*((__global int *)(get_region_ptr(rv_256, vec_704)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                return;
                            }
                        int t_91_156 = ((__global int *)(get_region_ptr(rv_256, (vec_704) + (8))))[refindex_705];
                        int i_94_159 = 1;
                        int stepv_93_158 = 1;
                        int stopv_92_157 = *((__global int *)(get_region_ptr(rv_256, x_90_155)));
                        while((i_94_159) < (stopv_92_157))
                            {
                                region_ptr vec_701 = x_90_155;
                                int refindex_702 = i_94_159;
                                if((refindex_702) >= (*((__global int *)(get_region_ptr(rv_256, vec_701)))))
                                    {
                                        ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                        return;
                                    }
                                t_91_156 = (t_91_156) + (((__global int *)(get_region_ptr(rv_256, (vec_701) + (8))))[refindex_702]);
                                i_94_159 = (i_94_159) + (stepv_93_158);
                            }
                        if_res_820 = t_91_156;
                    }
                else
                    {
                        int expr_757 = stride_88_142;
                        region_ptr x_755 = alloc_vector(r_555, sizeof(int), expr_757);
                        for(int i_756 = 0; i_756 < expr_757; i_756= (i_756 + 1))
                            ((__global int *)(get_region_ptr(r_555, (x_755) + (8))))[i_756] = i_756;
                        region_ptr ktemp_684 = x_755;
                        int expr_754 = stride_88_142;
                        region_ptr x_752 = alloc_vector(rk_574, sizeof(int), expr_754);
                        for(int i_753 = 0; i_753 < expr_754; i_753= (i_753 + 1))
                            {
                                int i_95_144 = i_753;
                                int tmp_96_145 = ((__global int *)(get_region_ptr(rv_256, (x_89_143) + (8))))[i_95_144];
                                int j_99_148 = (i_95_144) + (stride_88_142);
                                int stepv_98_147 = stride_88_142;
                                int stopv_97_146 = *((__global int *)(get_region_ptr(rv_256, x_89_143)));
                                while((j_99_148) < (stopv_97_146))
                                    {
                                        tmp_96_145 = (tmp_96_145) + (((__global int *)(get_region_ptr(rv_256, (x_89_143) + (8))))[j_99_148]);
                                        j_99_148 = (j_99_148) + (stepv_98_147);
                                    }
                                ((__global int *)(get_region_ptr(rk_574, (x_752) + (8))))[i_753] = tmp_96_145;
                            }
                        region_ptr t_100_149 = x_752;
                        region_ptr x_101_150 = t_100_149;
                        region_ptr vec_698 = x_101_150;
                        int refindex_699 = 0;
                        if((refindex_699) >= (*((__global int *)(get_region_ptr(rk_574, vec_698)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                return;
                            }
                        int t_102_151 = ((__global int *)(get_region_ptr(rk_574, (vec_698) + (8))))[refindex_699];
                        int i_105_154 = 1;
                        int stepv_104_153 = 1;
                        int stopv_103_152 = *((__global int *)(get_region_ptr(rk_574, x_101_150)));
                        while((i_105_154) < (stopv_103_152))
                            {
                                region_ptr vec_695 = x_101_150;
                                int refindex_696 = i_105_154;
                                if((refindex_696) >= (*((__global int *)(get_region_ptr(rk_574, vec_695)))))
                                    {
                                        ((__global bool_t *)(get_region_ptr(rk_597, (danger_vector_767) + (8))))[0] = true;
                                        return;
                                    }
                                t_102_151 = (t_102_151) + (((__global int *)(get_region_ptr(rk_574, (vec_695) + (8))))[refindex_696]);
                                i_105_154 = (i_105_154) + (stepv_104_153);
                            }
                        if_res_820 = t_102_151;
                    }
                t_83_137 = (t_83_137) + (if_res_820);
                reduce$dindex_86_140 = (reduce$dindex_86_140) + (stepv_85_139);
            }
        *retval_768 = t_83_137;
    }
}
