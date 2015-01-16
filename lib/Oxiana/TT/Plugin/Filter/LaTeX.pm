package Oxiana::TT::Plugin::Filter::LaTeX;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

my $FILTER_NAME = 'LaTeX';
use Data::Dump qw/dump/;
sub init {
    my $self = shift;
    my $var = shift;
    printf STDERR "%s\n%s\n%s\n", ('-' x 80), (dump $var), ('-' x 80);
    $self->install_filter($FILTER_NAME);
 
    return $self;
}

sub filter {
    my $self = shift; my $text = shift;
    printf STDERR "%s\n%s\n%s\n", ('-' x 80), (dump [ map { ref $_ || $_ } @_ ]), ('-' x 80);
    
    # $text =~ s/\s/_/g;
    return $text;
}

1;
