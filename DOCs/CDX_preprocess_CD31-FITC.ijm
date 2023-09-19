/**
Multi-Slice TIFF Image Processor for ImageJ
-------------------------------------------
This macro script processes a multi-slice TIFF image by splitting the image into smaller stacks of slices, performing background subtraction and max intensity projection on each stack, and saving the processed stacks into a new directory.

Dependencies:
- ImageJ or Fiji software.

Author: takakiom
Date: 09/19/2023
License: MIT License (refer to the LICENSE file in the root directory for more details)
**/

// Set the file path
filepath = "/enter/your/data/path" + "/";

// Open the original file
originalFileName = "CDX3c_FITC_subBG_OTSU.tif";

// Determine the number of slices in the original file
open(filepath + originalFileName);
originalTitle = getTitle(); // Get the title of the original window

// Create a directory based on the original file name (without extension)
extensionIndex = indexOf(originalFileName, ".tif");
if (extensionIndex > 0) {
    directoryName = substring(originalFileName, 0, extensionIndex);
} else {
    directoryName = originalFileName;
}
File.makeDirectory(filepath + directoryName);

// Determine the number of slices in the original file
totalSlices = nSlices;

// Loop through every ten slices, or the remaining slices in the last iteration
for (i = 0; i < totalSlices; i += 10) {
    // Determine the range for this iteration
    startSlice = i;
    endSlice = i + 9;

    // If this is the last iteration, adjust the endSlice
    if (endSlice >= totalSlices) {
        endSlice = totalSlices - 1; // Since the slices start from 0
    }

    // Duplicate the specified range
    run("Duplicate...", "duplicate range=" + startSlice + "-" + endSlice);

    // Apply background subtraction
    run("Subtract Background...", "rolling=4 stack");

    // Construct the title of the duplicated window
    duplicateTitle = originalTitle;
    extensionIndex = indexOf(duplicateTitle, ".tif");
    if (extensionIndex > 0) {
        duplicateTitle = substring(duplicateTitle, 0, extensionIndex) + "-1.tif";
    }

    // Run max intensity projection
    run("Z Project...", "projection=[Max Intensity]");

    // Construct the save path with the specified naming convention
    savePath = filepath + directoryName + "/MAX_" + i + "_" + originalFileName + "_" + startSlice + "-" + endSlice + ".tif";

    // Save the processed image
    saveAs("Tiff", savePath);

    // Close the processed image to prepare for the next iteration
    close();

    // Close the duplicated window to prepare for the next iteration
    selectWindow(duplicateTitle);
    close();
}

// Optionally, close the original image
//selectWindow(originalFileName);
//close();
