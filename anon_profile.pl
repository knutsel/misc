#!/usr/bin/perl
# quick hack to remove all site specific params from a exported profile.

use warnings;
use strict;

use JSON;
use Data::Dumper;

print Dumper(@ARGV);
my $filename = $ARGV[0];
my $data;
if ( open( my $json_str, $filename ) ) {
  local $/ = undef;
  my $json = JSON->new;
  $data = $json->decode(<$json_str>);
  close($json_str);
}

my $profile;
$profile->{name}        = "EDGE1_621";
$profile->{description} = "ATS 621 default profile";
$profile->{type}        = "ATS_PROFILE";

my @params = @{ $data->{parameters} };
foreach my $oldparm (@params) {
  if ( $oldparm->{config_file} =~ /^cacheurl_/ )    { next; }
  if ( $oldparm->{config_file} =~ /^url_sig_/ )     { next; }
  if ( $oldparm->{config_file} =~ /^hdr_rw_/ )      { next; }
  if ( $oldparm->{config_file} =~ /^regex_remap_/ ) { next; }
  push( @{ $profile->{parameters} }, $oldparm );
}

my $json           = JSON->new->allow_nonref;
my $pretty_printed = $json->pretty->encode($profile);
print $pretty_printed;
