use strict;
use warnings;


BEGIN {
    use FindBin;
    chdir "$FindBin::Bin/..";
}
use lib "lib";
use Data::Dump 'pp';

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use File::Find;

my @other_files = 'Changes';
my @lib_files;

find(sub { push @lib_files, $File::Find::name if -f }, 'lib');

my %v;
my $diff = 0;
for my $f (@lib_files) {
    my $v = MM->parse_version($f);
    $v{$f} = $v;
    $diff ||= $diff ne $v;
}

if ($diff) {
    pp \%v;
    fail "Consistent versions";
    diag "    $_ => $v{$_}" for sort keys %v;
}
else { pass "Consistent versions" }
