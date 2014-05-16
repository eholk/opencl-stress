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

__kernel void kernel_877(region_ptr kern_796,
                         region_ptr row,
                         __global region * r)
{
    // Inlining this variable makes Intel OpenCL succeed.
    __global int *retval
        = (&(((__global int *)(get_region_ptr(r, kern_796)))[get_global_id(0)]));
    int if_res_851;
    int i = get_global_id(0);
    int stop = *((__global int *)(get_region_ptr(r, row)));
    while(i < stop)
        {
            region_ptr col
                = ((__global region_ptr *)(get_region_ptr(r, row)))[i];
            // if stride is greater than 6, Intel's OpenCL vectorizer crashes.
            int stride = 7;
            int if_res_852;
            if(*((__global int *)(get_region_ptr(r, col))) < stride) {
                // This block seems important. It's probably the return.
                if(0 >= (*((__global int *)(get_region_ptr(r, col))))) {
                    return;
                }
            }
            else
                {
                    // This line is also important.
                    region_ptr col2 = col;
                    region_ptr x_787 = alloc_vector(r, sizeof(int), stride);
                    region_ptr x_784 = 0;
                    for(int j = 0; j < stride; j++) {
                        int x_111_166 = ((__global int *)(get_region_ptr(r, (col2) + (8))))[j];
                        int t_112_167 = x_111_166;
                        int k = j + stride;
                        int stopv_113_168 = *((__global int *)(get_region_ptr(r, col2)));
                        while(k < stopv_113_168) {
                            int x_116_171 = ((__global int *)(get_region_ptr(r, col2)))[k];
                            t_112_167 = (t_112_167) + (x_116_171);
                            k += stride;
                        }
                        ((__global int *)(get_region_ptr(r, (x_784) + (8))))[j] = t_112_167;
                    }
                }
            if_res_851 += if_res_852;
            i++;
        }
    *retval = if_res_851;
}
