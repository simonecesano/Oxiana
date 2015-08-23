package Oxiana::TT::Plugin::Filter::LaTeX;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

use HTML::Format::LaTeX;

use Data::Dump qw/dump/;

sub init {
    my $self = shift;
    my $var = shift;
    # printf STDERR "%s\n%s\n%s\n", ('-' x 80), (dump $var), ('-' x 80);

    my $FILTER_NAME = 'Oxiana::LaTeX';
    $self->install_filter($FILTER_NAME) || die $self->error;
 
    return $self;
}

sub filter {
    my $self = shift; my $text = shift;

    my $f = HTML::Format::LaTeX->new;
    $f->parse($text);
    $text = $f->translate();

    # $text = '%% ' . $text; 
    # $text =~ s/\n/\n%% /gi;
    # $text = '%% this is the text';
    return $text;
}

1;
