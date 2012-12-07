package DominoTeX::Web::Dispatcher;
use 5.10.0;
use strict;
use warnings;
use utf8;
use DominoTeX::Compile;
use Amon2::Web::Dispatcher::Lite;

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

    my ($ret, $log) = compile(write_file($src));

    $c->render('result.tt' => { log => $log , ret => $ret });


};

1;
