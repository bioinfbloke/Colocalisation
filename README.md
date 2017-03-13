# Colocalisation
A simple Perl and ImageJ colocalisation analysis pipeline. This currently takes a directory of image files as input to the pipeline and produces a series of montages of the segmentation/colocalisation process and a table of statistics about the cells analysed. The image files currently supported are 3 Channel (RGB) format TIFF files.

# Dependencies
* ImageJ must be installed. Fiji should work (though not tested). On our system ImageJ is aliased to `ij` and this application is called in `segment.pl` and `coloc.pl`. Replace this with the path of your Imagej or Fiji installation.
* Perl 5+
* JaCoP plugin must be installed (see http://imagejdocu.tudor.lu/doku.php?id=plugin:analysis:jacop_2.0:just_another_colocalization_plugin:start)
* Runs on Linux  (Centos 6, though most Linux flavours should be ok)
* There is a module called `Colocalise.pm` which is called in the script `table.pl` and if not installed in a standard location then needs to be set in PERL5LIB or in the top of the script (which I have done on line 4).


# Getting Started
Create a project directory and subdirectories on your file system e.g. 

`mkdir coloc_1; cd coloc_1; mkdir raw in out;` 

git clone the Colocalisation pipeline which will create a directory called Colocalisation:

`git clone https://github.com/bioinfbloke/Colocalisation.git`
 
now we`ll make a symlink to the Colocalisation directory

`ln -s Colocalisation bin`

Each new batch of image files will need its own project directory.


# Input files

The input files supported are merged RGB colour, maximum projection TIFs. Image analysis wise this is probably not the best format, but is a reflection of the data I have been supplied with in the past. 
If the pipeline develops, I may update it to work with 16 bit images.
Place the image files in the `raw` directory. These files can be named as name/value pairs which will allow you to do comparisons later. See *Notes* section below:

# Running the Pipeline

There are three main stages and to run each stage you should `cd` to the main project directory (in our example `cd coloc_1`). 

**1) Segmentation**

In the main project directory enter:

`perl bin/segment.pl`

Before running, you will almost may need to edit the function in bin/segment.ijm called at line 21 "SegmentNuclei" depending on the the type of nuclei you want to segment. This might take some experimentation!

This operation should populate the `in` directory with segmented out nuclei images. So there may be lots of these if you have lots of widefield images in `raw`.

**2) Colocalisation**

In the main project directory enter:

`perl bin/coloc.pl`

Before running, you may need to edit the command starting line 56 (//auto threshold for red) and line 66 (//auto threshold for green)
because here you are thesholding the foci so they may analysed by the JaCoP plugin. Again this might take some experimentation to get right initially. The code will then analyse all the segmented out images in (1).
When this step runs you *must* have X set up because the plugin causes ImageJ windows to open up for each image and then close. This is annoying and I haven't found a way to stop this without breaking JACoP. 

If all goes to plan then the `out` directory will be populated with files ending:

* *_distances.txt
* *_jacop.log    
* *_montage.png  

**3) Analysis Table Generation**

To get various stats about how the foci colocalise and generate a table that can be viewed in any spreadsheet package or as part of Zegami collection, in the main project directory enter:

`perl bin/table.pl > zegami.tab`

This will read all the files in `out` and then generate the file `zegami.tab`


# Visualisation
I use Zegami (https://zegami.com) to view and analyse the resulting data files. There is a free for academic version and commercial version available. The paper

**Clynes et al.** *Suppression of the alternative lengthening of telomere pathway by the chromatin remodelling factor ATRX.* Nat Commun. 2015 Jul
(https://www.ncbi.nlm.nih.gov/pubmed/26143912)

refers to various results using Zegami, but here is one example showing the colocalisation of TRF2 vs PML (http://zegami.molbiol.ox.ac.uk/collections/TRF2_PML_1/)

# Notes

When the contents of the `out` directory are processed by `table.pl`, as well as the various Distance Based Colocalisation (DBC) and Centre of Mass Colocalisation (CC) measurements, 
the name/value pairs in the filename will be passed in to the final tab separated output. This allows you to filter items and do comparisons in a spreadsheet, R, or Zegami. 

As a very simple example, if you were comparing two slides, one slide a wild type, and one slide a knock out. You could name the two images as condition_wt_1.tif and condition_ko_2.tif respectively. 
When processed by the `table.pl` command this will give a tab delimited file with a column named "condition" containing 'wt' or 'ko'.


