# Colocalisation
A simple Perl and ImageJ colocalisation analysis pipeline. This currently takes a directory of image files as input to the pipeline and produces a series of montages of the segmentation/colocalisation process and a table of statistics about the cells analysed. The image files currently supported are 3 Channel (RGB) forma TIFF files.

# Dependencies
* ImageJ must be installed. Fiji should work (though I haven't tested but might not work with regards to JACoP plugin). On our system imageJ has an alias of 'ij' and this application is called in 'segment.pl' and 'coloc.pl'.
* Perl 5+
* JaCoP plugin must be installed (see http://imagejdocu.tudor.lu/doku.php?id=plugin:analysis:jacop_2.0:just_another_colocalization_plugin:start)
* Linux (may run on PC/Mac though not tested)
* There is a module called 'Colocalise.pm' which is called in the script 'table.pl' and if not installed in a standard location then needs to be set in PERL5LIB or in the tol of the script (which I have done on line 4).


# Getting Started
Create a project directory and subdirectories on your file system e.g. 

`mkdir coloc_1; cd coloc_1; mkdir raw in out;` 

git clone the Colocalisation pipeline which will create a directory called Colocalisation:

`git clone https://github.com/bioinfbloke/Colocalisation.git`
 
now we'll make a symlink to the Colocalisation directory

`ln -s Colocalisation bin`

Each new batch of image files will need its own directory structure. In the raw directory place the image files. These should be named as name/value pairs which will allow you to do comparisons later, so for example:

DAPI_Blue_53BP1_Green_PML_Red_Sample_1_type_RGB.tif

See 'Notes' for why...

# Running the Pipeline

Due the variability of the image data the tools need to be run also interactively so pipeline may be too strong a term :-) . I used Zegami to view the files and do analysis on the data which saved a lot of time with regards to QCing  and analysing the data. First move or copy all the TIFFs from your experiment/batch into the 'raw' directory.

There are three main stages and to run each stage you should go to the main project directory (in our example 'cd coloc_1'). 

1) Segmentation

In the main project directory enter:

`perl bin/segment.pl`

Before running, you will almost certainly need to edit the function in bin/segment.ijm called at line 21 "SegmentNuclei" depending on the the nuclei you want to segment. This might take some experimentation!

This operation should populate the 'in' directory with segmented out nuclei images. So there may be lots of these if you have lots of widefield images in 'raw'.

2) Colocalisation

In the main project directory enter:

`perl bin/coloc.pl`

Before running, you may need to edit the command starting line 56 (//auto threshold for red) and line 66 (//auto threshold for green)
bacuse here you are thesholding the foci so they may analysed by the JaCoP plugin. Again this might take some experimentation to get right initially. This will then analyse all the segmented out images in (1).
When this runs you *must* have an X Window set up because the plugin causes imageJ dialog boxes to open up for each image and then close. This is annoying but I haven't found a way to stop this. 

If all goes to plan then the out directory will be populated with files ending:

distances.txt
jacop.log    
montage.png  

3) Analysis Table Generation

To get various stats about how the foci colocalise and generate a table that can be viewed in any spreadsheet package or as part of Zegami collection, in the main project directory enter:

`perl bin/table.pl > zegami.tab`

This will read all the files in out and then generate zegami.tab

# Notes

When the contents of the 'out' directory are processed by table.pl, as well as the various Distance Based Colocalisation (DBC) and Centre of Mass Colocalisation (CC) measurements, the name/value pairs in the filename will be passed in to the final tab separated output. 
This allows you to filter items and do comparisons in tools such Zegami (http://zegami.com). 

As a very simple example, if you were comparing two slides, one slide a wild type, and one slide a knock out. You could name the two images as condition_wt_1.tif and condition_ko_2.tif respectively. 
When processed by the table.pl command this will give a tab delimited file with a column named "condition" containing 'wt' or 'ko'.


