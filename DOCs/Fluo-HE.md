# Fluo-HE
## What is Fluo-HE ?
To demonstrate the adoption of recent 3D pathology trends with clearing and light-sheet microscopy imaging, we also obtained a 3D image of a 2 mm-thick CDX section with FA mode and TLS. The sample was stained with NHS-Alexa FluorⓇ 647 and PI in order to convert the acquired fluorescent images into a false-colored to mimic the pink and purple appearance of standard hematoxylin-eosin volume image (Fluo-HE).  
The code used is based on [Serafin et al., PLOS ONE, 2020](https://doi.org/10.1371/journal.pone.0233198)

## Pre-process
1. Dataset
Prepare a pair of image data in .TIF format.
2. Conert to .h5
Convert the two TIF files into a HDF5 file. Use ImageJ/fiji BigStitcher plugin for this purpose.  
Make sure that the nuclear and cytoplasmic channels are correctly set. 

## False coloring
Find the code [here](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/DBSB_Fluo-HE.ipynb). All the necessary instructions are in it.  
You can change the coloring pattern as you like. Find the best parameters setting to meet your experimental design.

![Fluo-HE example](https://github.com/dbsb-juntendo/descSPIM/releases/download/v1.0.0/Fluo-HE.png)





