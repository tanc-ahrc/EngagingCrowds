#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;

our %subst = ();

sub load_subst {
  my ($thing) = @_;
  $thing = basename($thing);
  open(INPUT, $thing) or die 'Problem opening '.${thing};
  $subst{$thing} = '';
  foreach(<INPUT>) {
    chomp;
    $subst{$thing} .= $_;
  }
  close INPUT;
}

foreach my $file (glob(dirname($0).'/*.html')) {
  load_subst($file)
}

open(INPUT, 'pages_in.json') or die;
open(OUTPUT, '>pages.json') or die;
while(<INPUT>) {
  my $line = $_;
  while(my ($k, $v) = each(%subst)) {
    if($line =~ m#^\s*"content": *"$k"$#) {
      print 'Inserting '.$k."\n";
      $line =~ s/$k/$v/;
    }
  }
  print OUTPUT $line;
}
close OUTPUT;
close INPUT;
