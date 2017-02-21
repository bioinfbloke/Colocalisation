# Colocalisation
A simple Perl and ImageJ colocalisation analysis pipeline.This currently takes a directory image files as input to the pipeline. The image files currently supported are 3 Channel (RGB) forma TIFF files.

# Dependencies
ImageJ must be installed
Perl 5.18.1
Runs on Linux
JaCoP plugin must be installed (see http://imagejdocu.tudor.lu/doku.php?id=plugin:analysis:jacop_2.0:just_another_colocalization_plugin:start)

# Getting Started
Create a project directory and subdirectories e.g. 

mkdir coloc_1
cd coloc_1
mkdir bin raw in out

Each new batch will need its own directory structure. In the bin directory place the Perl and ImageJ (ijm) files. In the raw directory place the image files. These should be named as name value pairs which will allow you to do comparisons later, so for example:

DAPI_Blue_53BP1_Green_PML_Red_Sample_1_type_RGB.tif

See 'Notes' for why...

# Running the Pipeline

Due the variability of the image data the tools need to be run also interactively. I used Zegami to view he files and do analysis on them which saved a lot of time with regards to QCing the data.

# Notes

When this is processed by table.pl, as well as the various Distance Based Colocalisation (DBC) and Centre of Masss Colocalisation (CC) measurements, there will also be the values passed in to the final tab separated output. This allows you to filter items and do comparisons in tools such Zegami (http://zegami.com). For example you may treat the cells with different levels of drug, so if you name a set of files with drug_1 and then another set of files drug_2 then you will have a column called 'drug' containing 1 or 2 for each row.


