from distutils.core import setup
from setuptools import find_packages
from Cython.Build import cythonize
from distutils.extension import Extension
import numpy

ext_modules = [
    Extension("MAS_library.MAS_library", ["MAS_library/MAS_library.pyx",
                                          "MAS_library/MAS_c.c"],
        extra_compile_args=['-O3','-ffast-math','-march=native','-fopenmp'],
              extra_link_args=['-fopenmp'], libraries=['m']),

    Extension("Pk_library.Pk_library", ["Pk_library/Pk_library.pyx"],
        extra_compile_args = ['-O3','-ffast-math','-march=native','-fopenmp']),

    Extension("Pk_library.bispectrum_library",
        ["Pk_library/bispectrum_library.pyx"]),

    Extension("smoothing_library.smoothing_library",
              ["smoothing_library/smoothing_library.pyx"],
        extra_compile_args = ['-O3','-ffast-math','-march=native','-fopenmp'],
        extra_link_args=['-fopenmp'], libraries=['m']),

    Extension("void_library.void_library", 
              ["void_library/void_library.pyx",
               "void_library/void_openmp_library.c"],
        extra_compile_args = ['-O3','-ffast-math','-march=native','-fopenmp'],
        extra_link_args=['-fopenmp'], libraries=['m']),
]


setup(
    name = 'Pylians3',
    ext_modules = cythonize(ext_modules, 
                            compiler_directives={'language_level' : "3"},
                            include_path=['MAS_library/','void_library/']),
    include_dirs=[numpy.get_include()],
    packages=find_packages(),
    #py_modules=['HOD_library','bias_library','CAMB_library','cosmology_library',
    #'correlation_function_library','halos_library','IM_library',
    #'mass_function_library','readfof','readsnap','readsnap2',
    #'readsnapHDF5','readsnap_mpi','readsubf','routines',
    #'units_library','HI/HI_image_library', 
    #'plotting_library','readgadget']
)




