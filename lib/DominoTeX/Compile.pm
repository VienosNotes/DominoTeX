package DominoTeX::Compile;

use 5.10.0;
use strict;
use warnings;
use File::Temp qw/tempfile mkdtemp/;
use IPC::Open3;
use base "Exporter";

our @EXPORT = qw/write_file compile/;

sub write_file {
    my $src = shift;

    mkdir "output" unless -d "output";
    chdir("output");

    my $dir = mkdtemp("XXXXXXXXXXXX");
    my ($fh, $fname) = tempfile("XXXXXXXXXXXXX", DIR => $dir, SUFFIX => ".tex");
    chdir($dir);
    $fh->print($src);
    close($fh);
    chdir("../../");
    return ($dir, substr($fname, 0, -4));
}

sub compile {
    my ($dir, $fname) = @_;
    chdir("output/$dir");
    my $command = "/usr/bin/env platex `basename $fname" . ".tex` && /usr/bin/env dvipdfmx `basename $fname" . ".dvi`";

    my $mesg = "";
    my $errlog = "";
    my ($wtr, $rdr, $err);
    my $pid = open3($wtr, $rdr, $err, $command);
    close $wtr;
    $mesg .= $_ for <$rdr>;
    $errlog .= $_ for <$err>;
    print "ERR:\n" . $errlog;
    print "MESG:\n" . $mesg;
    waitpid($pid, 0);
    chdir("../..");
    return ($?, ($? ? $errlog : $mesg) , $dir, $fname);
}
