/*version record
2020.4.14: ver1.1, change output of "Border_average" as a rounded number

*/

// manual parameters
array = newArray("Right_001", "Right_002"); //"Left_002", "Left_001", "Left_000", "Right_000", "Right_001", "Right_002", from left to right
z_range_of_reslice_image = "z00451-00550";

start_slice = 840; // 計算する開始slice (5の倍数)
end_slice = 1840; // 計算する最後のslice (5の倍数)
start_x = 1440; // 計算するx範囲の開始点
end_x = 1750; // 計算するx範囲の終了点
no_of_slice = 5; //平均の計算に使用するスライスの枚数（default = 5）

waitForUser("Delete rectangle?");

setBatchMode(true);

//Descriptions
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, seconds, msec);
rmonth = month+1;
print("=== "+year+"-"+rmonth+"-"+dayOfMonth+" "+IJ.pad(hour,2)+":"+IJ.pad(minute,2)+":"+IJ.pad(seconds,2)+" Macro Started ===");
print("Data processing: Auto border founder (FFT bandpass-based)");
print("by Macro_Border finder_ver1.1.ijm");
print("");
printTitle();
print("x range: "+start_x+" - "+end_x);
print("");

//definision of valuables
no_of_rectangle = end_x-start_x;
slice_gap = (end_slice-start_slice)/no_of_slice;
sum = 0;
m = 0;


//main processing
print("***Border calculation***");
do {
	round_no = m/slice_gap;
	current_slice = start_slice + m;
	for (n=0; n<array.length; n++){	
		string_restrict = array[n];
		selectWindow("Reslice_of_"+string_restrict+"_"+z_range_of_reslice_image+".tif");
		run("Select None");
		setSlice(current_slice);
		run("Duplicate...", " ");
	}
	getBorder();
	Border = getResult("Border", 0);
	print("Border on slice #"+current_slice+" = "+Border);
	sum = sum + Border;
	m = m + slice_gap;
} while (round_no + 1 < no_of_slice);

Border_average = sum/(round_no+1);
print("          ***");
print("Averaged border position = "+round(Border_average));
print("Finish calculation !!!");
print("");
print("");

close("Results");

setBatchMode(false);


//functions
function getBorder(){
for (j = 0; j < array.length; j++) {
		string_restrict = array[j];
		subjectImage = "Reslice_of_"+string_restrict+"_"+z_range_of_reslice_image+"-1.tif";
		getXZFocusValue();
		close(subjectImage);
	}
	getDifference();
}


function getXZFocusValue() { 
	for (i = 0; i < no_of_rectangle; i++) {
		selectImage(subjectImage);
		makeRectangle(i+start_x, 0, 50, 100);
		run("Duplicate...", "title=Duplicate");
		run("Bandpass Filter...", "filter_large=2 filter_small=0 suppress=Horizontal tolerance=5");
		run("Select All");
		getRawStatistics(nPixels, mean, min, max, std);
		setResult("SD-"+j, i, std);
		updateResults();
		close("Duplicate");
	}
}


function getDifference(){
	for (k = 0; k < no_of_rectangle; k++) {
		SD_0 = getResult("SD-0", k);
		SD_1 = getResult("SD-1", k);
		Difference = SD_0-SD_1;
		setResult("Difference_SD", k, Difference);
		updateResults();
		Difference_ikkomae = getResult("Difference_SD", k-1);
		if (Difference < 0 && Difference_ikkomae > 0) {
			Border = k+25+start_x;
			setResult("Border", 0, Border);
			updateResults();
		}
	}
}


function printTitle() {
	print("***Subject images***")
	for (n=0; n<array.length; n++){	
		string_restrict = array[n];
		print("Image-"+IJ.pad(n+1,1)+": Reslice_of_"+string_restrict+"_"+z_range_of_reslice_image+".tif");
	}
}


