/* -*- c -*- */

/*
  This is generated from the Harlan nested-kernels2.kfc test case.

  The goal is to reduce it down until we can tell exactly what feature
  breaks.
*/

#define get_region_ptr(r, i) (r + i)

__kernel void kernel_845(int kern_764,
						 int row_62_116,
						 __global int * r)
{
	int stride = 65536;
	int j = get_global_id(0) + stride;
	int stop = *((get_region_ptr(r, row_62_116)));
	while(j < stop) {
		int x_89_143
			= ((get_region_ptr(r, row_62_116 + 8)))[j];
		if((*((get_region_ptr(r, x_89_143)))) < stride) {
			if(0 >= (*((get_region_ptr(r, x_89_143)))))
				return;
		}
		else {
			if(!*r) {
				*r = 0;
			}
			int x_755 = *r;
			__global int *vec
				= (get_region_ptr(r, x_755 + 8));

			for(int k = 0; k < stride; k++)
				vec[k] = k;
		}
		j += stride;
	}
}

