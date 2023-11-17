/*
 * version 3.0 on 2021.2.7: use Stack Combine function
 */

//parameters defined by user
array_L = newArray("Left_002", "Left_001", "Left_000"); // "Left_002", "Left_001", 
array_R = newArray("Right_000", "Right_001", "Right_002"); //, "Right_001", "Right_002"
center_x = 1096; //x position starting Right_000
array_border_L = newArray(0, 453, 808, center_x); //0 should be placed in every case
array_border_R = newArray(center_x, 1383, 1725, 2160); //2160 should be placed in every case
ref_LS_shift_position = "Left_000"; //assign an image for intensity adjustment

//set valiables
total_LS_shift_position = array_L.length + array_R.length;
inputdir = getDirectory("Choose a Directory");
outputdir = File.getParent(inputdir);
list_inputdir = getFileList(inputdir);

Dialog.create("Set methods");	
Dialog.addCheckbox("Set manual range:", true); 
Dialog.addNumber("z start (manual range)",501,0,4,"");
Dialog.addNumber("Stack size (manual range)",10,0,4,"");
Dialog.addNumber("Increment (manual range)",10,0,4,"");
Dialog.addNumber("LS shift no. in the folder (manual range)",6,0,4,"");
Dialog.addCheckbox("Merge L+R with Max intensity:", false); //Max or tiling
Dialog.addCheckbox("Save 16-bit images:", false); //select saving 16-bit images
Dialog.addCheckbox("Convert to 8-bit by square-root:", false); //select saving 16-bit images
Dialog.addCheckbox("Crop:", false); 	//do crop
Dialog.addNumber("Crop width",1950,0,4,"");
Dialog.addNumber("Crop midline",center_x,0,4,"");
Dialog.addCheckbox("Remove outside particles:", false); 	//do remove outside particles
Dialog.addNumber("Lower threshold (covering ROI)",6,0,4,"");
Dialog.addNumber("Upper threshold",255,0,4,"");
Dialog.show;

manual_range = Dialog.getCheckbox();
zStart = Dialog.getNumber();
stack_size = Dialog.getNumber();
increment = Dialog.getNumber();
no_LS_shift_folder = Dialog.getNumber();
Max_select = Dialog.getCheckbox();
Sixteen_bit_save = Dialog.getCheckbox();
Square_root = Dialog.getCheckbox();
Crop = Dialog.getCheckbox(); 
Crop_width = Dialog.getNumber();
Crop_midline = Dialog.getNumber();
Crop_start_x = Crop_midline-Crop_width/2; 
RemoveParticle = Dialog.getCheckbox(); 
Lower_Threshold = Dialog.getNumber();
Upper_Threshold = Dialog.getNumber();

if (manual_range == true){
	first_image = list_inputdir[(zStart-1)*no_LS_shift_folder]; 
	use_part_of_LS_shift = false;
	status_manual_range = "_test";
}else{
	first_image = list_inputdir[0];
	zStart = 0;
	status_manual_range = "";
	//set a case of using a part of light-sheet shift positions
	Dialog.create("");	
	Dialog.addCheckbox("Use a part of LS shift position:", false); //Max or tiling
	Dialog.addNumber("If so, give last z of the stack:",1000,0,4,"");
	Dialog.show;
	use_part_of_LS_shift = Dialog.getCheckbox();
	last_z = Dialog.getNumber();
	if (use_part_of_LS_shift == true){
		stack_size = last_z + 1;
	}else{
		stack_size = (list_inputdir.length/total_LS_shift_position) ;  //訂正必要
	}
	increment = 1;
}

setBatchMode(true);

//Print parameters
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, seconds, msec);
rmonth = month+1;
print("=== "+year+"-"+rmonth+"-"+dayOfMonth+" "+IJ.pad(hour,2)+":"+IJ.pad(minute,2)+":"+IJ.pad(seconds,2)+" Macro Started ===");
print("Tiling of sheet focused regions -> (Save 16-bit) -> Crop -> Remove outside particle -> save 8-bit");
print("Macro: GEMINI_Data processing(Tiling, crop, 8bit, RemoveOutsideParticle)_ver3.0");
print("File Source: "+inputdir);
print("");

print("<< Parameters >>");

