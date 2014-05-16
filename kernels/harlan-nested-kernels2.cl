/* -*- c++ -*-
  Code that gets included in both the CPU and GPU code. This is mostly
  basic data structures.
 */

typedef unsigned int region_ptr;

// We use our own bool type because OpenCL doesn't let you pass bools
// between host and kernel code.
typedef int bool_t;

// This is mostly opaque to the GPU.
struct region_ {
    // Size of this header + the stuff
    unsigned int size;

    // This is the next thing to allocate
    volatile region_ptr alloc_ptr;
};

#define region struct region_

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

// This is the kernel that is used by the CPU to allocate vectors in
// regions already on the GPU... or it will be soon, anyway.
__kernel void harlan_rt_alloc_vector(void __global *r,
                                     int item_size,
                                     int num_items,
                                     region_ptr __global *result)
{
    *result = alloc_vector((region __global *)r, item_size, num_items);
}

__kernel void kernel_877(region_ptr kern_796, region_ptr row_70_132, int stride_17_130, region_ptr danger_vector_799, __global void * rk_523_884, __global void * r_504_883, __global void * rk_606_882, __global void * r_587_881, __global void * rv_258_880, __global void * rv_288_879, __global void * rk_629_878) {
    __global region * rk_523 = ((__global region *)(rk_523_884));
    __global region * r_504 = ((__global region *)(r_504_883));
    __global region * rk_606 = ((__global region *)(rk_606_882));
    __global region * r_587 = ((__global region *)(r_587_881));
    __global region * rv_258 = ((__global region *)(rv_258_880));
    __global region * rv_288 = ((__global region *)(rv_288_879));
    __global region * rk_629 = ((__global region *)(rk_629_878));
    {
        __global int * retval_800 = (&(((__global int *)(get_region_ptr(rk_629, (kern_796) + (8))))[get_global_id(0)]));
        int i_71_133 = get_global_id(0);
        region_ptr row_72_134 = ((__global region_ptr *)(get_region_ptr(rv_258, (row_70_132) + (8))))[i_71_133];
        region_ptr x_74_136 = row_72_134;
        int stride_73_135 = 65536;
        int if_res_851;
        if((*((__global int *)(get_region_ptr(rv_288, x_74_136)))) >= (stride_73_135)) {
            region_ptr x_82_137 = row_72_134;
            int expr_795 = stride_73_135;
            region_ptr x_793 = alloc_vector(r_504, sizeof(int), expr_795);
            for(int i_794 = 0; i_794 < expr_795; i_794= (i_794 + 1))
                ((__global int *)(get_region_ptr(r_504, (x_793) + (8))))[i_794] = i_794;
            int expr_792 = stride_73_135;
            region_ptr x_790 = alloc_vector(rk_523, sizeof(int), expr_792);
            for(int i_791 = 0; i_791 < expr_792; i_791= (i_791 + 1))
                {
                    int i_83_138 = i_791;
                    int x_84_139 = ((__global int *)(get_region_ptr(rv_288, (x_82_137) + (8))))[i_83_138];
                    int t_85_140 = x_84_139;
                    int reduce$dindex_88_143 = (i_83_138) + (stride_73_135);
                    int stepv_87_142 = stride_73_135;
                    int stopv_86_141 = *((__global int *)(get_region_ptr(rv_288, x_82_137)));
                    while((reduce$dindex_88_143) < (stopv_86_141))
                        {
                            int x_89_144 = ((__global int *)(get_region_ptr(rv_288, (x_82_137) + (8))))[reduce$dindex_88_143];
                            t_85_140 = (t_85_140) + (x_89_144);
                            reduce$dindex_88_143 = (reduce$dindex_88_143) + (stepv_87_142);
                        }
                    ((__global int *)(get_region_ptr(rk_523, (x_790) + (8))))[i_791] = t_85_140;
                }
            region_ptr x_90_145 = x_790;
            region_ptr vec_742 = x_90_145;
            int refindex_743 = 0;
            if((refindex_743) >= (*((__global int *)(get_region_ptr(rk_523, vec_742)))))
                {
                    ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                    return;
                }
            int t_91_146 = ((__global int *)(get_region_ptr(rk_523, (vec_742) + (8))))[refindex_743];
            int i_94_149 = 1;
            int stepv_93_148 = 1;
            int stopv_92_147 = *((__global int *)(get_region_ptr(rk_523, x_90_145)));
            while((i_94_149) < (stopv_92_147))
                {
                    region_ptr vec_739 = x_90_145;
                    int refindex_740 = i_94_149;
                    if((refindex_740) >= (*((__global int *)(get_region_ptr(rk_523, vec_739)))))
                        {
                            ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                            return;
                        }
                    t_91_146 = (t_91_146) + (((__global int *)(get_region_ptr(rk_523, (vec_739) + (8))))[refindex_740]);
                    i_94_149 = (i_94_149) + (stepv_93_148);
                }
            if_res_851 = t_91_146;
        }
        int t_95_157 = if_res_851;
        int reduce$dindex_98_160 = (i_71_133) + (stride_17_130);
        int stepv_97_159 = stride_17_130;
        int stopv_96_158 = *((__global int *)(get_region_ptr(rv_258, row_70_132)));
        while((reduce$dindex_98_160) < (stopv_96_158))
            {
                region_ptr row_99_161 = ((__global region_ptr *)(get_region_ptr(rv_258, (row_70_132) + (8))))[reduce$dindex_98_160];
                region_ptr x_101_163 = row_99_161;
                int stride_100_162 = 65536;
                int if_res_852;
                if((*((__global int *)(get_region_ptr(rv_288, x_101_163)))) < (stride_100_162))
                    {
                        region_ptr x_102_177 = x_101_163;
                        region_ptr vec_736 = x_102_177;
                        int refindex_737 = 0;
                        if((refindex_737) >= (*((__global int *)(get_region_ptr(rv_288, vec_736)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                                return;
                            }
                        int x_103_178 = ((__global int *)(get_region_ptr(rv_288, (vec_736) + (8))))[refindex_737];
                        int t_104_179 = x_103_178;
                        int i_107_182 = 1;
                        int stepv_106_181 = 1;
                        int stopv_105_180 = *((__global int *)(get_region_ptr(rv_288, x_102_177)));
                        while((i_107_182) < (stopv_105_180))
                            {
                                region_ptr vec_733 = x_102_177;
                                int refindex_734 = i_107_182;
                                if((refindex_734) >= (*((__global int *)(get_region_ptr(rv_288, vec_733)))))
                                    {
                                        ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                                        return;
                                    }
                                int x_108_183 = ((__global int *)(get_region_ptr(rv_288, (vec_733) + (8))))[refindex_734];
                                t_104_179 = (t_104_179) + (x_108_183);
                                i_107_182 = (i_107_182) + (stepv_106_181);
                            }
                        if_res_852 = t_104_179;
                    }
                else
                    {
                        region_ptr x_109_164 = row_99_161;
                        int expr_789 = stride_100_162;
                        region_ptr x_787 = alloc_vector(r_587, sizeof(int), expr_789);
                        for(int i_788 = 0; i_788 < expr_789; i_788= (i_788 + 1))
                            ((__global int *)(get_region_ptr(r_587, (x_787) + (8))))[i_788] = i_788;
                        int expr_786 = stride_100_162;
                        region_ptr x_784 = alloc_vector(rk_606, sizeof(int), expr_786);
                        for(int i_785 = 0; i_785 < expr_786; i_785= (i_785 + 1))
                            {
                                int i_110_165 = i_785;
                                int x_111_166 = ((__global int *)(get_region_ptr(rv_288, (x_109_164) + (8))))[i_110_165];
                                int t_112_167 = x_111_166;
                                int reduce$dindex_115_170 = (i_110_165) + (stride_100_162);
                                int stepv_114_169 = stride_100_162;
                                int stopv_113_168 = *((__global int *)(get_region_ptr(rv_288, x_109_164)));
                                while((reduce$dindex_115_170) < (stopv_113_168))
                                    {
                                        int x_116_171 = ((__global int *)(get_region_ptr(rv_288, (x_109_164) + (8))))[reduce$dindex_115_170];
                                        t_112_167 = (t_112_167) + (x_116_171);
                                        reduce$dindex_115_170 = (reduce$dindex_115_170) + (stepv_114_169);
                                    }
                                ((__global int *)(get_region_ptr(rk_606, (x_784) + (8))))[i_785] = t_112_167;
                            }
                        region_ptr x_117_172 = x_784;
                        region_ptr vec_730 = x_117_172;
                        int refindex_731 = 0;
                        if((refindex_731) >= (*((__global int *)(get_region_ptr(rk_606, vec_730)))))
                            {
                                ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                                return;
                            }
                        int t_118_173 = ((__global int *)(get_region_ptr(rk_606, (vec_730) + (8))))[refindex_731];
                        int i_121_176 = 1;
                        int stepv_120_175 = 1;
                        int stopv_119_174 = *((__global int *)(get_region_ptr(rk_606, x_117_172)));
                        while((i_121_176) < (stopv_119_174))
                            {
                                region_ptr vec_727 = x_117_172;
                                int refindex_728 = i_121_176;
                                if((refindex_728) >= (*((__global int *)(get_region_ptr(rk_606, vec_727)))))
                                    {
                                        ((__global bool_t *)(get_region_ptr(rk_629, (danger_vector_799) + (8))))[0] = true;
                                        return;
                                    }
                                t_118_173 = (t_118_173) + (((__global int *)(get_region_ptr(rk_606, (vec_727) + (8))))[refindex_728]);
                                i_121_176 = (i_121_176) + (stepv_120_175);
                            }
                        if_res_852 = t_118_173;
                    }
                t_95_157 = (t_95_157) + (if_res_852);
                reduce$dindex_98_160 = (reduce$dindex_98_160) + (stepv_97_159);
            }
        *retval_800 = t_95_157;
    }
}
