#!/usr/bin/perl

use warnings;
use strict;

# Include the local directory to LIB
#use FindBin qw($Bin);
#use lib "$Bin/lib";

#use POE::Profiler;

use POE;
use POE::Component::Server::HTTP;
use HTTP::Status qw/RC_OK/;

POE::Component::Server::HTTP->new
  ( Port => 32080,
    ContentHandler => { "/" => \&web_handler },
    Headers => { Server => 'POE Cookbook POE::Component::Server::HTTP Sample',
    },
  );

sub web_handler {
    my ( $request, $response ) = @_;

    # Slurp in the program's source.
    seek( DATA, 0, 0 );
    local $/;
    my $source = <DATA>;

    # Build the response.
    $response->code(RC_OK);
    $response->push_header( "Content-Type", "text/plain" );
    $response->content("This program's source:\n\n$source");

    # Signal that the request was handled okay.
    return RC_OK;
}

POE::Session->create(
    'inline_states' => {
	'_start'	=>	sub {
	    $_[KERNEL]->alias_set( 'TestSession' );
	    $_[KERNEL]->alarm_set( 'alarmset', 5 );
	    $_[KERNEL]->delay_set( 'delayset', 10 );
	    $_[KERNEL]->yield( 'yielding' );
	    $_[KERNEL]->post( $_[SESSION], 'posting' );
	    $_[KERNEL]->call( $_[SESSION], 'calling' );
	    $_[KERNEL]->post( 'PoCo::Server::HTTP::2', 'floobarz' );
	},
    },
);

$poe_kernel->run();

__END__