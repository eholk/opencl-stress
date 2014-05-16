/* -*- c -*- */

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
