package Template::Plugin::Clickable;

use strict;
use vars qw($VERSION);
$VERSION = 0.02;

require Template::Plugin::Filter;
use base qw(Template::Plugin::Filter);

use vars qw($DYNAMIC $FILTER_NAME);
$DYNAMIC = 1;
$FILTER_NAME = 'clickable';

use URI::Find;

sub init {
    my $self = shift;
    my $name = $self->{_ARGS}->[0] || $FILTER_NAME;
    $self->install_filter($name);
    return $self;
}

sub filter {
    my($self, $text, $args, $config) = @_;

    my $finder = URI::Find->new(
	sub {
	    my($uri, $orig_uri) = @_;
	    my $target = $config->{target} ? qq( target="$config->{target}") : '';
	    return qq(<a href="$uri"$target>$orig_uri</a>);
	},
    );
    $finder->find(\$text);
    return $text;
}

1;
__END__

=head1 NAME

Template::Plugin::Clickable - Make URLs clickable in HTML

=head1 SYNOPSIS

  [% USE Clickable %]
  [% FILTER clickable %]
  URL is http://www.tt2.org/
  [% END %]

this will become:

  URL is <a href="http://www.tt2.org/">http://www.tt2.org/</a>

=head1 DESCRIPTION

Template::Plugin::Clickable is a plugin for TT, which allows you to
filter HTMLs clickable.

=head1 OPTIONS

=over 4

=item target

  [% FILTER clickable target => '_blank' %]
  [% message.body | html %]
  [% END %]

C<target> option enables you to set target attribute in A links. none
by default.

=back

=head1 NOTE

If you use this module with C<html> filter, you should set this
C<clickable> module B<after> the C<html> filter. Otherwise links will
be also escaped and thus broken.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Template>, L<URI::Find>

=cut
