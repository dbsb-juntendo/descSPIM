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
In the FA (fine axial) mode, the effective FOV (field of view) is narrowed to about 889 μm in the original configuration. [Otomo et.al, bioRxiv, 2023](https://doi.org/10.1101/2023.05.02.539136)  
In order to cover the larger FOV (e.g., a mouse whole brain), use these ImageJ macros.  
[Macro_Border finder_ver1.1.ijm](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/Macro_Border%20finder_ver1.1.ijm)  
[Macro_z evaluate on reslice.ijm](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/Macro_z%20evaluate%20on%20reslice.ijm)  
[GEMINI_Data processing](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/GEMINI_Data%20processing(Tiling%2Ccrop%2C8bit%2CRemoveOutsideParticle)_ver3.0.ijm)  

## Compiling NIfTI files and downsizing (recommended)
In most cases, it is difficult to perform the downstream regisration process with the original full-resolution stack.
For a quarter mouse brain, the image stack size for each channel is usually 5~10 GB.
In order to reduce the computation, we strongly recommend downsizing.
Following the coming two steps, the full-resolution NIfTi stack and the downsized stack will be prepared.
* Note: We use ANTs software in the registration process; ANTs does accept TIF stacks, however, using NIfTI stacks will save time in most cases.
* Obtaining a nuclear staining channel image is always the best practice. It can be used as a reference image for the registration and for clean 3D visualization as well.
* We also prepared another convenient code that integrates NIfTI compilation, downsizing, registration, and fusing. [code](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/descSPIM_NiftiRegFuse.ipynb)
* For testing, please make use of these [test images](https://github.com/dbsb-juntendo/descSPIM/releases/tag/v1.0.1)
  
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
## Registraion and fusion
Obtaining a complemented NIfTI stack for the nuclear staining channel and the target channel (e.g., Thy1-GFP).
[Code](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/descSPIM_NiftiRegFuse.ipynb)  
This code enables:
- Compiling NIfTI stacks from the original TIF files
- Registration of a reciprocal pair of stacks
- Fusing the images
- Generate a final fused NIfTI stack

The instructions for usage are all included in the code.  

>[!NOTE]
>Note that we only tested the code in a Linux (Ubuntu 20.04) environment. 

## Registration quality check (optional)
For a casual quality check of the registration, please find the code [here](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/RegistrationAccuracy_qc_ZNCC_MI.ipynb).  
We adopted two indicators: Zero-means normalized cross-correlation (ZNCC), and mutial information (MI). Both are pixel intensity based calculation, the values are standardized between zero and one, greater value means more image similarity.  
* Note: Instructions are included in the code. Briefly, just set the paths of the image stacks you want to check, the compared figure will be saved to your designated directory.

