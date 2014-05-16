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

__kernel void kernel_877(region_ptr kern_796,
                         region_ptr row_70_132,
                         int stride_17_130, 
                         region_ptr danger_vector_799,
                         __global region * r)
{
    __global int * retval_800 = (&(((__global int *)(get_region_ptr(r, (kern_796) + (8))))[get_global_id(0)]));
    int i_71_133 = get_global_id(0);
    int if_res_851;
    int t_95_157 = if_res_851;
    int reduce$dindex_98_160 = (i_71_133) + (stride_17_130);
    int stepv_97_159 = stride_17_130;
    int stopv_96_158 = *((__global int *)(get_region_ptr(r, row_70_132)));
    while((reduce$dindex_98_160) < (stopv_96_158))
        {
            region_ptr row_99_161 = ((__global region_ptr *)(get_region_ptr(r, (row_70_132) + (8))))[reduce$dindex_98_160];
            region_ptr x_101_163 = row_99_161;
            int stride_100_162 = 65536;
            int if_res_852;
            if((*((__global int *)(get_region_ptr(r, x_101_163)))) < (stride_100_162))
                {
                    region_ptr x_102_177 = x_101_163;
                    region_ptr vec_736 = x_102_177;
                    int refindex_737 = 0;
                    // This block seems important. It's probably the return.
                    if((refindex_737) >= (*((__global int *)(get_region_ptr(r, vec_736))))) {
                        return;
                    }
                }
            else
                {
                    region_ptr x_109_164 = row_99_161;
                    int expr_789 = stride_100_162;
                    region_ptr x_787 = alloc_vector(r, sizeof(int), expr_789);
                    for(int i_788 = 0; i_788 < expr_789; i_788= (i_788 + 1))
                        ((__global int *)(get_region_ptr(r, (x_787) + (8))))[i_788] = i_788;
                    int expr_786 = stride_100_162;
                    region_ptr x_784 = alloc_vector(r, sizeof(int), expr_786);
                    for(int i_785 = 0; i_785 < expr_786; i_785= (i_785 + 1))
                        {
                            int i_110_165 = i_785;
                            int x_111_166 = ((__global int *)(get_region_ptr(r, (x_109_164) + (8))))[i_110_165];
                            int t_112_167 = x_111_166;
                            int reduce$dindex_115_170 = (i_110_165) + (stride_100_162);
                            int stepv_114_169 = stride_100_162;
                            int stopv_113_168 = *((__global int *)(get_region_ptr(r, x_109_164)));
                            while((reduce$dindex_115_170) < (stopv_113_168))
                                {
                                    int x_116_171 = ((__global int *)(get_region_ptr(r, (x_109_164) + (8))))[reduce$dindex_115_170];
                                    t_112_167 = (t_112_167) + (x_116_171);
                                    reduce$dindex_115_170 = (reduce$dindex_115_170) + (stepv_114_169);
                                }
                            ((__global int *)(get_region_ptr(r, (x_784) + (8))))[i_785] = t_112_167;
                        }
                }
            t_95_157 = (t_95_157) + (if_res_852);
            reduce$dindex_98_160 = (reduce$dindex_98_160) + (stepv_97_159);
        }
    *retval_800 = t_95_157;
}
