INSERT INTO items(mumble1, mumble2, mumble3)
SELECT 'mumble', 'Mumble-' || n, 'Moar Mumble ' || n
FROM (SELECT NEXTVAL('mumble_number') n) q