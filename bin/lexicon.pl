#!/usr/bin/env perl
use 5.14.2;
use warnings;
use JSON;
open my $fh, '<', shift || 'IJ.json' or die $!;
my $IJ = from_json(join('', <$fh>), { utf8 => 0 });
close $fh;
my %lexicon;

sub scan {
    my $v = shift;
    if (ref $v eq "ARRAY") {
        scan($_) for @$v;
    }
    elsif (ref $v eq "HASH") {
        scan($_) for values %$v;
    }
    elsif ($v =~ /[A-Za-z]/) {
        $lexicon{$v}++;
    }
}

for my $section (@$IJ) {
    for (keys %$section) {
        next if /^(chapter|section|synopsis)$/;
        scan($section->{$_});
    }
}

say "$lexicon{$_}\t$_" for sort keys %lexicon;
