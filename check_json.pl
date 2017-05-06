#!/usr/bin/env perl

use warnings;
use strict;
use Getopt::Std;
use LWP::UserAgent;
use JSON 'decode_json';

my $plugin_name = "Nagios check_consul_services_in_critical_state";
my $VERSION = "1.0.0";

# getopt module config
$Getopt::Std::STANDARD_HELP_VERSION = 1;

# nagios exit codes
 use constant EXIT_OK            => 0;
 use constant EXIT_WARNING       => 1;
 use constant EXIT_CRITICAL      => 2;
 use constant EXIT_UNKNOWN       => 3;


my $status = EXIT_UNKNOWN;

#parse cmd opts
my %opts;
getopts('vU:t:', \%opts);
$opts{t} = 5 unless (defined $opts{t});
if (not (defined $opts{U}) ) {
        print "ERROR: INVALID USAGE\n";
        HELP_MESSAGE();
        exit $status;
}

my $ua = LWP::UserAgent->new;

$ua->agent('Redirect Bot ' . $VERSION);
$ua->protocols_allowed( [ 'http', 'https'] );
$ua->parse_head(0);
$ua->timeout($opts{t});

my $response = $ua->get($opts{U} . "/v1/health/state/critical");

if ( index($response->header("content-type"), 'application/json') == -1 )
{
  print "Expected content-type to be application/json, got ", $response->header("content-type");
  exit EXIT_CRITICAL;
}

if ($response->content ne "[]")
{
  print "Found services in 'critical' state: ", $response->content;
  exit EXIT_CRITICAL;
}

exit EXIT_OK;

sub HELP_MESSAGE 
{
        print <<EOHELP
        Retrieve an http/s url and checks its application type is application/json and the response content decodes properly into JSON.  
        Optionally verify content is found using data file.
        
        --help      shows this message
        --version   shows version information

        USAGE: $0 -U http://consul-host:port

        -U          Consul URL (http or https)
        -t          Timeout in seconds to wait for the URL to load (default 60)

EOHELP
;
}


sub VERSION_MESSAGE 
{
        print <<EOVM
$plugin_name v. $VERSION
Copyright 2012, Brian Buchalter, http://www.endpoint.com - Licensed under GPLv2
Modified  2017, jihor,           http://www.rgs.ru

EOVM
;
}
