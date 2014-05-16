/* -*- c++ -*- */

#define get_region_ptr(r, i) (r + i)

__kernel void kernel_877(int out,
                         int row,
                         __global int * r)
{
    int i = get_global_id(0);
    int stop = *((get_region_ptr(r, row)));
    while(i < stop)
        {
            int col
                = ((get_region_ptr(r, row)))[i];
            if(*((get_region_ptr(r, col))) < 2) {
                if(0 >= (*((get_region_ptr(r, 0))))) {
                    return;
                }
            }
            else {
                for(int j = 0; j < 2; j++) {
                    int k = j + 2;
                    int stop2 = *((get_region_ptr(r, 0)));
                    while(k < stop2) {
                        k += 2;
                    }
                }
            }
            i++;
        }
}
