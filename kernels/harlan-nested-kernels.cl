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

typedef unsigned long uint64_t;

region_ptr alloc_in_region(region __global *r, unsigned int size);
region_ptr alloc_in_region(region __global *r, unsigned int size)
{
    region_ptr p = ((region_ptr) atomic_add(&(r->alloc_ptr), size));
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

__kernel void kernel_845(region_ptr kern_764,
						 region_ptr row_62_116,
						 int stride_17_114,
						 __global region * r_555)
{
	int i = get_global_id(0);
	region_ptr row_64_118
		= ((__global region_ptr *)(get_region_ptr(r_555, row_62_116 + 8)))[i];
	int reduce$dindex_86_140 = (i) + (stride_17_114);
	int stopv_84_138 = *((__global int *)(get_region_ptr(r_555, row_62_116)));
	int stepv_85_139 = stride_17_114;
	while((reduce$dindex_86_140) < (stopv_84_138)) {
		region_ptr row_87_141 = ((__global region_ptr *)(get_region_ptr(r_555, (row_62_116) + (8))))[reduce$dindex_86_140];
		region_ptr x_89_143 = row_87_141;
		int stride_88_142 = 65536;
		if((*((__global int *)(get_region_ptr(r_555, x_89_143)))) < (stride_88_142))
			{
				if(0 >= (*((__global int *)(get_region_ptr(r_555, x_89_143)))))
					{
						return;
					}
			}
		else
			{
				region_ptr x_755 = alloc_vector(r_555, sizeof(int), stride_88_142);
				for(int i_756 = 0; i_756 < stride_88_142; i_756= (i_756 + 1))
					((__global int *)(get_region_ptr(r_555, (x_755) + (8))))[i_756] = i_756;
			}
		reduce$dindex_86_140 = (reduce$dindex_86_140) + (stepv_85_139);
	}

}
