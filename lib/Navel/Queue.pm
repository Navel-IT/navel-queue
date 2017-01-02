# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-queue is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Queue 0.1;

use Navel::Base;

use Navel::Utils qw/
    isint
    croak
/;

#-> methods

sub new {
    my ($class, %options) = @_;

    $options{size} //= 0;

    croak('size must be a positive integer') unless isint($options{size}) > 0;

    bless {
        size => $options{size},
        items => []
    }, ref $class || $class;
}

sub size_left {
    my $self = shift;

    $self->{size} ? $self->{size} - @{$self->{items}} : -1;
}

sub enqueue {
    my $self = shift;

    my $size_left = $self->size_left;

    if ($size_left < 0 || $size_left >= @_) {
        push @{$self->{items}}, @_;
    } else {
        my $to_splice;

        if (@_ >= $self->{size}) {
            $self->dequeue();

            $to_splice = $self->{size};
        } else {
            $self->dequeue(@_ - $size_left);

            $to_splice = $self->size_left;
        }

        push @{$self->{items}}, splice @_, -$to_splice;
    }

    $self;
}

sub dequeue {
    my ($self, $size) = @_;

    my @items;

    if (defined $size) {
        croak('size must be a positive integer') unless isint($size) > 0;

        @items = splice @{$self->{items}}, 0, $size;
    } else {
        @items = @{$self->{items}};

        undef @{$self->{items}};
    }

    \@items;
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Queue

=head1 COPYRIGHT

Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-queue is licensed under the Apache License, Version 2.0

=cut
