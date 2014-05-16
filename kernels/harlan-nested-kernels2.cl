/* -*- c++ -*- */

typedef unsigned int region_ptr;

struct region_ {
    unsigned int size;
    volatile region_ptr alloc_ptr;
};

#define region struct region_

#define get_region_ptr(r, i) (((char __global *)r) + i)

typedef unsigned long uint64_t;

region_ptr alloc_vector(region __global *r, int item_size, int num_items)
{
    region_ptr p = r->alloc_ptr;
    r->alloc_ptr += item_size * num_items;
    if(p > r->size) {
        // This line is important.
        r->alloc_ptr = 0;
        return 0;
    }
    return p;
}

__kernel void kernel_877(region_ptr out,
                         region_ptr row,
                         __global region * r)
{
    int i = get_global_id(0);
    int stop = *((__global int *)(get_region_ptr(r, row)));
    while(i < stop)
        {
            region_ptr col
                = ((__global region_ptr *)(get_region_ptr(r, row)))[i];
            // if stride is greater than 6, Intel's OpenCL vectorizer crashes.
            int stride = 7;
            if(*((__global int *)(get_region_ptr(r, col))) < stride) {
                // This block seems important. It's probably the return.
                if(0 >= (*((__global int *)(get_region_ptr(r, col))))) {
                    return;
                }
            }
            else {
                // This line is also important.
                region_ptr col2 = col;
                region_ptr x_787 = alloc_vector(r, sizeof(int), stride);
                for(int j = 0; j < stride; j++) {
                    int x = ((__global int *)(get_region_ptr(r, col2)))[j];
                    int k = j + stride;
                    int stop2 = *((__global int *)(get_region_ptr(r, col2)));
                    while(k < stop2) {
                        x += ((__global int *)(get_region_ptr(r, col2)))[k];
                        k += stride;
                    }
                    ((__global int *)(get_region_ptr(r, 0)))[j] = x;
                }
            }
            i++;
        }
}
