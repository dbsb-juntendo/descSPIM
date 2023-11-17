//user defined parameter
//filename = "Image_Z_00000_Left_000.tiff"; //set the name of 1st image in the folder
array = newArray("Left_000", "Left_001", "Left_002", "Right_000", "Right_001", "Right_002"); //"Left_000", "Left_001", "Left_002", "Right_000", "Right_001", "Right_002"
start_z = 451; 

//auto parameter
end_z = start_z + 99;

inputdir = getDirectory("Choose a input directory");
outputdir = File.getParent(inputdir);
list = getFileList(inputdir);
filename = list[0];
print("Data saved at: "+outputdir);
print("1st file: "+filename);
//"D:/GEMINI-WS_share/20190213_Whole-pancreas IHC_ASH2L_2/488_SYTOX/LPC/";
//"D:/GEMINI-WS_share/20190213_Whole-pancreas IHC_ASH2L_2/";

for(i=0;i<array.length;i++){
	z_evaluate_in_reslice();
}


function z_evaluate_in_reslice() {
	setBatchMode(true);
	string_restrict = array[i];
	run("Image Sequence...", "open=["+inputdir+filename+"] number=100 starting="+start_z+" file="+string_restrict+" sort");
	stack = getImageID();
	selectImage(stack);
	run("Reslice [/]...", "output=1.000 start=Top avoid");
	//setSlice(500);
	//run("Enhance Contrast", "saturated=0.35");
	saveAs("tiff", outputdir+"/Reslice_of_"+string_restrict+"_z"+IJ.pad(start_z,5)+"-"+IJ.pad(end_z,5)+".tif");
	run("Close All");
	setBatchMode(false);
}

