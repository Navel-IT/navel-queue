# Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
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

    $options{auto_clean} //= 0;

    croak('auto_clean must be a positive integer') unless isint($options{auto_clean}) > 0;

    bless {
        auto_clean => $options{auto_clean},
        items => []
    }, ref $class || $class;
}

sub enqueue {
    my $self = shift;

    for (@_) {
        $self->dequeue(1) if $self->{auto_clean} && @{$self->{items}} >= $self->{auto_clean};

        push @{$self->{items}}, $_;
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

Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-queue is licensed under the Apache License, Version 2.0

=cut
