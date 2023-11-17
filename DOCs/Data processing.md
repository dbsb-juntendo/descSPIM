## LICENSE ##
MIT License
Copyright (c) 2023 Dept. Biochem. Systems Biomed, Juntendo Univ. Grad. Sch. Med.


# Image pre-processing
## Flat-field correction (ImageJ macro)
[Download here](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/FlatfieldCorrection_IJmacro_ver230406.ijm)

The lightsheet has Gaussian illumination intensity, which causes intensity degradation.
Perform this flat-field correction to recover them.

How to use:
1. Prepare a reference xy image(1) and a sample xyz stack(2). 

(1) a reference xy image

The reference image can be acquired using dye-solving solution (e.g., 1 µM fluorescein in CUBIC-R). 

(2) a sample xyz image stack to be corrected

2. Run macro with ImageJ/Fiji.

## Tiling light-sheet method: tiling x position finder (ImageJ macro)
(coming soon)

## Compiling NIfTI files and downsizing
In most cases, it is difficult to perform the downstream regisration process with the original full-resolution stack.
For a quarter mouse brain, the image stack size for each channel is usually 5~10 GB.
In order to reduce the computation, we strongly recommend downsizing.
Following the coming two steps, the full-resolution NIfTi stack and the downsized stack will be prepared.
* Note: We use ANTs software in the registration process; ANTs does accept TIF stacks, however, using NIfTI stacks will save time in most cases.
* Obtaining a nuclear staining channel image is always the best practice. It can be used as a reference image for the registration and for clean 3D visualization as well.
* We also prepared another convenient code that integrates NIfTI compilation, downsizing, registration, and fusing. [code](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/descSPIM_NiftiRegFuse.ipynb)

Before performing:
Please acquire two reciprocal image stacks. This is because the descSPIM-basic is one-directional illumination SPIM, which results in the image intensity degradation at the opposite side of the illumination direction. In order to complement this degradation, rotate the cuvvette (in which the sample is placed) 180° and obtain the images. Now the two complementary image stacks are prepared: angle 0° and angle 180°.

How to use:
1. Compile a fullsize NIfTI stack from the tiff images.  
   Please refer to this code.
   [Compile NIfTi](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/Compile_nifti_fromTifStack.ipynb)

2. Compile the downsized NIfTI stack  
   Please refer to this code.
   [Compile downsized NIfTI](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/Compile_50%25nifti_fromTifStack.ipynb)
   
After these two steps, four NIfTI stacks will be generated:  
- Angle 0°, full size
- Angle 0°, downsized
- Angle 180°, full size
- Angle 180°, downsized

In the next step, these four stacks are used to make a single complemented NIfTI stack.

# Image registration, fusion: for a single tile with two channels
Obtaining a complemented NIfTI stack for the nuclear staining channel and the target channel (e.g., Thy1-GFP).
[Code](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/descSPIM_NiftiRegFuse.ipynb)  
This code enables:
- Compiling NIfTI stacks from the original TIF files
- Registration of a reciprocal pair of stacks
- Fusing the images
- Generate a final fused NIfTI stack

The instructions for usage are included in the code.


