package Colocalise;
use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(&InitFile &GetColocalDistance &GetFoci &GetFociFromLog &GetColocalMassParticle &GetColocalDistanceBetweenCentresOfMass);
%EXPORT_TAGS = ( DEFAULT => [qw(&InitFile &GetColocalDistance &GetFoci &GetFociFromLog &GetColocalMassParticle)],
                 Both    => [qw(&InitFile &GetColocalDistance &GetFoci)]);


# correction factor in nm
my $XYNM=70;

sub InitFile {
	my ($file)=@_;
	open(COLOC,$file) or die $!.$file;
	my @file=<COLOC>;
	if ($file[0]=~"Centre_A_n°	Centre_B_n°	d(A-B)	reference_dist	phi	theta	XA	YA	ZA	XB	YB	ZB") {
		die "Distance colocalisation file header not recognised!\n\n".$file[0]."\n";
	}
	shift(@file);
	print STDERR "Examining $file ...\n";
	return @file;
}

sub GetColocalDistance {
	my (@file)=@_;
	my %fociA;
	my %fociB;
	my $num_coloc=0;
	foreach my $line (@file) {
		chomp($line);
		my ($id,$centreA,$centreB,$dAB,$reference_dist,$phi,$theta,$XA,$YA,$ZA,$XB,$YB,$ZB)=split(/\s+/,$line);
		my $corrected_dAB=$dAB*$XYNM;
		#print STDERR "$line\t$corrected_dAB\n";

		if ($corrected_dAB<=$reference_dist) {
		    $fociA{$XA.$YA.$ZA}=1;
		    $fociB{$XB.$YB.$ZB}=1;
		}
	}

	my $colocalisedA=scalar(keys %fociA);
	my $colocalisedB=scalar(keys %fociB);
	return ($colocalisedA,$colocalisedB);

}

sub GetFoci {
	my (@file)=@_;
	my %fociA;
	my %fociB;

	foreach my $line (@file) {
		chomp($line);
		my ($centreA,$centreB,$dAB,$reference_dist,$phi,$theta,$XA,$YA,$ZA,$XB,$YB,$ZB)=split(/\s+/,$line);
		$fociA{$XA.$YA.$ZA}=1;
		$fociB{$XB.$YB.$ZB}=1;

	}
	my $num_foci_A=scalar(keys %fociA) || 0;
	my $num_foci_B=scalar(keys %fociB) || 0;

	return ($num_foci_A,$num_foci_B);
}

sub GetFociFromLog {
    my ($file)=@_;
    my $foci_A=0;
    my $foci_B=0;

    open(LOG,$file) or die $!." ".$file;
    while(<LOG>) {
	if (/Colocalization based on centres of mass-particles coincidence/) {
	    $_=<LOG>;
	    $_=<LOG>;
	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$foci_A=$2;
		#print "$c_comp_A\t";
	    }

	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$foci_B=$2;
		#print "$c_comp_B\n";
	    }
	}
    }
    return($foci_A,$foci_B);
}

sub GetColocalMassParticle {
    my ($file)=@_;
    my $coloc_foci_A=0;
    my $coloc_foci_B=0;
    my $total_foci_A=0;
    my $total_foci_B=0;

    open(LOG,$file) or die $!." ".$file;
    while(<LOG>) {
	if (/Colocalization based on centres of mass-particles coincidence/) {
	    $_=<LOG>;
	    $_=<LOG>;
	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$coloc_foci_A=$1;
		$total_foci_A=$2;
	    }

	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$coloc_foci_B=$1;
		$total_foci_B=$2;
		return($coloc_foci_A,$coloc_foci_B,$total_foci_A,$total_foci_B);
	    }
	}
    }
    warn "There has been a problem in $file parsing so returning 0 so not break cxml";
    return(0,0,0,0);
}

sub GetColocalDistanceBetweenCentresOfMass {
    my ($file)=@_;
    my $coloc_foci_A=0;
    my $coloc_foci_B=0;
    my $total_foci_A=0;
    my $total_foci_B=0;


    open(LOG,$file) or die $!." ".$file;
    while(<LOG>) {
	if (/Colocalization based on distance between centres of mass/) {
	    $_=<LOG>;
	    $_=<LOG>;
	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$coloc_foci_A=$1;
		$total_foci_A=$2;
	    }

	    $_=<LOG>;

	    if (/(\d+) centre\(s\) colocalizing out of (\d+)/) {
		$coloc_foci_B=$1;
		$total_foci_B=$2;
	        return($coloc_foci_A,$coloc_foci_B,$total_foci_A,$total_foci_B);
	    }
	}
    }
    
    warn "There has been a problem in $file parsing so returning 0 so not break cxml";
    return(0,0,0,0);
}

1;