print("*** Z stack ***");
print("zStart: "+first_image);
print("Stack size: "+stack_size);
print("Increment: "+increment);
if (manual_range == true) {
	print("(use Set manual range mode)");
}
print("");
print("*** Tiling position and size ***");
//Left
for (i = 0; i < array_L.length; i++) {
	LS_shift_position = array_L[i];
	x_position = array_border_L[i];
	end_x_position = array_border_L[i+1] - 1;
	print(LS_shift_position+": "+x_position+" - "+end_x_position);
}
//Right
for (i = 0; i < array_R.length; i++) {
	LS_shift_position = array_R[i];
	x_position = array_border_R[i];
	end_x_position = array_border_R[i+1] - 1;
	print(LS_shift_position+": "+x_position+" - "+end_x_position);
}
if(use_part_of_LS_shift == true){
	print("(use a part of LS shift positions)");
}
if(Max_select == true){
	print("(L+R merge with Max: check the following record to see the actual tile size)");
}
print("");
print("*** L+R Merge ***"); 
if (Max_select == true) {
	print("L+R merge with Max intensity");
}else{
	print("L+R tiled at the midline");
}
print("Reference image for intensity adjustment: "+ref_LS_shift_position);
print("");
print("*** Save 16-bit images ***"); 
if (Sixteen_bit_save == true) {
	print("Status-On");
}else{
	print("Status-Off");
}
print("");
print("*** 8-bit conversion ***"); 
if (Square_root == true) {
	print("Converted by square-root");
}else{
	print("Simple 8-bit conversion");
}
print("");
print("*** Image cropping ***"); 
if (Crop == true) {
	print("Crop range (X): "+Crop_width+" pixels from x = "+Crop_start_x);
}else{
	print("Skip Cropping");
}
print("");
print("*** Remove outside particles ***"); 
if (RemoveParticle == true) {
	print("Status-On / Threshold: "+Lower_Threshold+" - "+Upper_Threshold);
}else{
	print("Status-Off");
}
print("");

//get image intensity mean of reference stack
print("<< Processing >>");
print("getting ref image intensity...");
run("Image Sequence...", "open=["+inputdir+"/"+first_image+"] number="+stack_size+" starting="+zStart+" increment="+increment+" file="+ref_LS_shift_position+" sort use");
//rename("stack"); 
getRefImageMean();

//prepare cropped stack of L images
print("process Left image...");
number_of_LS_shift_position = array_L.length;
for (i = 0; i < number_of_LS_shift_position; i++) {
	LS_shift_position = array_L[i];
	x_position = array_border_L[i];
	next_x_position = array_border_L[i+1];
	makeCroppedStack();
}

//prepare cropped stack of R images
print("process Right image...");
number_of_LS_shift_position = array_R.length;
for (i = 0; i < number_of_LS_shift_position; i++) {
	LS_shift_position = array_R[i];
	x_position = array_border_R[i];
	next_x_position = array_border_R[i+1];
	makeCroppedStack();
}

//make left combined image
if (array_L.length > 0){
	print("combine Left image...");
	combine_start = array_L[0];
	selectWindow(combine_start);
	rename("CombinedStack_L");
	for (i = 0; i < array_L.length-1; i++){
		LS_shift_position = array_L[i+1];
		run("Combine...", "stack1=CombinedStack_L stack2="+LS_shift_position);
		rename("CombinedStack_L");
	}
}

//make Right combined image
if (array_R.length > 0){
	print("combine Right image...");
	combine_start = array_R[0];
	selectWindow(combine_start);
	rename("CombinedStack_R");
	for (i = 0; i < array_R.length-1; i++){
		LS_shift_position = array_R[i+1];
		run("Combine...", "stack1=CombinedStack_R stack2="+LS_shift_position);
		rename("CombinedStack_R");
	}
}

//Combine L+R
if (array_L.length > 0 && array_R.length > 0 && Max_select == false) {
	//L+R with tiling
	print("combine L+R image...");
	run("Combine...", "stack1=CombinedStack_L stack2=CombinedStack_R");
} else if (array_L.length > 0 && array_R.length > 0 && Max_select == true) {
//L+R with max
	print("combine L+R image... (with MAX)");
	imageCalculator("Max create stack", "CombinedStack_L","CombinedStack_R");
	selectWindow("CombinedStack_L");
	close();
	selectWindow("CombinedStack_R");
	close();
}

if (Sixteen_bit_save == true) {
saveAs("Tiff", outputdir+"/Tiled_image_stack_16bit"+status_manual_range+".tiff"); 
}

rename("CombinedStack");

//convert to 8-bit
setMinAndMax(0, 65535);
call("ij.ImagePlus.setDefault16bitRange", 16);
if (Square_root == true){
	run("Square Root", "stack");
	setMinAndMax(0, 255);
	status_square_root = "(SqR)";
}else{
	status_square_root = "";
}
run("8-bit");

//crop
if (Crop == true) {
	makeRectangle(Crop_start_x, 0, Crop_width, 2560);
	run("Crop");
	run("Select None");
	status_crop = "_Crop+";
}else{
	status_crop = "";
}

//remove outside particles
if (RemoveParticle == true) {
	removeParticle();
	status_RP = "_RP+";
}else{
	status_RP = "";
}

