\set mumble_random random(1,100000000000000)

INSERT INTO items(mumble1, mumble2, mumble3)
    SELECT 'mumble', 'Mumble-' || n, 'Moar Mumble ' || n
    FROM (SELECT nextval('mumble_number') n) q;
