/* -*- c -*- */

/*
  This is generated from the Harlan nested-kernels2.kfc test case.

  The goal is to reduce it down until we can tell exactly what feature
  breaks.
*/

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
                        if(0 >= (*((__global int *)(get_region_ptr(rv_256, x_89_143)))))
                            {
                                return;
                            }
                    }
                else
                    {
                        int expr_757 = stride_88_142;
                        region_ptr x_755 = alloc_vector(r_555, sizeof(int), expr_757);
						// Deleting this for loop lets the compiler finish, on Apple, Intel(R) Core(TM) i5-2500S CPU @ 2.70GHz
                        for(int i_756 = 0; i_756 < expr_757; i_756= (i_756 + 1))
                            ((__global int *)(get_region_ptr(r_555, (x_755) + (8))))[i_756] = i_756;
                        region_ptr ktemp_684 = x_755;
                        int expr_754 = stride_88_142;
                        region_ptr x_752 = alloc_vector(rk_574, sizeof(int), expr_754);
                        region_ptr t_100_149 = x_752;
                        region_ptr x_101_150 = t_100_149;
                        region_ptr vec_698 = x_101_150;
                        int refindex_699 = 0;
                        int t_102_151 = ((__global int *)(get_region_ptr(rk_574, (vec_698) + (8))))[refindex_699];
                        int i_105_154 = 1;
                        int stepv_104_153 = 1;
                        int stopv_103_152 = *((__global int *)(get_region_ptr(rk_574, x_101_150)));
                    }
                reduce$dindex_86_140 = (reduce$dindex_86_140) + (stepv_85_139);
            }
    }
}
