# 3D drug distribution analysis
## What does this analysis do?
Analyze the drug distribution distance from the vascular edges. 

## How to perform this analysis?
1. Prepare the images  
Prepare the 3D stacks of images for the nuclear staining channel, the vascular staining channel (e.g. CD31, αSMA), and the target drug imaging channel.
A sample image set can be distributed upon reasonable request. Please contact the Lab head (suishess-kyu@umin.ac.jp).

2. Binarize  
Binarize the images of the vascular staining channel and the drug channel.
The desirable result of binarization should vary depending on the purpose of the experiment.
You can perform any methods to meet your requirements.  
Here, for example, is our representative method.
- Open ImageJ/fiji
- Load images
- Run the macro for each: for vascular [CDX_preprocess_CD31-FITC.ijm](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/CDX_preprocess_CD31-FITC.ijm), for drug [CDX_preprocess_Tmab-DL650.ijm](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/CDX_preprocess_Tmab-DL650.ijm)

The max intensity projections of the serial ten slices will be generated, and saved.

3. Calculate the drug-distribution-distance
Find the code [here](https://github.com/dbsb-juntendo/descSPIM/blob/main/DOCs/codes/DrugVascular_distribution_analysis.ipynb)
