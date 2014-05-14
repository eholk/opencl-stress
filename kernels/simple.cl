/* -*- c -*- */

/*
  This is a simple no-op kernel.
*/
__kernel void foo(__global float *p) {
	int i = get_global_id(0);
	p[i] = i;
}
