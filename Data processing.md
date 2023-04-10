## Flatfiled correction: ImageJ macro
[Download here](https://github.com/dbsb-juntendo/descSPIM/blob/main/FlatfieldCorrection_IJmacro_ver230406.ijm)

How to use:
1. prepare a reference xy image(1) and a sample xyz stack(2). 

(1) a reference xy image

In order to get the reference image, hogehoge... acquired using dye-solving solution (e.g., CUBIC-R + FITC reagent)...

(2) a sample xyz image stack to be corrected

2. run macro with ImageJ/Fiji

## Compile NIfTI file from TIF(TIFF) stacks: .ipynb file
[Download here] 
> :warning: **Note:** This code has been tested only on Ubuntu. While it may work on other operating systems, compatibility and functionality are not guaranteed.

<details open>
<summary>Preparation</summary>
  
  <details>
    <summary>- Install ImageMagick</summary>  
  1. Update your package list and install the necessary dependencies
  ```bash
  sudo apt-get update
  sudo apt-get install -y software-properties-common wget
  ```
  2. Add the ImageMagick repository to your system
  ```bash
  wget -qO- https://www.imagemagick.org/download/ImageMagick.key | sudo apt-key add -
  sudo add-apt-repository "deb https://www.imagemagick.org/download/ubuntu focal main"
  ```
  3. Update your package list again to include the newly added repository
  ```bash
  sudo apt-get update
  ```
  4. Install ImageMagick
  ```bash
  sudo apt-get install -y imagemagick
  ```
  5. Verify the installation by checking the version
  ```bash
  magick -version
  ```
  The output should be like following: 
  ```bash
  Version: ImageMagick 7.X.Y-X Q16 x86_64 2023-04-08 https://imagemagick.org
  ```
    
    </details>
    
  - Install C3D
  1. 
</details>




## Stitching with Bigstitcher




## 0-180 digree fusion by 3D slicer and Bigstitcher
