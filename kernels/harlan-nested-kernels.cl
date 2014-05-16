/* -*- c -*- */

/*
  This is generated from the Harlan nested-kernels2.kfc test case.

  The goal is to reduce it down until we can tell exactly what feature
  breaks.
*/

__kernel void kernel_845(__global int *r)
{
	int j = get_global_id(0);
	while(j < *r) {
		if(r[j] < 0) {
			if(0 >= *r)
				return;
		}
		else {
			if(!*r) {
				*r = 0;
			}
			for(int k = 0; k < 31; k++)
				r[k] = k;
		}
		j++;
	}
}
