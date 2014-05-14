/* -*- c -*- */

/*
  This is generated from the Harlan nested-kernels2.kfc test case.

  The goal is to reduce it down until we can tell exactly what feature
  breaks.
*/

typedef unsigned int region_ptr;

struct region_ {
    // This is the next thing to allocate
    volatile region_ptr alloc_ptr;
};

#define region struct region_

// This gives us a pointer to something in a region.
#define get_region_ptr(r, i) (((char __global *)r) + i)

region_ptr alloc_vector(region __global *r, int item_size, int num_items);
region_ptr alloc_vector(region __global *r, int item_size, int num_items)
{
    region_ptr old_alloc = r->alloc_ptr;
	r->alloc_ptr += 8 + item_size * num_items;

    if(!r->alloc_ptr) {
        r->alloc_ptr = old_alloc;
        return 0;
    }
    return r->alloc_ptr;
}

__kernel void kernel_845(region_ptr kern_764,
						 region_ptr row_62_116,
						 __global region * r_555)
{
	int stride = 65536;
	int j = get_global_id(0) + stride;
	int stop = *((__global int *)(get_region_ptr(r_555, row_62_116)));
	while(j < stop) {
		region_ptr x_89_143
			= ((__global region_ptr *)(get_region_ptr(r_555,
													  row_62_116 + 8)))[j];
		if((*((__global int *)(get_region_ptr(r_555, x_89_143)))) < (stride)) {
			if(0 >= (*((__global int *)(get_region_ptr(r_555, x_89_143)))))
				return;
		}
		else {
			region_ptr x_755 = alloc_vector(r_555, sizeof(int), stride);
			__global int *vec
				= (__global int *)(get_region_ptr(r_555, x_755 + 8));

			for(int k = 0; k < stride; k++)
				vec[k] = k;
		}
		j += stride;
	}
}
