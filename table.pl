#!/usr/bin/perl -w
use strict;
# You should change this to the path where you put Colocalist.pm
use lib '/public/staylor/lib/';
use Colocalise;
use Cwd;
my $path = getcwd;
my $dir="$path/out";
my $row_id=1;
my $txt_body="";
my %header_names;
my $last_file="";
# this is how many tuples to parse in the filename to create metadata
# so these may be queried later as part of a facet so for example
# Condition_WT_TRF2_red_PML_green_1_MergeData.TIF
# Condition_KO_TRF2_red_PML_green_1_MergeData.TIF
# would create the metadata Condition WT for the at images relating to Condition_WT_TRF2_red_PML_green_1_MergeData.TIF
# and Condition KO for the at images relating to Condition_KO_TRF2_red_PML_green_1
my $number_of_tuples_to_parse = 0;


print STDERR "Current directory ".$path."\n";
print STDERR "output dir $dir\n";


opendir(DIR,$dir) || die "Error in opening dir $dir\n";

while( (my $file = readdir(DIR))){
    print STDERR "$file\n";
    # only look at the produced image file montages to get the stub/prefix name
    next if $file=~/^\./ or $file!~/_montage.png/;
    # get the full path of the image
    my $full_path=$dir."/".$file;
    my $num_a_foci=0;
    my $num_b_foci=0;
    my $distance_colocal_A=0;
    my $distance_colocal_B=0;
    my $mass_colocal_A=0;
    my $mass_colocal_B=0;
    	

    #define the id
    my $id=$file;
    $id=~s/_montage\.png//;
    # define the distances file
    my $coloc_distance_file=$full_path;
    $coloc_distance_file=~s/_montage\.png/_distances\.txt/;
    my $jacop_log=$full_path;
    $jacop_log=~s/_montage\.png/_jacop\.log/;

     if (-e $jacop_log) {
    	warn "Parsing jacop log $jacop_log for foci!";
	($num_a_foci,$num_b_foci)=Colocalise::GetFociFromLog($jacop_log);
	warn "num_a_foci,num_b_foci,$num_a_foci,$num_b_foci";
	($mass_colocal_A,$mass_colocal_B)=Colocalise::GetColocalMassParticle($jacop_log);
	warn "mass_colocal_A,mass_colocal_B,$mass_colocal_A,$mass_colocal_B";
	($distance_colocal_A,$distance_colocal_B)=Colocalise::GetColocalDistanceBetweenCentresOfMass($jacop_log);
	warn "distance_colocal_A, distance_colocal_B, $distance_colocal_A, $distance_colocal_B";
    }  
    
    
    # parses the filenames to get the facets
    $txt_body.="$row_id\t$file\t$id"; 
    my @file_name_values=split(/_/,$file);
    my $names_id=0;
    while (@file_name_values and $names_id < $number_of_tuples_to_parse) {
    	my $name=shift(@file_name_values);
	my $value=shift(@file_name_values);	
	$txt_body.="\t$value";
	$header_names{$names_id}=$name;
	$names_id++;
    }    
    
    
            
    $txt_body.="\t$num_a_foci\t$num_b_foci\t$mass_colocal_A\t$mass_colocal_B\t$distance_colocal_A\t$distance_colocal_B\n";
    
    # this just takes the final file name that is processed so it can be used outside the loop
    $row_id++;
}

my $header_names="";
foreach my $header_id (sort {$a<=>$b} keys %header_names) {
	$header_names.="\t".$header_names{$header_id};
}


print "id\tpath\timage$header_names\tnumber of red foci\tnumber of green foci\tCC red foci\tCC green foci\tDBC green foci\n";
print $txt_body;

closedir(DIR);
