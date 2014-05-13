/* -*- c -*- */

/*
  This kernel has a loop that traverses a vector.
*/

__kernel void foo(__global float *p) {
	int i = get_global_id(0);

    int size = get_global_size(0);

    float f = 0;
    for(int j = 0; j < size; j++) {
        f += p[j];
    }

    p[i] = f;
}
