package Template::Plugin::Clickable;

use strict;
use vars qw($VERSION);
$VERSION = 0.04;

require Template::Plugin;
use base qw(Template::Plugin);

use vars qw($FILTER_NAME);
$FILTER_NAME = 'clickable';

use UNIVERSAL::require;

sub new {
    my($class, $context, @args) = @_;
    my $name = $args[0] || $FILTER_NAME;
    $context->define_filter($name, $class->filter_factory());
    bless { }, $class;
}

sub filter_factory {
    my $class = shift;
    my $sub = sub {
	my($context, @args) = @_;
	my $config = ref $args[-1] eq 'HASH' ? pop(@args) : { };
	return sub {
	    my $text = shift;
	    my $finder_class = $config->{finder_class} || 'URI::Find';
	    $finder_class->require or die $UNIVERSAL::require::ERROR;
	    my $finder = $finder_class->new(
		sub {
		    my($uri, $orig_uri) = @_;
		    my $target = $config->{target} ? qq( target="$config->{target}") : '';
		    return qq(<a href="$uri"$target>$orig_uri</a>);
		},
	    );
	    $finder->find(\$text);
	    return $text;
	};
    };
    return [ $sub, 1 ];
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

=item finder_class

C<finder_class> option enables you to set other URI finder class
rather than URI::Find (default). For example,

  [% FILTER clickable finder_class => 'URI::Find::Schemeless' %]
  Visit www.example.com/join right now!
  [% END %]

this will become:

  Visit <a href="http://www.example.com/join">www.example.com/join</a> right now!

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
