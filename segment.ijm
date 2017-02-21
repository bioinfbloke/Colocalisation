macro "SegmentSimple" {
    input_folder = "raw/";
    output_folder = "in/";
    run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
    run("Colors...", "foreground=black background=black selection=yellow");
    image_name = getArgument;
    //image_name = "MRE11_10_MergeData.TIF";
    if (image_name=="") exit ("No argument!");
    input_path = input_folder + image_name;
    print(">>>>>>>>>>>>>>" + input_path);
	open(input_path);
	//run("Enhance Contrast", "saturated=0.4");
	var fn = getInfo("image.filename");
	results = output_folder + fn + "_ROI_results.txt";
	print("******** Analysing input_path ************");
	print("******** results path = results ************");

	selectWindow(fn);

	// ------- segment out nuclei --------
	SegmentNuclei();
	// ----------------------------------


	//open(input_path);
	//selectWindow(fn);
	roiManager("Show None");
	roiManager("Show All");
        n = roiManager("count");
	var fn = getInfo("image.filename");
	selectWindow(fn);
	close();
	//exit;
	for (i=0; i<n; i++) {
	    roi_image=fn + "_" + "ROI_" + i;
	    open(input_path);
	    fn = getInfo("image.filename");
	    selectWindow(fn);
	    roiManager("select", i);
	    run("Duplicate...", "title="+ roi_image);
	    run("Clear Outside");
	    selectWindow(roi_image);
	    saveAs("Tiff",output_folder+"/"+roi_image);
	}

}

function SegmentNuclei() {
    run("Smooth");
    run("Smooth");
    setThreshold(13, 255);
    run("Convert to Mask");
    run("Fill Holes");
    run("Watershed");
    run("Analyze Particles...", "size=100-Infinity circularity=0.25-1.00 show=Nothing display exclude clear include summarize add in_situ");
}

function SegmentNuclei3Channel() {
    run("Enhance Contrast", "saturated=10");
    run("Smooth");
    run("Smooth");
    run("Smooth");
    run("Convert to Mask");
    run("Fill Holes");
    run("Watershed");
    run("Analyze Particles...", "size=1000-Infinity circularity=0.00-1.00 show=Nothing display exclude clear include summarize add in_situ");
}
