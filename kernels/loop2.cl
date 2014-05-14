/* -*- c -*- */

/*
  This kernel has a loop that traverses a vector.
*/

__kernel void foo(__global int *p) {
	int i = get_global_id(0);

    int size = get_global_size(0);

    int f = 0;
    for(int j = 0; j < size; j++) {
		int N = p[i];
		for(int k = 0; k < N; ++k) {
			f += p[k] * p[j];
		}
    }

    p[i] = f;
}
