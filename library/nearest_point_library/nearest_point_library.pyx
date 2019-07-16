import numpy as np
import time,sys,os
import pyfftw
import scipy.integrate as si
cimport numpy as np
cimport cython
#from cython.parallel import prange
from libc.math cimport sqrt,pow,sin,log10,abs,round
import sys



def NP(np.float32_t[:,:] pos, np.float32_t[:,:] vel, float BoxSize, int dims):

    cdef int axis, ii, jj, kk, max_cells
    cdef long particles, i
    cdef float factor, distance
    cdef np.float32_t[::1] nearest_cell, diff, diff2
    cdef np.float32_t[:,:,:] Vx, Vy, Vz, dist_grid
    cdef np.int32_t[::1] index,index2

    max_cells = 1

    Vx = np.zeros((dims,dims,dims),dtype=np.float32)
    Vy = np.zeros((dims,dims,dims),dtype=np.float32)
    Vz = np.zeros((dims,dims,dims),dtype=np.float32)
    dist_grid = np.ones((dims,dims,dims),dtype=np.float32)*BoxSize

    nearest_cell = np.empty(3,dtype=np.float32)
    diff         = np.empty(3,dtype=np.float32)
    diff2        = np.empty(3,dtype=np.float32)
    index        = np.empty(3,dtype=np.int32)
    index2       = np.empty(3,dtype=np.int32)

    factor    = dims*1.0/BoxSize
    factorI   = BoxSize*1.0/dims
    particles = len(pos)

    # do a loop over all particles
    for i in range(particles):

        for axis in range(3):

            nearest_cell[axis] = round(pos[i,axis]*factor)
            diff[axis] = nearest_cell[axis]*factorI - pos[i,axis]
            if nearest_cell[axis]>=dims:  nearest_cell[axis] -= dims
            if nearest_cell[axis]<0.0:    nearest_cell[axis] += dims
            index[axis] = <int>nearest_cell[axis]

        # compute distance to closest grid point
        distance = sqrt(diff[0]*diff[0] + diff[1]*diff[1] + diff[2]*diff[2])
        
        if distance<dist_grid[index[0],index[1],index[2]]:
            Vx[index[0],index[1],index[2]] = vel[i,0]
            Vy[index[0],index[1],index[2]] = vel[i,1]
            Vz[index[0],index[1],index[2]] = vel[i,2]
            dist_grid[index[0],index[1],index[2]] = distance

        for ii in range(-max_cells,max_cells+1):
            index2[ii] = index[0] + ii
            for jj in range(-max_cells,max_cells+1):
                for kk in range(-max_cells,max_cells+1):
                
                    


    # check that all cells have been updated
    for ii in range(dims):
        for jj in range(dims):
            for kk in range(dims):

                if dist_grid[i,j,k]==BoxSize:
                    print('Not all cells updated!!');  sys.exit()
                    