//save 8-bit image and result table
print("save files...");
saveAs("Tiff", outputdir+"/Tiled_image_stack_8bit"+status_square_root+status_crop+status_RP+status_manual_range+".tiff");
selectWindow("Results");
saveAs("Results", outputdir+"/Results.csv");

print("");
print("finish all processes!!!");
print("");
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, seconds, msec);
rmonth = month+1;
print("=== "+year+"-"+rmonth+"-"+dayOfMonth+" "+IJ.pad(hour,2)+":"+IJ.pad(minute,2)+":"+IJ.pad(seconds,2)+" Macro Finished ==="); //End Telop
print("");
print("");
selectWindow("Log");
saveAs("Text",  outputdir+"/Log_tiling.txt");

setBatchMode(false);

// === end of main process ===


//=== defined functions ===

//	LS_shift_position = array_L/R[i]; set in the main script
//	x_position = array_border_L/R[i]; set in the main script
//	next_x_position = array_border_L/R[i+1];
function makeCroppedStack() {
	print("...start process "+LS_shift_position);
	run("Image Sequence...", "open=["+inputdir+"/"+first_image+"] number="+stack_size+" starting="+zStart+" increment="+increment+" file="+LS_shift_position+" sort");
	if (LS_shift_position == ref_LS_shift_position) {
		rename(LS_shift_position);
	}else{
		getImageMean();  //adjust every image intensity by every intensity mean of Left_000 stack	
	}
	//determine border for L+R (tiling or MAX)
	width = next_x_position - x_position;
	if (Max_select == true && LS_shift_position == "Left_000") {
		width = 2160 - x_position;
	} else if  (Max_select == true && LS_shift_position == "Right_000") {
		width = center_x + width;
		x_position = 0;
	}
	selectWindow(LS_shift_position);
	makeRectangle(x_position, 0, width, 2560); 
	run("Crop");
	run("Select None");
	//rename(LS_shift_position);

	if (LS_shift_position != ref_LS_shift_position) {
		normalizeImageIntensity();  //adjust every image intensity by every intensity mean of Left_000 stack	
	}
	
	print("...finish process "+LS_shift_position+", Tile width: "+width+" pixels");
}


function getRefImageMean() {
	slice_no = nSlices();
	run("Select All");
	for (k = 0; k < slice_no; k++) {
		setSlice(k+1);
		getStatistics(area, mean_ref);
		setResult("Ref_intensity", k, mean_ref);
		updateResults();
	}
	close();
}


//LS_shift_position = array_[i]; set in the main script
function getImageMean() {
	rename(LS_shift_position);
	slice_no = nSlices();
	run("Select All");
	for (j = 0; j < slice_no; j++) {
		setSlice(j+1);
		getStatistics(area, mean);
		setResult("Intensity_"+LS_shift_position, j, mean);
		updateResults();
		mean_ref = getResult("Ref_intensity", j);
		ratio_intensity = mean_ref/mean;
		setResult("Intensity_ratio_"+LS_shift_position, j, ratio_intensity);
		updateResults();
	}
	run("Select None");
}


function normalizeImageIntensity() {
	selectWindow(LS_shift_position);
	slice_no = nSlices();
	for (j = 0; j < slice_no; j++) {
		rename(LS_shift_position);
		setSlice(j+1);
		ratio_intensity = getResult("Intensity_ratio_"+LS_shift_position, j);
		run("Multiply...", "value="+ratio_intensity+" slice");
		run("Select All");
		run("Copy");
		setSlice(j+1);
		//counter();
	}	
}


function removeParticle() { 
	print("remove outside particles...");
	slice_no = nSlices();
	run("Duplicate...", "title=mask duplicate");
	makeRectangle(10, 10, 6, 6);
	run("Add...", "value=100 stack");
	run("Select None");
	setAutoThreshold("Default dark");
	setThreshold(Lower_Threshold, Upper_Threshold);
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark");
	run("Erode", "stack");
	run("Erode", "stack");

	for (j = 0; j < slice_no; j++) {
		n = j+1;
		setSlice(n);
		run("Create Selection");
		run("Make Inverse");
		roiManager("Add");
	}
	selectWindow("mask");
	close();
	print("...complete ROI collection");
	selectWindow("CombinedStack");
	
	for (j = 0; j < slice_no; j++) {
		n = j+1;
		setSlice(n);
		roiManager("Select", j);
		run("Remove Outliers...", "radius=20 threshold=2 which=Bright slice");
		run("Select None");
		counter();
	}
	
	roiManager("Delete");
}


function counter(){
	remainder = j % 100;
	if (j>0 && remainder == 0) {
		print("   ..."+j+" images processed");		
	}
}
