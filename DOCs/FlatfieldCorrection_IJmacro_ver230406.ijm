//Copyright and Licensing
//The code accompanying this paper is released under the MIT License. 
//Please find the full license text in the root directory of this repository. 


//Confirm that the x-y pixel numbers of the reference and sample images are the same

//### main procedure ###

setBatchMode(true);

//Open the reference
path_1 = File.openDialog("select a reference image");
open(path_1);
dir_1 = File.getParent(path_1);
name_1 = File.getName(path_1);
print("Reference image: "+dir_1+"/"+name_1);
ref_title = getTitle();

//Open the sample stack
path_2 = File.openDialog("select a sample image");
open(path_2);
dir_2 = File.getParent(path_2);
name_2 = File.getName(path_2);
print("Sample image: "+dir_2+"/"+name_2);
sample_title = getTitle();

//get median values in the y direction of the reference image, returned as "median_array"
print("get medians...");
median_array = getMedianArray(ref_title); 
Array.show(median_array);

//get the coefficient values for normalizing each median value to the maximum median value in "median_array"
print("calculate normalizing values...");
norm_values = getNormalizingValues(median_array); 
Array.show(norm_values);

//prepare "norm_image" in which the normalization coefficient values are transferred
print("prepare norm_image...");
makeNormImage(sample_title, norm_values); 

//multiply the sample stack with the "norm_image" for the intensity correction
imageCalculator("Multiply create stack", sample_title, "norm_image");

print("finish macro");
setBatchMode(false);



//### defined functions ###

function getMedianArray(image_title) {  //the argument should be the reference image name (as a variable)
	selectWindow(image_title);
	w = getWidth();
	h = getHeight();
	a = newArray(0);	//prepare a blank array
	for (i=0; i<h; i++) {
		makeRectangle(0,i,w,1); //make a rectangle of which size is the image width x 1 pixel height
		median = getValue("Median"); //get the median of the selected area
		run("Select None"); 
		a = Array.concat(a, median); //add median to the array "a"
	}
	return a; 
} 


function getNormalizingValues(a) { //the argument should be the median value array
	a_1 = newArray(0);
	Array.getStatistics(a, min, max) //get the max median value
	for (i=0; i<a.length; i++) { 
		norm_value = max/a[i]; //calculate the coefficient value for normalization
		a_1 = Array.concat(a_1, norm_value); 
	}
	return a_1;
}


function makeNormImage(image_title, a){ //the argument should be the sample stack name (as a variable) and the coefficient value array
	selectWindow(image_title);
	w = getWidth();
	h = getHeight();
	z = nSlices();
	newImage("norm_image", "32-bit black", w, h, z); //prepare a blank image of which size is the same as the sample stack
	for (i=0; i<h; i++) {
		makeRectangle(0,i,w,1); //make a rectangle of which size is the image width x 1 pixel height
		norm_value = a[i]; 
		run("Add...", "value=norm_value stack"); //normalizing calculation
		run("Select None"); 
	}
}
 
