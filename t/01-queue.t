# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-queue is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

BEGIN {
    use_ok('Navel::Queue');
}

#-> main

my $queue;

my $items = 5;

lives_ok {
    $queue = Navel::Queue->new(
        size => $items
    );
} 'making the queue';

lives_ok {
    $queue->enqueue(1..$items * 2);
} 'enqueue ' . $items . ' items';

ok(@{$queue->{items}} == $items, 'check if enqueue worked (' . @{$queue->{items}} . ' == ' . $items . ')');

lives_ok {
    $queue->dequeue;
} 'dequeue';

ok(@{$queue->{items}} == 0, 'check if dequeue worked (' . @{$queue->{items}} . ' == 0)');

#-> END

__END__
