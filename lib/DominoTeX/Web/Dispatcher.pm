package DominoTeX::Web::Dispatcher;
use 5.10.0;
use strict;
use warnings;
use utf8;
use DominoTeX::Compile;
use Amon2::Web::Dispatcher::Lite;

our $DEBUG = 1;


any '/' => sub {
    my ($c) = @_;
    $c->render('index.tt');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    $c->redirect('/');
};

get '/test' => sub {
    die "called";
};

post '/compile' => sub {
    my $c = shift;
    my $src = $c->req->param("src");

    my ($ret, $log, $dir, $fname);

    if ($DEBUG == 0) {
        ($ret, $log, $dir, $fname) = compile(write_file($src));
    } else {
        if ($src =~ /^0/) {
            $ret = 0;
            $log = $src;
            $dir = "output/sample";
        } else {
            $ret = 1;
            $log = $src;
            $dir = "output/sample";
        }
    }

    if ($ret != 0) {
        $c->render('compile_error.tt' => { log => $log, ret => $ret });
    } else {
        opendir(my $dh, $dir);
        my @entry = readdir $dh;
        closedir $dh;
        my @png = grep {/^pv_/}  @entry;
        $c->render('success.tt' => { log => $log, dir => $dir, uri_dvi => 'output/sample/YOmRw_iL3VH6i.dvi', list => \@png });
    }
};

1;
