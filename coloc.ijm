macro "Quantify Colocolisation" {
    input_folder = "in/";
    output_folder = "out/";

    // this is the numbers of ROI, should always be only 1 in manually extracted samples
    r_threshold=128;
    g_threshold=128;

    //run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");

    image_name = getArgument;
    if (image_name=="") exit ("No argument!");
    input_path = input_folder + image_name;

    // get the path name
    open(input_path);
    var fn = getInfo("image.filename");
    results = output_folder + fn + "_ROI_results.txt";

    //names for text outputs and montage
    distances = output_folder + fn + "_distances.txt";
    montage = output_folder + fn + "_montage.png";

    //internal window name for thre region of interest
    roi_title="";
    roi_image=fn + ".png";

    //make various copies to be used in stack slice after auto thresholding
    red_roi_bw_title = roi_title+" (red)";
    red_roi_bw_copy_title = red_roi_bw_title+" copy";
    green_roi_bw_title =  roi_title +" (green)";
    green_roi_bw_copy_title =  green_roi_bw_title+" copy";
    blue_roi_bw_title =  roi_title+" (blue)";

    // print some logging info, this is used later to parse the file
    print("COLOC",fn,roi_image);

    // enhance contrast of the image
    selectWindow(fn);
    //run("Enhance Contrast", "saturated=0.4");

    // extract that image for red/green slpitting to do the analysis
    run("Duplicate...", "title=ROI");
    selectWindow("ROI");
    // duplicate this region for later
    run("Duplicate...", "title=RGB");

    // get the ROI for analysing in Jacop
    selectWindow(fn);
    run("Duplicate...", "title="+ roi_title);
    selectWindow(roi_title);

    //split the channels for Jacop
    run("Split Channels");

    //auto threshold for red
    selectWindow(red_roi_bw_title);
    run("Duplicate...", "title="+ red_roi_bw_copy_title);
    run("Channels Tool... ");
    selectWindow(red_roi_bw_title);
    setAutoThreshold("Intermodes dark");
    run("Convert to Mask");
    //run("Despeckle");
    run("Red");

    //auto threshold for green
    selectWindow(green_roi_bw_title);
    run("Duplicate...", "title="+ green_roi_bw_copy_title);
    run("Channels Tool... ");
    selectWindow(green_roi_bw_title);
    //run("Enhance Contrast", "saturated=0.4");
    setAutoThreshold("MaxEntropy dark");
    //setAutoThreshold("Intermodes dark");
    run("Convert to Mask");
    run("Green");
    run("Despeckle");

	
    //run("Remove Outliers...", "radius=1 threshold=50 which=Dark");
    //exit;
    
    // create a dummy montage, there is a problem on Linux with exceptions in imageJ
    // so that the entire app closes if JACoP fails, hence no montage would be created
    // so at least here we get some sort of image
    run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use keep");
    run("Delete Slice");
    run("Delete Slice");
    setSlice(1);
    run("Add Slice");
    setSlice(5);
    run("Delete Slice"); 
    setSlice(6);
    run("Add Slice");
    run("Add Slice");         
    run("Make Montage...", "columns=2 rows=4 scale=1 first=1 last=8 increment=1 border=1 font=12");
    saveAs("png", montage);
    close();

  
    //run the plugin
    selectWindow(red_roi_bw_title);
    run("Properties...", "channels=1 slices=1 frames=1 unit=nm pixel_width=70.0000 pixel_height=70.0000 voxel_depth=148.0000 frame=[0 sec] origin=0,0");  
    run("JACoP ", "imga=["+red_roi_bw_title+"] imgb=["+green_roi_bw_title+"] thra="+r_threshold+" thrb="+g_threshold+" objdist=1-9030-212.62857142857143-497.95918367346945-true-false-true objcentpart=1-9030-true-false-true");; // objcentpart=2-23520-true-false-true");
    //selectWindow(" (Centres of mass) of "+red_roi_bw_title+"-Particles of "+green_roi_bw_title+" based colocalization");
    //selectWindow("Distance based colocalization between "+red_roi_bw_title+" and "+green_roi_bw_title+" (centres of mass)");
    //saveAs("txt",distances);
 
    selectWindow("Distance based colocalization between "+red_roi_bw_title+" and "+green_roi_bw_title+" (centres of mass)");
    saveAs("txt",distances);
    selectWindow(red_roi_bw_title);

    selectWindow(green_roi_bw_title);

    selectWindow(blue_roi_bw_title);
    close();
    selectWindow(fn);
    close();
    selectWindow("ROI");
    close();

    // create montage with remaining windows
    run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use keep");

    // add spacer slice so images line up
    setSlice(1);
    run("Add Slice");
    run("Make Montage...", "columns=2 rows=4 scale=1 first=1 last=8 increment=1 border=1 font=12");
    saveAs("png", montage);
    //run("Close All");

    // save all results to file
    saveAs("Results",output_folder + fn + "_ROI_results.txt");
    //run("Close All");

}
