#!/usr/bin/perl -w
use strict;
use Cwd;
my $curr_dir = getcwd;
my $dir="in";
print STDERR "Current directory ".$curr_dir."\n";

opendir(TIF,$dir) or die $dir;
print "dir = $dir\n";
my @tif_files=readdir(TIF);

my $imj_call="ij -batch ".$curr_dir."/bin/coloc.ijm";

foreach my $tif (@tif_files) {
    if ($tif=~/^\./) {
	next;
    }
    my $jacop_log=$curr_dir."/out/".$tif."_jacop.log";
    print "$tif\t$imj_call \"$tif\"\n";    
    system("$imj_call \"$tif\" > $jacop_log");
    #exit;
}
