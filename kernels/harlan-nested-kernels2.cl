/* -*- c++ -*- */
__kernel void kernel_877(__global int *p)
{
    int i = get_global_id(0);
    while(i < get_global_id(0)) {
        if(i < 2) {
            if(i < 1) {
                return;
            }
        }
        else {
            for(int j = 0; j < 2; j++) {
                int k = j + 2;
                while(k < i) {
                    k += 2;
                }
            }
        }
        i++;
    }
	*p = 0;
}
