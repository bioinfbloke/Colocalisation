#!/usr/bin/perl -w
use strict;
use Cwd;

my $curr_dir = getcwd;
my $dir="raw";
print STDERR "Current directory ".$curr_dir."\n";

opendir(TIF,$dir) or die $dir;
print "Reading TIFs in dir : $dir\n";
my @tif_files=readdir(TIF);

my $imj_call="ij -batch ".$curr_dir."/bin/segment.ijm";
# quicker to debug stuff
#my $imj_call="/package/imageJ/default/ij -macro ".$curr_dir."/bin/segment.ijm";

foreach my $tif (@tif_files) {
    if ($tif=~/^\./) {
	next;
    }

    #print STDERR "$imj_macro \"$tif\"\n";
    print "$imj_call \"$tif\"\n";
    #my $jacop_log=$curr_dir."/out/".$tif."_jacop.log";
    #print "$tif\t$imj_call \"$tif\"\n";
    system("$imj_call \"$tif\"");
}
