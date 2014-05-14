/* -*- c -*- */

/*
  This kernel has a triply nested loop.
*/

__kernel void foo(__global int *p, __global int *q) {
	int i = get_global_id(0);

    int size = get_global_size(0);

    int f = 0;
    for(int j = 0; j < size; j++) {
		int N = p[i];
		for(int k = 0; k < N; ++k) {
			int M = q[i % j];
			for(int l = 0; l < M; ++l) {
				f += p[k] * p[j] / q[l];
			}
		}
    }

    p[i] = f;
}
