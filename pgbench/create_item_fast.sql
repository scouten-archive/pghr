\set mumble_random random(1,100000000000000)

INSERT INTO items(mumble1, mumble2, mumble3)
    VALUES ('mumble', 'Mumble-' || :mumble_random, 'Moar Mumble ' || :mumble_random);
